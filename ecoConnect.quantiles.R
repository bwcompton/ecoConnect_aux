'ecoConnect.quantiles' <- function(n = 10000, acres  = c(1, 10, 100, 1000, 1e4, 1e5), best.pct = c(50, 25), 
                                   layers = c('forests', 'ridgetops', 'wetlands', 'floodplains' ), 
                                   server.names = c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest'),
                                   sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ecoConnect_', 
                                   threshold = 0.75) {
   
   
   # Calculate percentiles of simulated parcels of ecoConnect layers and save files for ecoConnect.tool
   # In the previous version, I wassampling 100 million cells in each layer. It's not perfectly stable, but close.
   # 
   # Arguments:
   #   n                   number of samples
   #   acres               target parcel sizes in acres
   #   best.pct            top percents of pseudoparcels for "best." A separate result file will be written for each provided
   #                       value. We'll only use one of them in the end, either top 50% or top 25%.
   #   layers              source system names
   #   server.names        names used on server, to be written to result data frame
   #   sourcepath          path for source TIFFs
   #   threshold           proportion of cells that must be non-missing to be counted as a good sample
   #   
   # Source data (in sourcepath):
   #   shindex.tif         index grid for states and HUC8s, with nodata for all cells that should be masked out (marine, estaurine, freshwater tidal)
   # 
   # Result (written to sourcepath):
   #   ecoConnect_quantiles<best.pct>.RDS, data frame of percentiles
   #     RDS with 4 x 260 x 6 x 2 x 100 array of system x region (full = 1, state = 14, huc = 245) x size x mean vs best x percentile (100)
   #     
   #   sample_sizes_full.txt
   #   sample_sizes_state.txt
   #   sample_sizes_huc.txt
   #     tables of region/state name/huc ID by acres with sample sizes
   #     
   # B. Compton, 12 Sep 2024 (from ecoConnect.big.quantiles)
   
   
   
   # come up with list of indices for each size. Need square root of acres in cells, pick closest odd number of cells
   # read shindex, stateinfo and hucinfo
   # create results:
   #     statehuc - state, huc x rows
   #     samples - system x region/state/huc x size x best x n
   # for(i in 1:n)
   #     pick a random cell in landscape
   #     read largest block from shindex
   #     if all NA, pick another random cell
   #     for(j in 1:acres)
   #        if enough non-missing at size,
   #           for each ecoConnect,
   #              if haven't read data yet,
   #                 read block of  ecoConnect TIFF (largest acerage)
   #              index subblock
   #              set to missing where nodata in shindex
   #              take mean
   #              for each best.pct,
   #                 take mean of top %
   #     if no success, pick another random cell
   #     
   # Now loop for each best %
   #     take percentiles
   #     get sample size
   # write result RDS
   # write sample size tables
   
   
   
   
   
   
   
   
   
   library(terra)
   
   cat('Running for ', acres, ' acres...\n', sep = '')
   mask <- rast('x:/LCC/GIS/Work/Ancillary/Mask/phase5/mask.tif')
   
   cells <- acres * 4.496507136                                  # convert target to cells
   w <- floor(c(cells, cells + 1))                               # width of square, rounded down and up
   w <- w[w %% 2 == 1] - 1                                       # we want the odd width
   r <- w / 2                                                    # radius of target square
   k <- -r:r                                                     # add these to indices
   l <- round(matrix(dim(mask)[1:2] - r * 2, n, 2, byrow = TRUE) * runif(n * 2) + r, 0)           # indices into n squares
   
   z <- data.frame(matrix(NA, 100, length(layers)))
   names(z) <- server.names
   
   for(i in 1:length(layers)) {                                  # for each layer,
      cat('Layer ', layers[i], '...', sep = '')
      v <- rep(NA, n)
      x <- rast(paste0(sourcepath, layers[i], '.tif'))            #    read raster
      
      for(j in 1:n) {                                             #    for each iteration,
         y <- as.vector(x[l[j, 1] + k, l[j, 2] + k])[[1]]          #       sample
         m <- as.vector(mask[l[j, 1] + k, l[j, 2] + k])[[1]]       #       and corresponding mask
         y[is.na(y)] <- 0                                          #       nodata within mask should be zero for our purposes here
         y[is.na(m) | (m != 1)] <- NA                                #       outside of mask is nodata
         v[j] <- ifelse(sum(is.na(y)) > w ^ 2 / 2, NA, mean(y, na.rm = TRUE))    #       mean if half or less of area is NA  
      }
      
      v <- v[!is.na(v)]                                                         #    drop NAs
      cat('n = ', format(length(v), big.mark = ','), '\n', sep = '')
      z[server.names[i]] <- quantile(v,  probs =  seq(0.01, 1, by = 0.01))      #    get percentiles
   }
   
   saveRDS(z, f <- paste0(sourcepath, 'quantiles_', acres, '.RDS'))
   cat('Results written to ', f, '\n', sep = '')
}
