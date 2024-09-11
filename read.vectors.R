'read.vectors' <- function(shapefile, global = TRUE)

# read.vectors
# Read line shapefile, and set global shapes to the whole dang thing
# Arguments:
#   shapefile   path and name of shapefile to read
#   global      if TRUE, sets global shapes and vectors; if FALSE, returns vectors
# Global results (if global = TRUE):
#   shapes      SpatialLinesDataFrame object
#   vectors     List of matrices of coordinates
# Result (if global = FALSE)
#   vectors     List of matrices of coordinates
# B. Compton, 3-4 Jan 2019 (from find.termini)
# 15 Jan 2019: don't let floating point burn us!
# 28 Jan 2019: add global option
# 15 Dec 2021: aargh: can't set 'shapes' when igraph is loaded...will break old code this relies on
# 13 Dec 2023: change over from retiring rgdal/sp to sf



{
    shapes <- suppressWarnings(st_read(dsn = shapefile, quiet = TRUE))
    vectors <- unlist(st_coordinates(shapes), recursive = FALSE)
    vectors <- lapply(vectors, FUN = round, 3)
    if(global) {
        shapesX <<- shapes
        vectors <<- vectors
    }
    else
        vectors
}
