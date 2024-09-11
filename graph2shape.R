'graph2shape' <- function(cores = 'working/coresall.txt', edges = 'results_20km/internode.txt',
                          result = 'edges.shp', path = 'X:/LCC/GIS/Work/Biotic/species/refugia/bith/',
                          projfile = 'X:/LCC/GIS/Work/Ancillary/Boundaries/states/states_ner.shp') {

   # Make a shapefile for edges from Species Refugia tables
   # Arguments:
   #   nodes      cores table
   #   edges      edges table
   #   result     name of shapefile to create
   #   path       shared path
   #   projfile
   # B. Compton, 4 May 2021



   library(rgdal)

   source('g:/r/read.vectors.R')
   source('g:/r/save.vectors.attribs.R')
   source('g:/r/eco.buffer/R/add.path.R')

   x <- read.vectors(add.path(path, projfile))   # just to get projection

   nodes <- read.table(add.path(path, cores), sep = '\t', header = TRUE)
   edges <- read.table(add.path(path, edges), sep = '\t', header = TRUE)

   e <- cbind(nodes[match(edges$from, nodes$coreid), c('x', 'y')], nodes[match(edges$to, nodes$coreid), c('x', 'y')])

   d <- split(e, 1:dim(e)[1])
   d <- lapply(d, matrix, 2, 2, byrow = TRUE)

   d <- lapply(d, as.numeric)       # why is this necessary?!?!?
   d <- lapply(d, matrix, 2, 2)
   names(d) <- rownames(edges)

   save.vectors.attribs(d, edges, add.path(path, result), shapes)
}
