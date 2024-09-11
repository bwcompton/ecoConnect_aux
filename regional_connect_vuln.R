'regional_connect_vuln' <- function(result = 'vuln.tif', 
                                    path = 'x:/LCC/GIS/Final/ecoRefugia/vulnerability/',
                                    clip = FALSE, clipto = c(1753992, 1897109, 2346734, 2479302),
                                    devprob = 'devprob_250m.tif',
                                    connect = 'conduct_forest_250m.tif') {
    
    # Create vulnerability for regional connectivity (Objective 3 of 2022 NE CASC project)
    # Parameters:
    #   result      path and name of result TIFF
    #   clip        if TRUE, clip to box specified by clipto, for speedy testing (skips stats)
    #   clipto      box for clipping: xmin, xmax, ymin, ymax
    #   devprob     path to devprob, probably already kerneled
    #   connect     path to regional connectivity, probably already kerneled
    #               Use KERNEL metric in APL CAPS metric with bandwidth = 250 to kernel connectivity grids
    # Sample call:
    #   regional_connect_vuln('vuln_wetlands.tif', connect = 'conduct_wetlands_250m.tif')
    #   
    # B. Compton, 7-11 Apr 2023
    # 18 Sep 2023: oops--need temporary file
    
    
    
    library(terra)
    library(rasterPrep)
    
    result <- paste0(path, result)
    
    devp <- rast(paste0(path, devprob))
    conn <- rast(paste0(path, connect))
    
    if(clip) {                                  # clip to test area
        devp <- crop(devp, ext(clipto))
        conn <- crop(conn, ext(clipto))
    }
    
    
    # do the calculations
#    z <- (exp(conn) - 1) * devp                # I did kernels in raw scale, so no need to do it here
    z <- conn * devp                            # connect in original scale x devprob
    z <- st_logistic(z, 200, 25)               
    z[z < 0.05 ] <- NA
    
    
    if(clip)
        writeRaster(z, result, overwrite = TRUE)
    else {
        writeRaster(z, r1 <- paste0(path, 'zztemp', round(runif(1) * 1e6), '.tif'), overwrite = TRUE)
        makeNiceTif(r1, result, overwrite = TRUE, type = 'Float32', stats = TRUE, 
                    buildOverviews = TRUE, overviewResample = 'average')
        if(file.exists(r1))
            file.remove(r1)
    }
    cat('Results written to', result, '\n')
    suppressWarnings(tmpFiles(current = TRUE, old = FALSE, remove = TRUE))         # remove temporary files and STFU
}



'st_logistic' <- function(x, location, scale) {

    # do a logistic transformation of a spatRaster object
    
    return(1 / (1 + exp(-(x - location) / scale)))
}
