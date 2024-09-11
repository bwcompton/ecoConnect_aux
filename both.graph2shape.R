'both.graph2shape' <- function(path = '', nodes = 'nodes', edges = 'edges', edgeweights = 'edgeweights', 
                               result = 'edges.shp',
                               projfile = 'X:/LCC/GIS/Work/Ancillary/Boundaries/states/states_ner.shp') {
    
    # both.graph2shape
    # Read a graph and write edges as a shapefile. This version combines both 
    # edges.txt and edgeweights.txt to include both costs and weights.
    # Finishes up ECOCONNECT runs
    # B. Compton, 2 May 2022 (from temp.graph2shape)
    # 6 May 2022: fix horrible row.names bug
    # 14 Dec 2023: change over from retiring rgdal/sp to sf; substantial rewrite

    
    
    source('x:/LCC/Code/ecoConnect/add.path.R')
    source('x:/LCC/Code/ecoConnect/make.sf.line.segments.R')
    
    
    cat('Reading graph ',paste0(path, nodes, '.txt'), ', ', paste0(path, edges, '.txt'), ', and ', paste0(path, edgeweights, '.txt'), '\n', sep = '')
    
    n0 <- read.table(paste0(path, nodes, '.txt'), sep = '\t', header = TRUE)
    e0 <- read.table(paste0(path, edges, '.txt'), sep = '\t', header = TRUE)
    ew0 <- read.table(paste0(path, edgeweights, '.txt'), sep = '\t', header = TRUE)
    crs <- st_crs(st_read(add.path(path, projfile)))  	# just to get projection
    
    e0[b, c('from', 'to')] <- e0[b <- e0$from > e0$to, c('to', 'from')]         #    convert to lower triangle
    e0 <- aggregate(e0$cost, by = list(e0$from, e0$to), FUN = mean)
    names(e0) <- c('from', 'to', 'cost')
    e0 <- e0[order(e0$from, e0$to),]                # sort both tables to agree
    ew0 <- ew0[order(ew0$from, ew0$to),]
    
    row.names(e0) <- NULL
    row.names(ew0) <- NULL
    
    if(!(all.equal(e0$from, ew0$from) & all.equal(e0$to, ew0$to)))
        stop("Files don''t match!")
    
    e0$edgewgt <- ew0$edgeweight                    # short name so it doesn't get trashed
    e0$ew_sqrt <- sqrt(e0$edgewgt)                  # take the square root here!
    
    e <- cbind(n0[match(e0$from, n0$nodeid), c('x', 'y')], n0[match(e0$to, n0$nodeid), c('x', 'y')])
    names(e) <- c('x1', 'y1', 'x2', 'y2')
    e <- cbind(e0, e)

    z <- make.sf.line.segments(e, crs = crs)
    st_write(z, f <- add.path(path, result), delete_dsn = TRUE)
    
    cat('Edges written to ', f, '\n', sep = '')
}
