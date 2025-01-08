'rcl_crossings' <- function(flow, traffic, source = 'x:/LCC/GIS/Final/NER/caps_phase5/tables/crossings.txt') {
   
   
   # Screen crossings table for Regional Critical Linkages, given flow and traffic thresholds
   # Arguments:
   #     flow           threshold of flow accumulation (column d8accum) as a surrogate for bridgeprob
   #     traffic        threshold of traffic (column ADT)
   # Results:
   #     rcl_crossings.txt    screened file, in same directory as source
   # B. Compton, 8 Jan 2025
   
   
   
   x <- read.table(source, sep = '\t', header = TRUE)
   cat('Source has ', dim(x)[1], ' cases\n')
   
   x <- x[x$d8accum >= flow & x$ADT >= traffic, ]
   f <- paste0(dirname(source), '/rcl_', basename(source))
   write.table(x, f, row.names = FALSE)
   
   cat('Result has ', dim(x)[1], 'cases; written to ', f, '\n')
}