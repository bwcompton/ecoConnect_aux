'rcl_crossings' <- function(flow, bridgeprob = 0.25, traffic = 1000, source = 'x:/LCC/GIS/Final/NER/caps_phase5/tables/crossings.txt') {
   
   
   # Screen crossings table for Regional Critical Linkages, given flow and traffic thresholds
   # Arguments:
   #   ( flow           threshold of flow accumulation (column d8accum) as a surrogate for bridgeprob - later for this )
   #     bridgeprob     I'm using bridgeprob directly at this early stage; we'll replace it with flow later
   #     traffic        threshold of traffic (column ADT)
   # Results:
   #     rcl_crossings.txt    screened file, in same directory as source
   # B. Compton, 8 Jan 2025
   
   
   
   x <- read.table(source, sep = '\t', header = TRUE)
   cat('Source has ', dim(x)[1], ' cases\n')
   
 #  x <- x[x$d8accum >= flow & x$ADT >= traffic, ]
   x <- x[x$bridgeprob >= bridgeprob & x$ADT >= traffic, ]
   f <- paste0(dirname(source), '/rcl_', basename(source))
   write.table(x, f, row.names = FALSE)
   
   cat('Result has ', dim(x)[1], 'cases; written to ', f, '\n')
}