source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.R")
# source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.thursday.R")
# source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.thursday2.R")
# source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.thursday3.R")
source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.1.R")
source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.2.R")
source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.3.R")
source("X:/LCC/Code/ecoConnect_aux/sample.for.quantiles.4.R")

# sample.for.quantiles.1(n = 10, postfix = 'testxx')
# saveRDS(saved, 'x:/temp/saved.RDS')
# saved <- readRDS('x:/temp/saved.RDS')


# sample.for.quantiles.thursday2(n = 1e4, postfix = 'test_thurs2')
# sample.for.quantiles.thursday3(n = 1e4, postfix = 'test_thurs3')
# gc()
# sample.for.quantiles.thursday(n = 1e4, postfix = 'test_thurs')
# sample.for.quantiles.thursday(n = 1e5, postfix = 'test_thurs')
# 
# 
saved <- saved.small
cat('----------\n')
gc()
sample.for.quantiles.1(n = 1e4, postfix = 'test1')
sample.for.quantiles.1(n = 1e5, postfix = 'test1')
cat('----------\n')
gc()
sample.for.quantiles.2(n = 1e4, postfix = 'test2')
sample.for.quantiles.2(n = 1e5, postfix = 'test2')
cat('----------\n')

saved <- saved.big
gc()
sample.for.quantiles.3(n = 1e4, postfix = 'test3')
sample.for.quantiles.3(n = 1e5, postfix = 'test3')
cat('----------\n')
gc()
sample.for.quantiles.4(n = 1e4, postfix = 'test4')
sample.for.quantiles.4(n = 1e5, postfix = 'test4')
cat('----------\n')
