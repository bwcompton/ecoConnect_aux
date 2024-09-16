'rescale.ecoConnect' <- function(source, result, 
                                 sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/%%/results/conduct_s.tif',
                                 maskpath = 'x:/LCC/GIS/Work/Ancillary/Mask/phase5/mask.tif',
                                 resultpath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ecoConnect_',
                                 cleanup = TRUE) {
    
    
    # Rescale regional connectivity to 0-100, round, and convert to integer for posting. Nodata cells where mask isn't nodata are set to zero.
    # Builds overviews and stats
    # Arguments:
    #   source              source system name
    #   maskpath            mask grid
    #   result              result system name
    #   sourcepath          path for source grid, with %% for system
    #   resultpath          path for final result (and intermediate files) with leading part of filename
    #   cleanup             if TRUE, delete temporary files
    # Example calls:
    #   rescale.ecoConnect('fo_fowet', 'forests')
    #   rescale.ecoConnect('ridgetop', 'ridgetops')
    #   rescale.ecoConnect('openwet', 'wetlands')
    #   rescale.ecoConnect('floodplain-fo-lr', 'floodplains')
    # B. Compton, 20 Sep 2023 (from x:\LCC\Code\Web\geoTIFF4web.R)
    
    
    
    library(terra)
    library(rasterPrep)
    
    r <- paste0(resultpath, result, c(1, ''), '.tif')    # results. r[1] = optional rescaled result, r[2] = final result
    dir.create(dirname(r[1]), showWarnings = FALSE, recursive = TRUE)
    
    rescale <- 100
    round <- 0
    type <- 'INT1U'
    
    typeinfo <- assessType(type)
    
    x <- rast(paste0(sub('%%', source, sourcepath)))
    mask <- rast(maskpath)
    cat('Rescaling...\n')
    x <- x / minmax(x)[2] * rescale
    cat('Rounding...\n')
    x <- round(x, round)
    x[is.na(x) & !is.na(mask)] <- 0                      # set nodata cells within mask to 0
    writeRaster(x, r[1], overwrite = TRUE, datatype = type, NAflag = typeinfo$noDataValue)
    
    cat('Building overviews and stats...\n')
    makeNiceTif(r[1], r[2], overwrite = TRUE, type = typeinfo$type, buildOverviews = TRUE,
                overviewResample = 'average', stats = TRUE)
    
    if(cleanup) {
        cat('Cleaning up...\n')
        tmpFiles(remove = TRUE)                          # clear the junk terra has filled the disk with
        file.remove(r[1])
        if (file.exists(r[1]))
            file.remove(r[1])
    }
    
    cat('Results are in ', r[2], '\n')
}
