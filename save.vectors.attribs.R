'save.vectors.attribs' <- function(v, attrib, shapefile, crsfile)
   
   # save.vectors.attribs
   # Convert vector data (list of matrices of coordinates) to SpatialLinesDataFrame and write shapefile
   # Arguments:
   #   v           list of matrices of vector coordinates
   #   attrib      data frame of attributes
   #   shapefile   path and name of result shapefile
   #   crsfile     shapefile with CRS
   # Global:
   #   shapes      set by read.vectors, to get projection
   # B. Compton, 3-4 May 2021 (from save.vectors)
   
   

{

   stop('Deprecated')

   a <- lapply(v, FUN = Line)
   b <- as.list(rep(0, length(a)))
   for(i in 1:length(a))
      b[[i]] <- Lines(a[i], ID = as.character(i))
   c <- SpatialLines(b, proj4string = CRS(proj4string(crsfile)))
   z <- SpatialLinesDataFrame(c, data = attrib)
   writeOGR(z, shapefile, driver = 'ESRI Shapefile', layer = 'points')
}