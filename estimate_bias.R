# estimate bias toward diagnoal paths in edge costs
# Using LCPs in ECOPATHS gives a diagonal-looking lattice. I was worried that there was a big bias toward diagonal routes.
# This looks at whether costs for nodes that are mostly orthogonal are higher than nodes that are mostly diagonal. 
# They are not. r^2 = 0.0099.
# B. Compton, 21 Jan 2025



subdir <- 'rcl_fo_fowet'
path <- 'x:/LCC/GIS/Final/ecoRefugia/'


e <- read.table(paste0(path, subdir, '/tables/edges.txt'), sep = '\t', header = TRUE)
n <- read.table(paste0(path, subdir, '/tables/nodes.txt'), sep = '\t', header = TRUE)


x <- merge(e, n, by.x = 'from', by.y = 'nodeid')
names(x)[c(4,5)] <- c('from_x', 'from_y')

x <- merge(x, n, by.x = 'to', by.y = 'nodeid')
names(x)[c(7,8)] <- c('to_x', 'to_y')

x$x_dist <- abs(x$from_x - x$to_x)
x$y_dist <- abs(x$from_y - x$to_y)
x$ratio <- x$x_dist / x$y_dist                  # orthogonal neigbors will have very high or low ratio; diagonal neighbors will have ratio near 1


y <- x[sample(1:dim(x)[1], 1000), ]             # was way too much data
   
plot(log(y$ratio), y$cost)

y$abs_ratio <- y$ratio
y$abs_ratio[y$ratio < 1] <- 1 / y$abs_ratio[y$ratio < 1]
y <- y[!is.infinite(y$abs_ratio), ]
y$log_abs_ratio <- log(y$abs_ratio)
plot(y$log_abs_ratio, y$cost)
m <- lm(cost~log_abs_ratio, data = y)
summary(m)
abline(m)                                       # look at that. The line is flat!
