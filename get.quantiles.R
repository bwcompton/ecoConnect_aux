'get.quantiles' <- function(sourcepath = 'x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/', postfix) {
   
   # Process samples from one or more sample.for.quantiles runs
   # Arguments:
   #     sourcepath     path to sample files from sample.for.quantiles
   #     posfix         postfix of sample files
   #  
   # Reads:
   #     stateinfo.txt  table of state classes and state names
   #     hucinfo.txt    table of HUC8 classes and 8 digit HUC8 code
   #     all <sourcepath>ec_samples_<postfix>*.RDS, which contain:
   #        samples        4d array of sampled values (n x acres x systems x all/best)
   #        statehuc       array of state and HUC for each sample (n x 2)
   #        acres          vector of sampled block sizes
   #        layers         vector of system names
   #  
   # Result (written to sourcepath):
   #   ecoConnect_quantiles.RDS
   #     RDS with three arrays
   #        full, state, huc
   #     each with 5 dimensions
   #        1. region (full = 1, state = 14, huc = 245)
   #        2. acres (5 or 6)
   #        3. systems (4)
   #        4. all/best (2)
   #        5. percentiles (100)
   #     and 2 tables
   #        stateinfo and hucinfo
   #   sample_sizes_full.txt, sample_sizes_final_full.txt
   #   sample_sizes_state.txt, sample_sizes_final_state.txt
   #   sample_sizes_huc.txt, sample_sizes_final_huc.txt
   #     tables of region/state name/huc ID by acres with actual sample sizes and final sample sizes after sweeping
   #     
   #  realized.acres (printed to console)
   #     a conversion from nominal acres to actual acerage of pseudoparcels. Use this in make.report.percentiles when interpolating percentiles for a given parcel.
   # B. Compton, 18 Oct 2024: split into sample.for.quantiles and get.quantiles from ecoConnect.quantiles
   
   
   
   library(lubridate)
   library(abind)
   
   source('sweep.quantiles.R')
   
   launch <- now()
   ts <- Sys.time()
   
   sinfo <- read.table(paste0(sourcepath, 'stateinfo.txt'), sep = '\t', header = TRUE)          # we'll use these for sample size tables
   hinfo <- read.table(paste0(sourcepath, 'hucinfo.txt'), sep = '\t', header = TRUE)
   
   files <- list.files(sourcepath, paste0('ec_samples_', postfix, '.*\\.RDS$'))
   cat('Found ', length(files), ' sample files\n', sep = '')
   
   for(i in 1:length(files)) {
      cat(paste0('Reading ',sourcepath, files[i], '...\n'))
      x <- readRDS(paste0(sourcepath, files[i]))
      if(i == 1) {
         z <- x$samples
         statehuc <- x$statehuc
         acres <- x$acres
         layers <- x$layers
         realized.acres <- x$realized.acres 
      }
      else {
         z <- abind(z, x$samples, along = 1)
         statehuc <- rbind(statehuc, x$statehuc)
      }
      cat('Total samples: ', dim(z)[1], '\n', sep = '')
   }
   
   
   # Intermediate result z is 4d array of row x acres x systems x all/best
   # Result quantiles.* are 5d arrays of region x acres x systems x all/best x 100 with percentiles
   # Result samples.* are 2d arrays of region x acres with sample sizes
   
   cat('Calculating percentiles...\n')
   rc <- c(1, max(sinfo$class), max(hinfo$class))                                               # number of classes in each region (1 for full, 14 states, 245 HUCs)
   
   
   # Now take percentiles and sample sizes
   for(h in 1:length(rc)) {                                                                     # For each set of regions,
      dn <- list(regions = 1:rc[h], acres = gsub(' ', '', format(acres)), layers = layers, 
                 all.best = c('all', 'best'), percentile = 1:100)                               #    array names
      qu <- array(NA, dim = c(rc[h], length(acres), length(layers), 2, 100), dimnames = dn)     #    quantiles for region set
      ss <- array(NA, dim = c(rc[h], length(acres)))                                            #    sample sizes for region set
      
      for(i in 1:rc[h]) {                                                                       #    For each region,
         if(h == 1)                                                                             #       Select samples that fall in region
            y <- z
         else {
            if(!i %in% statehuc[, h - 1])                                                       #       just to be safe, though all states and HUCs should be represented
               next
            y <- z[statehuc[, h - 1] == i, , , , drop = FALSE]
         }
         for(j in 1:dim(y)[2]) {                                                                #       For each block size (we might not have all acerages),
            ss[i, j] <- sum(!is.na(y[, j, 1, 1]))                                               #          collect sample sizes (identical across systems and all/best)
            for(k in 1:length(layers)) {                                                        #          For each layer,
               for(l in 1:2) {                                                                  #             For all/best,   
                  qu[i, j, k, l, ] <- quantile(y[, j, k, l], 
                                               prob = seq(0.01, 1, by = 0.01),  
                                               na.rm = TRUE, names = FALSE)                     #                take percentiles
               } 
            }  
         }
      }
      
      ss[is.na(ss)] <- 0
      switch(h, {                                                                               # save results to appropriate region variable
         quantiles.full <- qu
         samples.full <- data.frame(ss)
         names(samples.full) <- acres
       },
      {
         quantiles.state <- qu
         samples.state <- data.frame(cbind(sinfo$postal[match(sinfo$class, 1:dim(sinfo)[1])]), ss)
         names(samples.state) <- c('Postal', acres)
      },
      {
         quantiles.huc <- qu
         samples.huc <- data.frame(cbind(hinfo$HUC8_code[match(hinfo$class, 1:dim(hinfo)[1])]), ss)
         names(samples.huc) <- c('HUC8_code', acres)
         
      })
      
      cat('Finished calculating quantiles for ', c('full region', 'states', 'HUC8s')[h], '.\n', sep = '')
   }
   
   x <- sweep.quantiles(quantiles.full, samples.full)
   quantiles.full <- x$quantiles
   samples.full.final <- x$final.samples
   
   x <- sweep.quantiles(quantiles.state, samples.state)
   quantiles.state <- x$quantiles
   samples.state.final <- x$final.samples
   
   x <- sweep.quantiles(quantiles.huc, samples.huc)
   quantiles.huc <- x$quantiles
   samples.huc.final <- x$final.samples
   
   
   cat('Writing results...\n')
   if(postfix != '')
      postfix <- paste0('_', postfix)
   
   x <- list(full = quantiles.full, state = quantiles.state, huc = quantiles.huc, stateinfo = sinfo, hucinfo = hinfo)
   saveRDS(x, f <- paste0(sourcepath, 'ecoConnect_quantiles', postfix, '.RDS'))               # write quantiles to RDS
   
   write.table(samples.full, paste0(sourcepath, 'sample_sizes_full', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)          # write sample size text files
   write.table(samples.state, paste0(sourcepath, 'sample_sizes_state', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   write.table(samples.huc, paste0(sourcepath, 'sample_sizes_huc', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)

   write.table(samples.full.final, paste0(sourcepath, 'sample_sizes_final_full', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)          # write sample size text files
   write.table(samples.state.final, paste0(sourcepath, 'sample_sizes_final_state', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
   write.table(samples.huc.final, paste0(sourcepath, 'sample_sizes_final_huc', postfix, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
      
   elapsed <- format(seconds_to_period(round(as.duration(interval(ts, Sys.time())), 1)))
   
   cat('Results written to ', f, '\n', sep = '')
   cat('and sample sizes to ', paste0(sourcepath, 'sample_sizes_*', postfix, '.txt'), '\n')
   cat('Total time taken: ', elapsed, '\n', sep = '')
}
