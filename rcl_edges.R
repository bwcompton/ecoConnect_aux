'rcl_edges' <- function() {
   
   # Process edge files for Regional Critical Linkages
   # Read subdir/edges.txt from ECOCONNECT Pass 1
   # and subdir/rcl_edges from RCLPATHS
   # and tables/rcl_crossings
   # toss rcl_edges below delta_threshold
   # keep only crossings that occur in trimmed rcl_edges
   # and write to subdir/rcl_trimmed_crossings.txt
   # Arguments:
   # Result:
   # B. Compton 16 Jan 2025
   
   
   
   x <- read.table('x:/LCC/GIS/Final/ecoRefugia/rcl_fo_fowet/tables/rcl_edges_temp.txt', sep = '\t', header = TRUE)
   e <- read.table('x:/LCC/GIS/Final/ecoRefugia/rcl_fo_fowet/tables/edges.txt', sep = '\t', header = TRUE)
   
   
   y <- merge(x, e, by = c('from', 'to'))
   y$delta <- y$edgeweight - y$cost
   z <- aggregate(y$delta, by = list(y$crossing), FUN = max)
   
   
   
}