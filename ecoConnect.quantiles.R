'ecoConnect.quantiles' <- function(n = 10000, acres  = c(1, 10, 100, 1000), best.pct = 0.5, 
                                   layers = c('forests', 'ridgetops', 'wetlands', 'floodplains' ), 
                                   server.names = c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest'),
                                   sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/', 
                                   threshold = 0.25) {
   
   
   # Calculate percentiles of simulated parcels of ecoConnect layers and save files for ecoConnect.tool
   # In the previous version, I was sampling 100 million cells in each layer. It's not perfectly stable, but close.
   # Source data created by prep.ecoConnect.quantiles.R
   # 
   # Arguments:
   #   n                   number of samples
   #   acres               target parcel sizes in acres                             *** want to include 1e4, 1e5 for final run
   #   best.pct            top percent of pseudoparcels for "best," as proportion 
   #   layers              source system names
   #   server.names        names used on server, to be written to result data frame
   #   sourcepath          path for source TIFFs
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
   #        quantiles.full, quantiles.state, quantiles.huc
   #     each with 5 dimensions
   #        1. region (full = 1, state = 14, huc = 245)
   #        2. acres (5 or 6)
   #        3. systems (4)
   #        4. all/best (2)
   #        5. percentiles (100)
   #   sample_sizes_full.txt
   #   sample_sizes_state.txt
   #   sample_sizes_huc.txt
   #     tables of region/state name/huc ID by acres with sample sizes
   #     
   #  realized.acres (printed to console)
   #     a conversion from nominal acres to actual acerage of pseudoparcels. Use this in _________________ when interpolating percentiles for a given parcel.
   #     
   # Notes:
   #    - we're reading the max block size if there are any nodata cells in block, which will be inefficient near edges
   #      where smaller blocks have enough data but larger ones don't, but I'm opting for simplicity and clarity over speed
   # 
   # B. Compton, 12 Sep 2024 (from ecoConnect.big.quantiles)
   
   
 #  n <<- n;acres<<-acres;best.pct <<- best.pct; layers <<- layers;server.names <<- server.names; sourcepath <<- sourcepath; threshold <<- threshold
 #  return()
   
   
   library(terra)
   library(lubridate)
   
   
   ts <- Sys.time()
   
   'unpack' <- function(x)                                                                # unpack state and HUC ids
      c(floor(x / 1000), x - floor(x / 1000) * 1000)
   
   'read.layers' <- function(x)                                                           # read raster layer x
      matrix(unlist(x[s[1] + block.idx, s[2] + block.idx], use.names = FALSE), max.block, max.block, byrow = TRUE)
   
   
   # come up with indices for each specified acerage 
   cells.per.acre <- 4.496507136                                                          # 1 acre = 4.5 cells
   w <- sqrt(acres * cells.per.acre)                                                      # convert acres to width in cells
   w <- ifelse((floor(w) %% 2) != 0, floor(w), ceiling(w))                                # pick nearest odd width in cells
   realized.acres <- w^2 / cells.per.acre                                                 # realized acres - use for interpolation
   cat('realized.acres <- c(', paste0(round(realized.acres, 4), collapse = ', '),
       ') # Realized acres for interpolation\n', sep = '')    
   rel.indices <- lapply(w, function(x) -floor(x / 2):floor(x / 2))                       # indices for each block size, relative to center
   block.idx <- rel.indices[[length(rel.indices)]]                                        # relative indices for full block (we'll use this inside loop)
   
   max.block <- max(w)                                                                    # maximum block size - this is what we'll always read
   block.indices <- lapply(rel.indices, function(x) x + ceiling(max.block / 2))           # indices for each block size, absolute for max block 
   
   thresholds <- w^2 * threshold                                                          # NA thresholds in cells for each block size 
   
   # read source data
   shindex <- rast(paste0(sourcepath, 'shindex.tif'))                                     # combined state/HUC8 index and mask
   lays <- lapply(layers, function(x) rast(paste0(sourcepath, 'ecoConnect_', x, '.tif')))
   sinfo <- read.table(paste0(sourcepath, 'stateinfo.txt'), sep = '\t', header = TRUE)    # we'll use these for sample size tables
   hinfo <- read.table(paste0(sourcepath, 'hucinfo.txt'), sep = '\t', header = TRUE)
   
   
   # create results
   statehuc <- data.frame(matrix(NA, n, 2))
   names(statehuc) <- c('state', 'huc')            # state and HUC8 for each sample
   z <- array(NA, dim = c(n, length(w), length(layers), 2))                               # row x acres x systems x all/best
   
   
   # gather samples
   for(i in 1:n) {                                                                        # For each sample,
      cat('Trying ', i, '...\n')
      success <- FALSE
      while(!success) {                                                                   #    until we find a live one,
         s <- round(runif(2) * dim(shindex)[1:2])                                         #    index of sample
         x <- unlist(shindex[s[1] + block.idx, s[2] + block.idx], use.names = FALSE)      #    read shindex for block
         cat(c('   no data', '   got data')[any(!is.na(x)) + 1], '\n')
         if(any(!is.na(x))) {                                                             #    If there are any data, continue
            sh <- matrix(x, length(block.idx), length(block.idx), byrow = TRUE)           #       make a proper matrix of it
            
            got.layers <- FALSE
            for(j in 1:length(acres)) {                                                   #       for each block size,
               cat('   ', acres[j], ' acres\n')
               if(sum(is.na(sh[block.indices[[j]], block.indices[[j]]])) > thresholds[j]) #       bail if too many missing cells   
               {
                  cat('      Too many missing   ********************\n')
                  next
               }
               cat('      Is okay...\n')
               if(!got.layers) {                                                          #             if we don't have data yet,
                  cat('      Reading layers...\n')
                  lay.vals <- lapply(lays, read.layers)                                   #                read current block of all 4 ecoConnect layers as matrices
                  got.layers <- TRUE
                  success <- TRUE
               }
               
               for(k in 1:length(layers)) {                                               #          for each layer,
                  y <- lay.vals[[k]][block.indices[[j]], block.indices[[j]]]              #             pull out subblock
                  y[is.na(sh[block.indices[[j]], block.indices[[j]]])] <- NA              #             mask from shindex
                  z[i, j, k, 1] <- mean(y, na.rm = TRUE)                                  #             sample all values
                  z[i, j, k, 2] <- mean(y[y >= quantile(y, best.pct, na.rm = TRUE)], 
                                        na.rm = TRUE)                                     #             sample top best.pct
               }
            }
            statehuc[i, ] <- unpack(sh[floor(max.block / 2), floor(max.block / 2)])       #    get state and HUC ids                ********* use majority, not centroid **********
         }
      }
   }
   
   
   # Intermediate result z is 4d array of row x acres x systems x all/best
   # Result quantiles.* are 5d arrays of region x acres x systems x all/best x 100 with percentiles
   # Result samples.* are 2d arrays of region x acres with sample sizes
   
   
   rc <- c(1, max(sinfo$class), max(hinfo$class))                                         # number of classes in each region (1 for full, 14 states, 245 HUCs)
   
   
   # Now take percentiles and sample sizes
   for(h in 1:length(rc)) {                                                               # For each set of regions,
      qu <- array(NA, dim = c(rc[h], length(acres), length(layers), 2, 100))              #    quantiles for region set
      ss <- array(NA, dim = c(rc[h], length(acres)))                                      #    sample sizes for region set
      for(i in 1:rc[h]) {                                                                 #    For each region,
         if(h == 1)                                                                       #       Select samples that fall in region
            y <- z
         else {
            if(!i %in% statehuc[, h - 1])                                                 #       just to be safe, though all states and HUCs should be represented
               next
            y <- z[statehuc[, h - 1] == i, , , , drop = FALSE]
         }
         for(j in 1:length(acres)) {                                                      #       For each block size,
            ss[i, j] <- sum(!is.na(y[ , j, 1, 1]))                                        #          collect sample sizes (identical across systems and all/best)
            for(k in 1:length(layers)) {                                                  #          For each layer,
               for(l in 1:2) {                                                            #             For all/best,   
                  qu[i, j, k, l, ] <- quantile(y[, j, k, l], 
                                               prob = seq(0.01, 1, by = 0.01),  
                                               na.rm = TRUE, names = FALSE)               #                take percentiles
               } 
            }  
         }
      }
      
      ss[is.na(ss)] <- 0
      switch(h, {                                                                         # save results to appropriate region variable
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
      
      cat('Finished calculating quantiles for ', c('full region', 'states', 'HUC8s'), '.\n', sep = '')
   }
   
 
   cat('Writing results...\n')
   x <- list(quantiles.full = quantiles.full, quantiles.state = quantiles.state, quantiles.huc = quantiles.huc)
   saveRDS(x, f <- paste0(sourcepath, 'ecoConnect_quantiles.RDS'))                        # write quantiles to RDS
   
   write.table(samples.full, paste0(sourcepath, 'sample_sizes_full.txt'), sep = '\t', row.names = FALSE, quote = FALSE)          # write sample size text files
   write.table(samples.state, paste0(sourcepath, 'sample_sizes_state.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   write.table(samples.huc, paste0(sourcepath, 'sample_sizes_huc.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   
   cat('Results written to ', f, '\n', sep = '')
   cat('Total time taken: ', format(seconds_to_period(round(as.duration(interval(ts, Sys.time()))))), '\n', sep = '')
}
