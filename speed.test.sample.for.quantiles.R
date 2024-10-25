library(profvis)
source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.R")


profvis(sample.for.quantiles(n = 1e2, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))
profvis(sample.for.quantiles(n = 1e3, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))
profvis(sample.for.quantiles(n = 1e4, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))
profvis(sample.for.quantiles(n = 1e5, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))



# bring back in 1e6 blocks and n.factor
profvis(sample.for.quantiles(n = 1e4, postfix = 'test'))
profvis(sample.for.quantiles(n = 1e5, postfix = 'test'))
profvis(sample.for.quantiles(n = 1e6, postfix = 'test'))
profvis(sample.for.quantiles(n = 1e7, postfix = 'test'))


# I'm getting hard R crashes on 1e6 run, maybe due to profvis (I hope!)
sample.for.quantiles(n = 1e4, postfix = 'test')
sample.for.quantiles(n = 1e5, postfix = 'test')
sample.for.quantiles(n = 1e6, postfix = 'test')
sample.for.quantiles(n = 1e7, postfix = 'test')
