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
saved.small <- readRDS('x:/temp/saved.small.RDS')


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



saved <- saved.small
cat('----------\n')
gc()
profvis(sample.for.quantiles(n = 1e4, postfix = 'testx'))
profvis(sample.for.quantiles(n = 1e5, postfix = 'testx'))
cat('----------\n')


# fuck profvis. Piece of shit crashes all the time
# 
# 
saved.small <- readRDS('x:/temp/saved.small.RDS')
saved <- saved.small
sample.for.quantiles(n = 5e5, postfix = 'testnew')



source("X:/LCC/Code/ecoConnect_aux/get.quantiles.R")
get.quantiles(postfix = 'test1')
q1 <- readRDS('x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ecoConnect_quantiles_test1.RDS')

get.quantiles(postfix = 'testnew')
q2 <- readRDS('x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ecoConnect_quantiles_testnew.RDS')

# plot some q1s against q2s. About the same?

plot(q1$full[1,1,1,1,], 1:100, ty = 'l', col = 'red')
lines(q2$full[1,1,1,1,], 1:100, ty = 'l', col = 'green')

plot(q1$state[5,1,1,1,], 1:100, ty = 'l', col = 'red')         # Maryland
lines(q2$state[5,1,1,1,], 1:100, ty = 'l', col = 'green')

plot(q1$state[9,1,1,1,], 1:100, ty = 'l', col = 'red')         # New York
lines(q2$state[9,1,1,1,], 1:100, ty = 'l', col = 'green')

plot(q1$state[11,1,1,1,], 1:100, ty = 'l', col = 'red')         # Rhode Island
lines(q2$state[11,1,1,1,], 1:100, ty = 'l', col = 'green')


