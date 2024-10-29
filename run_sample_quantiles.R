# sample quantiles
# run sample.for.quantiles a few times
# B. Compton, 29 Oct 2024



source('X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.R')

i <- 2
m <- 7                            # this is how many minutes it takes to read data
Sys.sleep(60 * m * i)            # sleep to give other runs a chance to load data. Set i to iteration number

#sample.for.quantiles(n = 1e6, postfix = 'new')   # 2 hrs expected
sample.for.quantiles(n = 1e7, postfix = 'new')   # 24 hrs expected