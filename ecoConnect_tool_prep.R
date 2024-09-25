'ecoConnect_tool_prep' <- function(iei = TRUE, ecoConnect = TRUE, shindex = TRUE) {
   
   # Prep ecoConnect and IEI for ecoConnect_tool web app
   # Before running, 
   #  - run and post-process IEI 
   #  - run ECOCONNECT and rescale.ecoConnect.R
   #  - run ecoConnect.quantiles to create shindex.TIF, stateinfo.txt, and hucinfo.txt
   # Arguments:
   #	iei			process IEI if TRUE
   #	ecoConnect	process ecoConnect if TRUE
   # 	shindex		process shindex if TRUE
   # Produces final integerized TIFFs in Web Mercator, with overviews, ready to post on GeoServer
   # B. Compton, 30 May 2024
   
   
   
   source('x:/LCC/Code/Web/geoTIFF4web.R')
   
   iei.source.path <- 'x:/LCC/GIS/Final/NER/caps_phase5/post_2020/scaled/'
   iei.result.path <- 'x:/LCC/GIS/Final/GeoServer/IEI/'
   
   connect.source.path <- 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ecoConnect_'
   connect.result.path <- 'x:/LCC/GIS/Final/GeoServer/ecoConnect/'
   
   shindex.source.path <- 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/'
   shindex.result.path <- 'x:/LCC/GIS/Final/GeoServer/ecoConnect/'
   
   
   iei.source <- c('full/iei-r', 'states/iei-s', 'ecoregions/iei-e', 'huc6/iei-h6')
   iei.result <- c('iei_regional', 'iei_state', 'iei_ecoregion', 'iei_huc6')
   
   connect.source <- c('forests', 'ridgetops', 'wetlands', 'floodplains')
   connect.result <- c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest')
   
   
   
   if(iei)   
      for(i in 1:length(iei.source)) {
         cat('\nProcessing ', iei.source[i], '...\n', sep = '')
         geoTIFF4web(paste0(iei.source.path, iei.source[i], '.tif'), iei.result[i],
                     resultpath = iei.result.path, auto = TRUE)
      }
   
   if(ecoConnect)
      for(i in 1:length(connect.source)) {
         cat('\nProcessing ', connect.source[i], '...\n', sep = '')
         geoTIFF4web(paste0(connect.source.path, connect.source[i], '.tif'), connect.result[i],
                     resultpath = connect.result.path, auto = FALSE, type = 'INT1U')
      }
   
   if(shindex) {
      cat('\nProcessing shindex...\n', sep = '')
      geoTIFF4web(paste0(shindex.source.path, 'shindex.tif'), 'shindex',
                  resultpath = shindex.result.path, auto = FALSE, rescale = FALSE, round = FALSE,
                  type = 'INT2U', overviewResample = 'nearest')
      
      file.copy(paste0(shindex.source.path, 'hucinfo.txt'), shindex.result.path, overwrite = TRUE)
      file.copy(paste0(shindex.source.path, 'stateinfo.txt'), shindex.result.path, overwrite = TRUE)
   }
   
   cat('\nAll done.\n')
}