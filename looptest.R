'looptest' <- function(n = 1e8, n.factor = c(1, 1, 1, 1, 1e2, 1e3, 1e4), acres  = c(1, 10, 100, 1000, 1e4, 1e5, 1e6), 
                                   best.pct = 0.5, layers = c('forests', 'ridgetops', 'wetlands', 'floodplains' ), 
                                   server.names = c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest'),
                                   sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/', postfix = '', 
                                   threshold = 0.25) {
   
   
   # Calculate percentiles of simulated parcels of ecoConnect layers and save files for ecoConnect.tool
   # In the previous version, I was sampling 100 million cells in each layer. It's not perfectly stable, but close.
   # Source data created by prep.ecoConnect.quantiles.R
   # 
   # Arguments:
   #   n                   number of samples 
   #   n.factor            vector corresponding to acres, with factor to reduce sample size, dropping sample sizes for larger blocks
   #   acres               target parcel sizes in acres (must be ordered smallest to largest)
   #   best.pct            top percent of pseudoparcels for "best," as proportion 
   #   layers              source system names
   #   server.names        names used on server, to be written to result data frame
   #   sourcepath          path for source TIFFs
   #   postfix             add to the end of result filenames
   #   threshold           maximum proportion of missing cells to be counted as a good sample
   #   
   # Source data (in sourcepath):
   #   shindex.tif         index grid for states and HUC8s, with nodata for all cells that should be masked out (marine, estaurine, freshwater tidal)
   #   stateinfo           table of state classes and state names
   #   hucinfo             table of HUC8 classes and 8 digit HUC8 code
   #
   # Result (written to sourcepath):
   #   ecoConnect_quantiles.RDS
   #     RDS with three arrays
   #        full, state, huc
   #     each with 5 dimensions
   #        1. region (full = 1, state = 14, huc = 245)
   #        2. acres (5 or 6)
   #        3. systems (4)
   #        4. all/best (2)
   #        5. percentiles (100)
   #     and 2 tables
   #        stateinfo and hucinfo
   #   sample_sizes_full.txt
   #   sample_sizes_state.txt
   #   sample_sizes_huc.txt
   #     tables of region/state name/huc ID by acres with sample sizes
   #     
   #  realized.acres (printed to console)
   #     a conversion from nominal acres to actual acerage of pseudoparcels. Use this in make.report.percentiles when interpolating percentiles for a given parcel.
   #     
   # Notes:
   #    - blocks with NA in the center cell are rejected, as are any blocks that are more than threshold missing
   #    - we're reading the max block size if there are any nodata cells in block, which will be inefficient near edges
   #      where smaller blocks have enough data but larger ones don't, but I'm opting for simplicity and clarity over speed
   #    - we use n.factor to drop sample sizes for larger blocks, which take a long time, and we care less about precision for them, as percentiles have
   #      less range, and it'll be rare for target area to be huge anyway
   #    - this revised version keeps rasters in memory for a big speedup, but it's a memory hog--you'll need >> 64 GB
   # 
   # B. Compton, 12 Sep 2024 (from ecoConnect.big.quantiles)
   
   
   
   call.args <- as.list(environment())
   
   
   library(terra)
   library(lubridate)
   library(progressr)
   
   launch <- now()
   ts <- Sys.time()
   
   
   handlers(global = TRUE)                                                                      # for progress bar
   handlers('rstudio')
   skip <- 100                                                                                   # report progress every skipth iteration
   pb <- progressor(n / skip)
   
   if(!all(acres == sort(acres)))
      stop('acres must be in ascending order (and correspond with n.factor, if supplied')
   if(length(n.factor) == 1)
      n.factor <- rep(n.factor, length(acres))
   if(length(n.factor) != length(acres))
      stop('n.factor and acres must correspond')
   
   
   'read.tiff' <- function(x) {                                                                 # Read an entire geoTIFF into memory as a matrix
      cat('Reading ', x, '...\n', sep = '')
      z <- rast(x)
      matrix(z, dim(z)[1], dim(z)[2], byrow = TRUE)
   }
   
   'index.block' <- function(x, s, indices = 0) {                                               # Index block of a matrix allowing indices beyond edges
      i <- list(s[1] + indices, s[2] + indices)                                                 #    row and column indices
      z <- x[pmin(pmax(i[[1]], 1), dim(x)[1]), pmin(pmax(i[[2]], 1), dim(x)[2]), drop = FALSE]                #    push indices beyond edges to 1st/last row/column
      z[(i[[1]] < 1) | (i[[1]] > dim(x)[1]), ] <- NA                                              #    now set rows and columns beyond edges to NA
      z[, (i[[2]] < 1) | (i[[2]] > dim(x)[2])] <- NA
      z
   }
   
   'set.up.indices' <- function(idx, n, n.factor, i = 1) {                                      # Select block indices for current acerages; recall when dropping block sizes due to n.factor
      b <- i <= n / n.factor                                                                    #    block sizes we're still doing
      if(!any(b)) 
         return(NULL)
      idx$acres <- idx$acres[b]                                                                 #    select all of these to current block sizes
      idx$w <- idx$w[b]
      idx$thresholds <- idx$thresholds[b]
      idx$rel.indices <- idx$rel.indices[b]
      idx$n <- idx$n[b]
      idx$n.factor <- idx$n.factor[b] 
      
      idx$max.block <- max(idx$w)                                                               #    maximum block size - this is what we'll always read
      idx$block.idx <- idx$rel.indices[[length(idx$rel.indices)]]                               #    relative indices for full block (we'll use this inside loop)
      idx$block.indices <- lapply(idx$rel.indices, function(x) x + ceiling(idx$max.block / 2))  #    indices for each block size, absolute for max block 
      idx$next.drop <- min(idx$n / idx$n.factor)                                                #    we'll revisit this when we reach this iteration
      idx
   }
   
   'unpack' <- function(x)                                                                      # unpack state and HUC ids
      c(floor(x / 1000), x - floor(x / 1000) * 1000)
   
   
   
   # come up with indices for each specified acreage 
   cells.per.acre <- 4.496507136                                                                # 1 acre = 4.5 cells
   idx <- list(acres = acres)
   idx$w <- sqrt(idx$acres * cells.per.acre)                                                    # convert acres to width in cells
   idx$w <- ifelse((floor(idx$w) %% 2) != 0, floor(idx$w), ceiling(idx$w))                      # pick nearest odd width in cells
   idx$thresholds <- idx$w^2 * threshold                                                        # NA thresholds in cells for each block size 
   realized.acres <- idx$w^2 / cells.per.acre                                                   # realized acres - use for interpolation
   
   idx$rel.indices <- lapply(idx$w, function(x) -floor(x / 2):floor(x / 2))                     # indices for each block size, relative to center
   idx$n <- rep(n, length(acres))
   idx$n.factor <- n.factor
   
   idx <- set.up.indices(idx, n, n.factor)                                                      # set up indices; to be amended when we drop block sizes based on n.factor                                                                 
   
   
   # read source data
   shindex <- read.tiff(paste0(sourcepath, 'shindex.tif'))                                      # combined state/HUC8 index and mask
   lays <- lapply(layers, function(x) read.tiff(paste0(sourcepath, 'ecoConnect_', x, '.tif')))  # ecoConnect layers
   sinfo <- read.table(paste0(sourcepath, 'stateinfo.txt'), sep = '\t', header = TRUE)          # we'll use these for sample size tables
   hinfo <- read.table(paste0(sourcepath, 'hucinfo.txt'), sep = '\t', header = TRUE)
   
   
   # create results
   statehuc <- data.frame(matrix(NA, n, 2))
   names(statehuc) <- c('state', 'huc')            # state and HUC8 for each sample
   z <- array(NA, dim = c(n, length(idx$w), length(layers), 2))                                 # row x acres x systems x all/best
   cat('Gathering ', format(n, scientific = FALSE, big.mark = ','), ' samples...\n', sep = '')
   
   # gather samples
   for(i in 1:n) {                                                                              # For each sample,
      success <- FALSE
      while(!success) {                                                                         #    until we find a live one,
         s <- round(runif(2) * dim(shindex)[1:2])                                               #    index of sample
         if(!is.na(index.block(shindex, s, 0))) {                                               #    if focal cell has data,
            sh <- index.block(shindex, s, idx$block.idx)                                        #       read shindex for block
            if(any(!is.na(sh))) {                                                               #       If there are any data, continue
               got.layers <- FALSE
               for(j in 1:length(idx$acres)) {                                                  #          for each block size,
                  if(sum(is.na(sh[idx$block.indices[[j]], idx$block.indices[[j]]])) > 
                     idx$thresholds[j])                                                         #          bail if too many missing cells   
                     next
                  if(!got.layers) {                                                             #                if we don't have data yet,
                     lay.vals <- lapply(lays, function(x) index.block(x, s, idx$block.idx))     #                   read current block of all 4 ecoConnect layers as matrices
                     got.layers <- TRUE
                     success <- TRUE
                  }
                  
                  for(k in 1:length(layers)) {                                                  #             for each layer,
                     y <- lay.vals[[k]][idx$block.indices[[j]], idx$block.indices[[j]]]         #                pull out subblock
                     y[is.na(sh[idx$block.indices[[j]], idx$block.indices[[j]]])] <- NA         #                mask from shindex
                     z[i, j, k, 1] <- mean(y, na.rm = TRUE)                                     #                sample all values
                     z[i, j, k, 2] <- mean(y[y >= quantile(y, best.pct, na.rm = TRUE)], 
                                           na.rm = TRUE)                                        #                sample top best.pct
                  }
               }
               
               statehuc[i, ] <- unpack(sh[ceiling(idx$max.block / 2), 
                                          ceiling(idx$max.block / 2)])                          #       get state and HUC ids
               if(i %% skip == 0)                                                               #       update progress bar every nth iteration
                  pb()
            }
         }
      }
      if(i >= idx$next.drop)                                                                    #    if it's time to drop samples,
         if(is.null(idx <- set.up.indices(idx, n, n.factor, i + 1)))                            #       drop 'em
            break
   }
   
   
   
   # Intermediate result z is 4d array of row x acres x systems x all/best
   # Result quantiles.* are 5d arrays of region x acres x systems x all/best x 100 with percentiles
   # Result samples.* are 2d arrays of region x acres with sample sizes
   
   cat('Calculating percentiles...\n')
   rc <- c(1, max(sinfo$class), max(hinfo$class))                                               # number of classes in each region (1 for full, 14 states, 245 HUCs)
   
   
   # Now take percentiles and sample sizes
   for(h in 1:length(rc)) {                                                                     # For each set of regions,
      dn <- list(regions = 1:rc[h], acres = gsub(' ', '', format(acres)), layers = layers, 
                 all.best = c('all', 'best'), percentile = 1:100)                               #    array names
      qu <- array(NA, dim = c(rc[h], length(acres), length(layers), 2, 100), dimnames = dn)     #    quantiles for region set
      ss <- array(NA, dim = c(rc[h], length(acres)))                                            #    sample sizes for region set
      for(i in 1:rc[h]) {                                                                       #    For each region,
         if(h == 1)                                                                             #       Select samples that fall in region
            y <- z
         else {
            if(!i %in% statehuc[, h - 1])                                                       #       just to be safe, though all states and HUCs should be represented
               next
            y <- z[statehuc[, h - 1] == i, , , , drop = FALSE]
         }
         for(j in 1:dim(y)[2]) {                                                                #       For each block size (we might not have all acerages),
            ss[i, j] <- sum(!is.na(y[ , j, 1, 1]))                                              #          collect sample sizes (identical across systems and all/best)
            for(k in 1:length(layers)) {                                                        #          For each layer,
               for(l in 1:2) {                                                                  #             For all/best,   
                  qu[i, j, k, l, ] <- quantile(y[, j, k, l], 
                                               prob = seq(0.01, 1, by = 0.01),  
                                               na.rm = TRUE, names = FALSE)                     #                take percentiles
               } 
            }  
         }
      }
      
      ss[is.na(ss)] <- 0
      switch(h, {                                                                               # save results to appropriate region variable
         quantiles.full <- qu
         samples.full <- data.frame(ss)
         names(samples.full) <- acres
      },
      {
         quantiles.state <- qu
         samples.state <- data.frame(cbind(sinfo$postal[match(sinfo$class, 1:dim(sinfo)[1])]), ss)
         names(samples.state) <- c('Postal', acres)
      },
      {
         quantiles.huc <- qu
         samples.huc <- data.frame(cbind(hinfo$HUC8_code[match(hinfo$class, 1:dim(hinfo)[1])]), ss)
         names(samples.huc) <- c('HUC8_code', acres)
         
      })
      
      cat('Finished calculating quantiles for ', c('full region', 'states', 'HUC8s')[h], '.\n', sep = '')
   }
   
   
   cat('Writing results...\n')
   if(postfix != '')
      postfix <- paste0('_', postfix)
   
   x <- list(full = quantiles.full, state = quantiles.state, huc = quantiles.huc, stateinfo = sinfo, hucinfo = hinfo)
   saveRDS(x, f <- paste0(sourcepath, 'ecoConnect_quantiles', postfix, '.RDS'))               # write quantiles to RDS
   
   write.table(samples.full, paste0(sourcepath, 'sample_sizes_full', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)          # write sample size text files
   write.table(samples.state, paste0(sourcepath, 'sample_sizes_state', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   write.table(samples.huc, paste0(sourcepath, 'sample_sizes_huc', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   
   elapsed <- format(seconds_to_period(round(as.duration(interval(ts, Sys.time())))))
   
   fileConnect <- file(filename <- paste0(sourcepath, 'metadata', postfix, '.txt'))            # write metadata file
   x <- (paste0('Metadata for ecoConnect.quantiles run launched ', launch))
   x <- c(x, paste0('Total time taken: ', elapsed, '\n'))
   x <- c(x, paste0('realized.acres <- c(', paste0(round(realized.acres, 4), collapse = ', '),
                    ') # Realized acres for interpolation\n'))
   x <- c(x, 'Arguments:\n')
   writeLines(x, fileConnect)
   close(fileConnect)
   
   sink(filename, append = TRUE)
   print(call.args)
   sink()
   
   cat('Results written to ', sourcepath, '*', postfix, '.*\n', sep = '')
   cat('Total time taken: ', elapsed, '\n', sep = '')
}
