'makeRefGrid' <- function(source = 'x:/LCC/GIS/Final/NER/caps_phase5/post_2020/scaled/full/iei-r.tif',
                          result = 'x:/LCC/GIS/Final/GeoServer/ref_webmercator.tif', crs = 'EPSG:3857') {
    
    
    # Prepare a reference grid for geoTIFF4web, which preps grids for posting on GeoServer
    # Arguments:
    #	source		path and name of source grid
    #	result		path and name of result
    #	crs			coordinate reference system. Default is EPSG:3857, web Mercator
    # This takes bloody forever, but only needs to be done once for a particular
    # extent, grain, and CRS
    # For DSL, you can use the defaults
    # B. Compton, 10 Mar 2023
    
    
    
    library(gdalUtilities)
    cat('Building a reference grid. This will take bloody forever...\n')
    gdalwarp(source, result, t_srs = crs, co = 'COMPRESS=DEFLATE')
}