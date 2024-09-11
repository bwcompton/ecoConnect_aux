'read.graph' <- function(path = '', undirect = TRUE) {
    
    # read.graph
    # Read nodes and edges text files return them as data frames
    # Arguments:
    #   path       path to source files
    #   undirect   if TRUE, convert to a nondirected graph. Unnecessary if graph is already nondirected
    #
    # Source:
    #   nodes.txt, with columns nodeid, x, y, IEI
    #	edges.txt, with columns from, to, cost
    #	
    #	Note: throws an error if any of these columns are missing
    #	
    # Returns:
    #   a list of nodes and edges
    #   
    # B. Compton, 7 Apr 2022 (from text2graph)
    
    
     
    cat('Reading graph ',paste0(path, 'nodes.txt'), ' and ', paste0(path, 'edges.txt'), '\n', sep = '')

    n <- read.table(paste0(path, 'nodes.txt'), sep = '\t', header = TRUE)
    e <- read.table(paste0(path, 'edges.txt'), sep = '\t', header = TRUE)
    
    if (!all(c('nodeid', 'x', 'y', 'IEI') %in% names(n))) stop ('Missing coluns in nodes.txt!')
    if (!all(c('from', 'to', 'cost') %in% names(e))) stop ('Missing coluns in edges.txt!')
    
    e$cost <- pmax(e$cost, 0.01)    # make sure there are no zero costs!
    
    if(undirect) {                  # take mean across directions to make this a nondirected graph
        e[b, c('from', 'to')] <- e[b <- e$from > e$to, c('to', 'from')]         #    convert to lower triangle
        e <- aggregate(e$cost, by = list(e$from, e$to), FUN = mean)
        names(e) <- c('from', 'to', 'cost')
    }
    list(n, e)
}
