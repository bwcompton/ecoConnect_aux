'ecoConnect_tool_prep' <- function() {
   
   # Prep ecoConnect and IEI for ecoConnect_tool web app
   # Before running, 
   #  - run and post-process IEI 
   #  - run ECOCONNECT and rescale.ecoConnect.R
   # Produces final integerized TIFFs in Web Mercator, with overviews, ready to post on GeoServer
   # B. Compton, 30 May 2024
   
   
   
   source('x:/LCC/Code/Web/geoTIFF4web.R')
   
   connect.source.path <- 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ecoConnect_'
   connect.result.path <- 'x:/LCC/GIS/Final/GeoServer/ecoConnect/'
   iei.source.path <- 'x:/LCC/GIS/Final/NER/caps_phase5/post_2020/scaled/'
   iei.result.path <- 'x:/LCC/GIS/Final/GeoServer/IEI/'
   
   connect.source <- c('forests', 'ridgetops', 'wetlands', 'floodplains')
   connect.result <- c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest')
   
   iei.source <- c('full/iei-r', 'states/iei-s', 'ecoregions/iei-e', 'huc6/iei-h6')
   iei.result <- c('iei_regional', 'iei_state', 'iei_ecoregion', 'iei_huc6')
   
   for(i in 1:length(connect.source)) {
      cat('\nProcessing ', connect.source[i], '...\n', sep = '')
      geoTIFF4web(paste0(connect.source.path, connect.source[i], '.tif'), connect.result[i],
                  resultpath = connect.result.path, auto = FALSE, type = 'INT1U')
   }
   
   for(i in 1:length(iei.source)) {
      cat('\nProcessing ', iei.source[i], '...\n', sep = '')
      geoTIFF4web(paste0(iei.source.path, iei.source[i], '.tif'), iei.result[i],
                  resultpath = iei.result.path, auto = TRUE)
   }
   cat('\nAll done.\n')
}