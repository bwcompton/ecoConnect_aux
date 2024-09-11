'eco.graph' <- function(subdir, randomize = 0, randomdrop = 0, iteration = 0) {
    
    # eco.graph
    # Pass 2 graph betweenness for Ecosystem Connectivity project
    # Pass 0: ECONODES; Pass 1: ECOPATHS; Pass 2: ECOGRAPH/eco.graph; Pass 3: ECOPATHS
    # Call this function directly for a single iteration, or from ECOGRAPH via call.eco.graph
    # to do multiple random iterations
    # 
    # Arguments:
    #	subdir		path for source and results. <subdir>/tables/ will be used.
    #	randomize	s.d. for randomization.  Randomize edge cost, multiplying
    #				cost by random normal deviates with s.d. <randomize>.	Use 0 to 
    #				turn off randomization. Don't try using both randomize and randomdrop
    #				in the same run!
    #	randomdrop	proportion of edges to randomly drop.  Use 0 to turn off randomdrop.
    #				Don't try using both randomize and randomdrop in the same run!
    #	iteration	iteration number, if called in parallel by ECOGRAPH. If nonzero, 
    #    			results are written to ew<iteration>.txt, and ECOGRAPH will compile
    #				temporary files into a single result, edgeweights.txt.
    #
    # Source
    #	<subdir>/tables/nodes.txt, with columns nodeid, x, y, IEI
    #	<subdir>/tables/edges.txt, with columns from, to, cost
    #
    # Results:
    #	<subdir>/tables/edgeweights.txt, with columns from, to, edgeweight (if iteration = 0)
    #		or
    #	<subdir>/tables/ew.txt, with columns from, to, edgeweight (if iteration > 0), to be 
    #	   assembled by ECOGRAPH
    #
    # *** Note: Run this in 64-bit R!
    # 
    # B. Compton, 5-7 Apr 2022 (from test.edge.betweenness)
    # 25 Apr 2022: add keepcost option. 6 May: no, drop it--both.graph2shape brings it across to shapefile
    
    
    
    library(igraph)
    source('x:/LCC/Code/ecoConnect/read.graph.R')
    
    
    t0 <- proc.time()[3]
    q <- read.graph(paste0(subdir,'tables/'), undirect = TRUE)
    n <- q[[1]]; e <- q[[2]]
    
    if(randomize > 0) {
        cat('Randomizing costs with s.d. = ', randomize, '\n')
        e$cost <- e$cost * (rnorm(dim(e)[1], sd = randomize) + 1)     # multiply cost by normal random deviates + 1
        if(any(e$cost <= 0)) stop('Random costs fall below zero--try using a smaller value for randomize')
    }
    else if(randomdrop > 0) {
        cat('Randomly dropping ',randomdrop * 100, '% of edges\n')
        e <- e[runif(dim(e)[1]) > randomdrop, ]
    }
    
    g <- graph_from_data_frame(e, directed = FALSE, vertices = n)    # convert to graph object
    
    cat('Calculating edge betweenness...\n')
    e$edgeweight <- edge_betweenness(g, directed = FALSE, weights = edge_attr(g, 'cost'))
    cat('Time: ', proc.time()[3] - t0, 's\n')
    
    f <- paste0(subdir, 'tables/', ifelse(iteration == 0, 'edgeweights.txt', paste0('ew', iteration, '.txt')))
    write.table(e[, c('from', 'to', 'edgeweight')], f, row.names = FALSE, sep = '\t', quote = FALSE)
    cat('Edge weights table for Pass 3 written to ', f, '\n', sep = '')

#    nodesX <<- n; edgesX <<- e            # ****************TEMPORARY, FOR TESTING
}