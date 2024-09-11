'make.shapefile' <- function(file, x = 'x_coord', y = 'y_coord', ref = 'MA', CRSfile = '', reproj = NULL)
  
  # Read tab-delimited text file and create a shapefile with the same path and base name
  # Arguments:
  #   file      path and name of text file (.txt optional)
  #   x         name of column with x coordinates 
  #   y         name of column with y coordinates  
  #   ref       reference landscape to use: 'MA' for Mass State Plane, 'DSL' for Albers, or 'NAD83' for lat-long
  #   CRSfile   when ref = '', path and name of existing shapefile with the CRS you want to use
  #   reproj    optionally pass a function to reproject data; reproj is blindly run before writing the shapefile
  # B. Compton, 26 Jan 2021 (the pandemic rages, but Trump is gone)
  # 25-26 Mar 2021: add ref = 'NAD83' and reproj
  # 13 Dec 2023: change over from rgdal to sf, with 2 weeks to spare!



{
library(sf)
  
  file <- gsub('.txt', '', file)
  cat('Reading data...\n')
  q <- read.table(paste(file, '.txt', sep = ''), sep = '\t', header = TRUE)
  if(any((l <- lapply(list(names(q)), FUN = 'nchar')[[1]]) > 10)) {
    cat('The following fields have length > 10 characters. RGDAL creates horrible short names, so DIY:\n')
    n <<- paste(names(q)[l > 10], ' (',l[l > 10], ')', sep = '')
    cat('', n, '\n', sep = '   ')
    return()
  }
  end
  cat('Reading CRS...\n')
  if(nchar(ref) != 0) {
    t <- c('x:/CAPS/source/depwet.shp', 'x:/LCC/GIS/Work/Ancillary/Boundaries/states/states_ner.shp', 'x:/LCC/GIS/Work/Ancillary/Boundaries/ecoregions/Bailey/ecoregp075.shp')
    CRSfile <- t[match(ref, c('MA', 'DSL', 'NAD83'))]
  }
  shapes <- suppressWarnings(st_read(dsn = CRSfile, quiet = TRUE))
  cat('Creating shapefile...\n')
  z <- st_as_sf(data.frame(q), coords = c(x, y), crs = st_crs(shapes))
  
  if(!is.null(reproj)) {
    cat('Reprojecting...\n')
    do.call(reproj, list(1))
  }
  
  cat('Writing shapefile...\n')
  st_write(z, f <- paste(file, '.shp', sep = ''), driver = 'ESRI Shapefile', layer = 'points')
  cat(f, ' written.\n', sep = '')
}