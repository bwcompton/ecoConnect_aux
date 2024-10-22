'looptest' <- function(n = 1e8, n.factor = c(1, 1, 1, 1, 1e2, 1e3, 1e4), acres  = c(1, 10, 100, 1000, 1e4, 1e5, 1e6), 
                       best.pct = 0.5, layers = c('forests', 'ridgetops', 'wetlands', 'floodplains' ), 
                       server.names = c('Forest_fowet', 'Ridgetop', 'Nonfo_wet', 'LR_floodplain_forest'),
                       sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/', postfix = '', 
                       threshold = 0.25) {
   
   
   # massively slimmed-down version of ecoConnect.quantiles to try to figure out why run time is non-linear with n
   # 17 Oct 2024  
   
   
   
   library(lubridate)
   library(progressr)
   handlers(global = TRUE)                                                                      # for progress bar
   handlers('rstudio')
   skip <- 100                                                                                   # report progress every skipth iteration
   pb <- progressor(n / skip)
   ts <- Sys.time()
   
   z <- array(NA, dim = c(n, 7, 4, 2))                                                             # row x acres x systems x all/best
   
   
   # gather samples
   for(i in 1:n) {                                                                              # For each sample,
      for(j in 1:7) {                                                                  #          for each block size,
         for(k in 1:4) {                                                               #             for each layer,
            z[i, j, k, 1] <- floor(runif(1) * 1e5)                                     #                sample all values
            z[i, j, k, 2] <- floor(runif(1) * 1e5)                                    #                sample top best.pct
         }
      }
      if(i %% skip == 0)                                                               #       update progress bar every nth iteration
         pb()
   }
   
   
   
   elapsed <- format(seconds_to_period(round(dur <- as.duration(interval(ts, Sys.time())))))
   cat('Total time taken: ', elapsed, '\n', sep = '')
   cat('Time per step x 1000 = ', 1000 * dur / n, '\n', sep = '')
}
