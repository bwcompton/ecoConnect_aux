# run_sample_quantiles
# run sample.for.quantiles a few times
# B. Compton, 29 Oct 2024



source('X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.R')
source('X:/LCC/Code/ecoConnect_aux/get.quantiles.R')


i <- 3
m <- 7                            # this is how many minutes it takes to read data
Sys.sleep(60 * m * i)            # sleep to give other runs a chance to load data. Set i to iteration number


sample.for.quantiles(postfix = 'new')   # repeats forever in ~1 hour increments

# sample.for.quantiles(postfix = 'try25', best.pct = 0.25)   # repeats forever in ~1 hour increments
# get.quantiles(postfix = 'try25', maxfiles = 30)