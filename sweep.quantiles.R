'sweep.quantiles' <- function(quantiles, samples, min.sample = 100) {
   
   # Sweep percentiles across acerages to fill inadequate sample sizes. Smaller blocks are a better estimate of percentiles 
   # than a tiny sample size. 
   # 
   # Arguments:
   #     quantiles      5d array of region x acres x systems x all/best x 100 with percentiles
   #     samples        matrix of region x acres with sample sizes
   #     min.sample     minimum sample size to accept
   # Result (2 element list):
   #     quantiles      quantiles with swept values
   #     final.samples  matrix of new sample sizes
   #  
   # B. Compton, 21 Oct 2024 (on Amtrack train 56, heading north)
   
   
   
   z <- quantiles
   s <- samples
   
   have.regions <- dim(samples)[1] > 1                                        # true if we have multiple regions (states or hucs)
   if(dim(quantiles)[2] >= 2)                                                 # if we have more than one block size,
      for(i in 1:dim(quantiles)[1])                                           #    for each region,   
         for(j in 2:dim(quantiles)[2])                                        #       for each block size,
            if(samples[i, j + have.regions] < min.sample &
               samples[i, j + have.regions] < s[i, j + have.regions - 1]) {   #          if sample is too small,
               z[i, j, , , ] <- z[i, j - 1, , , ]                             #             sweep quantiles from previous block size
               s[i, j + have.regions] <- s[i, j + have.regions - 1]           #             and update sample sizes
            }
   
   list(quantiles = z, final.samples = s)
}