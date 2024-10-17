'looptest' <- function(n = 1e8, n.factor = c(1, 1, 1, 1, 1e2, 1e3, 1e4), acres  = c(1, 10, 100, 1000, 1e4, 1e5, 1e6), 
                                   best.pct = 0.5, layers = c('forests', 'ridgetops', 'wetlands', 'floodplains' ), 
                                   server.names = c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest'),
                                   sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/', postfix = '', 
                                   threshold = 0.25) {
   
   
   # massively slimmed-down version of ecoConnect.quantiles to try to figure out why run time is non-linear with n
   # 17 Oct 2024  
   
   

   library(lubridate)
   library(progressr)
   library(terra)
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
 #  lays <- lapply(layers, function(x) read.tiff(paste0(sourcepath, 'ecoConnect_', x, '.tif')))  # ecoConnect layers
   sinfo <- read.table(paste0(sourcepath, 'stateinfo.txt'), sep = '\t', header = TRUE)          # we'll use these for sample size tables
   hinfo <- read.table(paste0(sourcepath, 'hucinfo.txt'), sep = '\t', header = TRUE)
   

   ts <- Sys.time()
   z <- array(NA, dim = c(n, length(idx$w), length(layers), 2))                                 # row x acres x systems x all/best
   cat('Gathering ', format(n, scientific = FALSE, big.mark = ','), ' samples...\n', sep = '')
   
   
   cat('length(idx$w) = ', length(idx$w), '\n', sep = '')
   cat('dim(shindex) = ', dim(shindex[1:2]), '\n', sep = '')
   cat('length(idx$acres)', length(idx$acres), '\n', sep = '')
   cat('idx$block.indices = \n')
   print(idx$block.indices)
      
   
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
               if(i %% skip == 0)                                                               #       update progress bar every nth iteration
                  pb()
            }
         }
      }
   }
   
   
   elapsed <- format(seconds_to_period(round(as.duration(interval(ts, Sys.time())))))
   cat('Total time taken: ', elapsed, '\n', sep = '')
}
