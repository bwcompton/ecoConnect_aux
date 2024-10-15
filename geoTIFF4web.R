'geoTIFF4web' <- function(source, result, resultpath = 'x:/LCC/GIS/Final/GeoServer/',
                          reference = 'x:/LCC/GIS/Final/GeoServer/ref_webmercator.tif',
                          auto = TRUE, rescale = NULL, round = NULL, type = 'FLT4S', buildOverviews = TRUE, overviewResample = 'average',
                          vat = FALSE, cleanup = TRUE) {


    # Prepare rasters for posting on GeoServer
    # Optionally rescales, rounds, and changes type (in auto mode, rescales 0-100 and saves as 1 byte integer)
    # Reprojects to web Mercator (EPSG:3857) based on reference grid
    # Builds overviews and stats
    # Arguments:
    #   source              path and name of source grid
    #   result              base name of result TIFF (omit .TIF extension)
    #   resultpath          path for final result (and intermediate files)
    #   reference           path to reference TIFF. Create it once per landscape with makeRefGrid.R
    #   auto                if TRUE, produce integers from 0 to 100 in an unsigned byte. This is the most
    #                          compact way to present quatitative data, and is the preferred option (supercedes
    #                          rescale, round, and type options and round options and sets type to INT1U)
    # The following 3 options are only applied if auto = FALSE
    #   rescale             max value to rescale to; e.g., rescale = 100 rescales 0-100. Use NULL to skip rescaling
    #   round               round to a specified number of digits after the decimal point. Use round = NULL to skip
    #                          rounding
    #   type                data type of result using terra codes; default is FLT4S (32-bit floating point);
    #                          can be any of INT1U, INT2U, INT2S, INT4U, INT4S, FLT4S, or FLT8S. NoData value will be
    #                          set accordingly.
    #   buildOverviews      build overviews if TRUE
    #   overviewResample    how to resample overviews? default is 'average'; use 'nearest' for
    #                          classified grids. See help(makeNiceTif) for more options
    #   vat                 build a VAT?
    #   cleanup             if TRUE, delete temporary files
    # Example call:
    #   geoTIFF4web('x:/LCC/GIS/Final/ecoRefugia/forest/results/conduct_s.tif', result = 'connect/forest_connect')
    # B. Compton, 10 and 14-17 Mar 2023
    # 11 Sep 2023: clear terra temporary files



    library(terra)
    library(rasterPrep)

    resultpath <- paste0(resultpath, ifelse(substr(resultpath, nchar(resultpath), nchar(resultpath)) == '/', '', '/'))    # make sure there's a trailing slash
    r <- paste0(resultpath, result, c(1, 2, ''), '.tif')    # results. r[1] = optional rescaled result, r[2] = reprojected, r[3] = final result
    dir.create(dirname(r[1]), showWarnings = FALSE, recursive = TRUE)

    if(auto) {
        rescale <- 100
        round <- 0
        type <- 'INT1U'
    }

    typeinfo <- assessType(type)

    if(!is.null(rescale) | !is.null(round)) {       # if rescaling or rounding,
        cleanup.r1 <- TRUE
        x <- rast(source)
        if(!is.null(rescale)) {
            cat('Rescaling...\n')
            x <- x / minmax(x)[2] * rescale
        }
        if(!is.null(round)) {
            cat('Rounding...\n')
            x <- round(x, round)
        }
        writeRaster(x, r[1], overwrite = TRUE, datatype = type, NAflag = typeinfo$noDataValue)
    }
    else {
        r[1] <- source
        cleanup.r1 <- FALSE
    }


    cat('Reprojecting...\n')
    warpToReference(r[1], r[2], reference, overwrite = TRUE, type = typeinfo$type, compression = 'LZW')
    cat('Building overviews and stats...\n')
    makeNiceTif(r[2], r[3], overwrite = TRUE, type = typeinfo$type,  noDataValue = typeinfo$noDataValue,
                overviewResample = overviewResample, vat = vat, stats = TRUE, buildOverviews)

    if(cleanup) {
        cat('Cleaning up...\n')
        tmpFiles(remove = TRUE)                  # clear the junk terra has filled the disk with
        if (file.exists(r[1]) & cleanup.r1)
            file.remove(r[1])
        if(file.exists(r[2]))
            file.remove(r[2])
        file.remove(sub('.tif', '.tfw', r[2]))
        file.remove(sub('.tif', '.tif.aux.xml', r[2]))
    }
    cat('Results are in', r[3], '\n')
}
