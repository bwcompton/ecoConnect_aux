'ecoConnect.quantiles' <- function(acres, n = 10000, layers = c('forests', 'ridgetops', 'wetlands', 'floodplains' ), 
  server.names = c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest'),
  sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ecoConnect_') {
  
  
  # Calculate percentiles of big simulated parcels of ecoConnect layers and save file for ecoConnect.tool
  # I'm sampling 100 million cells in each layer. It's not perfectly stable, but close.
  # Arguments:
  #   acres               target parcel size in acres
  #   n                   number of samples
  #   layers              source system names
  #   server.names        names used on server, to be written to result data frame
  #   sourcepath          path for source TIFFs
  # Result:
  #   ecoConnect_quantiles<acres>.RDS, data frame of percentiles, written to sourcepath
  # B. Compton, 2 Jul 2024 (from ecoConnect.big.quantiles)
  

   
*** rewrite to sample nested pseudo-parcels by region, state, and HUC8 watershed ...  xxx yyy
   
   
  
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
