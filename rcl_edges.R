'rcl_edges' <- function(subdir = 'rcl_fo_fowet', threshold = 0, path = 'x:/LCC/GIS/Final/ecoRefugia/') {
   
   # Process edge files for Regional Critical Linkages
   # Read subdir/edges.txt from ECOCONNECT Pass 1
   # and subdir/rcl_edges from RCLPATHS
   # and tables/rcl_crossings
   # toss rcl_edges below delta_threshold
   # keep only crossings that occur in trimmed rcl_edges
   # and write to subdir/rcl_trimmed_crossings.txt
   # Arguments:
   #     subdir      subdirectory for current ecological system
   #     threshold   threshold value for edge deltas
   #     path        base path
   # 
   # Source:
   #     subdir/tables/edges.txt
   #                 edges for all nodes from base ECOCONNECT Pass 1 run using LCPs
   #     subdir/tables/rcl_edges.txt
   #                 edges from nodes near selected crossings from RCLPATHS run
   #     caps_phase5/tables/rcl_crossigns.txt
   #                 crossings filtered by rcl_crossings.R
   # 
   # Result (in subdir/):
   #     rcl_crossings_trimmed.txt
   #                 version of rcl_crossings with only crossings with edge deltas above threshold
   #     rcl_edges_trimmed.txt
   #                 version of rcl_edges with only edges for trimmed crossings
   # B. Compton 21 Jan 2025
   
   
   
   x <- read.table(paste0(path, subdir, '/tables/rcl_edges.txt'), sep = '\t', header = TRUE)
   e <- read.table(paste0(path, subdir, '/tables/edges.txt'), sep = '\t', header = TRUE)
   crossings <- read.table('x:/LCC/GIS/Final/NER/caps_phase5/tables/rcl_crossings.txt', sep = '\t', header = TRUE)
   
   y <- merge(x, e, by = c('from', 'to'))
   y$delta <- y$cost - y$newcost
   
   z <- aggregate(y$delta, by = list(y$crossing), FUN = max)
   names(z) <- c('crossing', 'max')
   cross <- z$crossing[z$max > threshold]
   cat('Crossings with at least one improved edge: ', round(sum(z$max > 0) / dim(z)[1] * 100, 2), '%\n', sep = '')
   cat('Crossings with any edges above threshold (of ', threshold,'): ', round(sum(z$max > threshold) / dim(z)[1] * 100, 2), '%\n', sep = '')
   
   crossings <- crossings[crossings$row %in% cross, ]
   write.table(crossings, paste0(path, subdir, '/tables/rcl_crossings_trimmed.txt'), sep = '\t', quote = FALSE, row.names = FALSE)
   write.table(y, paste0(path, subdir, '/tables/rcl_edges_trimmed.txt'), sep = '\t', quote = FALSE, row.names = FALSE)
   
   cat('Results written to ', subdir, '/rcl_crossings_trimmed.txt and rcl_edges_trimmed.txt\n', sep = '')
   
   x<<-x; e<<-e; y<<-y; z<<-z; cross<<-cross; crossings<<-crossings     # for testing & debugging
}