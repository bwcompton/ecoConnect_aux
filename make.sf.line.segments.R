'make.sf.line.segments' <- function(x, coords = c('x1', 'y1', 'x2', 'y2'), crs) {
   
   # make.sf.line.segments
   # Make sf lines object from line segments in data frame
   # Arguments:
   #  x        data frame with attributes and coordinates
   #  coords   vector of column names with coordinates
   #  crs      coordinate referenence system# 
   # B. Compton, 14 Dec 2023
   
   
   
   library(sf)
   
   
   geometry <- vector(mode = 'list', length = nrow(x))
   
   for(i in 1:dim(x)[1])
      geometry[i] <- st_sfc(st_linestring(st_multipoint(matrix(as.numeric(x[i, coords]), ncol = 2, byrow = TRUE), dim = "XY")))
   
   x$geometry <- geometry
   x <- x[!(names(x) %in% coords)]   # drop coordinate columns
   
   st_sf(x, crs = crs)
}