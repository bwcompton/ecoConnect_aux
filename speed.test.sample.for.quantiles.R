library(profvis)
source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.R")


profvis(sample.for.quantiles(n = 1e2, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))
profvis(sample.for.quantiles(n = 1e3, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))
profvis(sample.for.quantiles(n = 1e4, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))
profvis(sample.for.quantiles(n = 1e5, postfix = 'test', n.factor = 1, acres  = c(1, 10, 100, 1000, 1e4, 1e5)))


