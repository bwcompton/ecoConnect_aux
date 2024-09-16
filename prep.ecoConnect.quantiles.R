'prep.ecoConnect.quantiles' <- function(
      states = 'x:/LCC/GIS/Work/Ancillary/RegionMaps/Phase5/states.tif',
   huc8 = 'x:/LCC/GIS/Work/Ancillary/RegionMaps/Phase5/huc8.tif',
   landcover = 'x:/LCC/GIS/Final/NER/caps_phase5/grids/dslland.tif',
   resultpath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/',
   states.attributes = 'x:/LCC/GIS/Work/Ancillary/Boundaries/states/states_ner.dbf',
   huc8.attributes = 'x:/LCC/GIS/Work/Ancillary/Boundaries/watersheds/wbdhu8_neregion_130930.dbf',
   exclude = c(300, 301, 400, 402, 404, 405, 407, 408, 409, 410, 411, 500, 502, 504, 506, 507),
   cleanup = TRUE) {
   
   
   # prep data for ecoConnect.quantiles: make index/mask for estimating quantiles of ecoConnect
   # and looking up HUC8 watersheds and states in ecoConnect.tool.app
   # Arguments:
   #     states      geoTIFF of states
   #     huc8        geoTIFF of HUC8 watersheds
   #     landcover   DSLland geoTIFF
   #     result      name of 
   #     exclude     values of DSLland to exclude when calculating percentiles (marine, estaurine, and Freshwater Tidal Riverine)
   # Results:
   #     shindex     integer geoTIFF of states (11000) and HUC8 watersheds (00111)
   #     stateinfo   table of state classes and state names
   #     hucinfo     table of HUC8 classes and 8 digit HUC8 code
   # B. Compton, 6 Sep 2024
   
   
   
   library(terra)
   library(rasterPrep)
   library(foreign)
   
   type <- 'INT2U'                                                                              # 32 bit integer for 5 digits
   typeinfo <- assessType(type)
   
   
   cat('Reading states, HUCs, and landcover...\n')
   s <- rast(states)                                                                            # combine states and hucs into shindex
   h <- rast(huc8)
   land <- rast(landcover)
   cat('Building shindex...\n')
   sh <- s * 1e3   + h
   cat('Setting excluded cells to missing...\n')
   sh[land %in% exclude] <- NA                  # set all excluded cells to nodata (even though some may have values for ecoConnect--we exclude these from percentiles)
   cat('Saving shindex...\n')
   writeRaster(sh, paste0(resultpath, 'shindex.tif'), overwrite = TRUE, datatype = type, NAflag = typeinfo$noDataValue)
   
   
   cat('Building tables...\n')
   x <- read.dbf(states.attributes)                                                             # build lookup table for states
   st <- x[, c('gridcode', 'STATE', 'POSTAL', 'STATE_FIPS')]
   names(st) <- c('class', 'state', 'postal', 'state_FIPS')
   st <- st[order(st$class),]
   write.table(st, paste0(resultpath, 'stateinfo.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   
   
   x <- read.dbf(huc8.attributes)                                                               # build lookup table for HUC8s
   ha <- cbind(1:dim(x)[1], x[, c('HUC_8', 'REGION', 'SUBREGION', 'BASIN', 'SUBBASIN')])
   names(ha) <- c('class', 'HUC8_code', 'region', 'subregion', 'basin', 'subbasin')
   write.table(ha, paste0(resultpath, 'hucinfo.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   
   
   cat('Cleaning up...\n')
   if(cleanup) {
      cat('Cleaning up...\n')
      tmpFiles(remove = TRUE)                                                                   # clear the junk terra has filled the disk with
   }   
   
   cat('Results are in ', resultpath, '\n')
}