# Assess noise in RCLPATHS
# Results are from a partial run of RCLPATHS that doesn't change culverts
# B. Compton, 14 Jan 2025



x <- read.table('x:/LCC/GIS/Final/ecoRefugia/fo_fowet/tables/rcl_edges.txt', sep = '\t', header = TRUE)
e <- read.table('x:/LCC/GIS/Final/ecoRefugia/fo_fowet/tables/edges.txt', sep = '\t', header = TRUE)



y <- merge(x, e, by = c('from', 'to'))

# edges.txt is 1,640,680 rows
# rcl_edges.txt will be about 4,960,748 rows, is 2,797,862 now
# y is 2,797,862 rows

s <- y[sample(1:dim(y)[1], size = 5000),]          # a reasonable sample
plot(s$edgeweight, s$cost, pch = '.')              # x-y plot
s$ratio <- s$edgeweight / s$cost
hist(s$ratio)


y$ratio <- y$edgeweight / y$cost
hist(y$ratio, nclass = 50)
mean(y$ratio)                                      # how much bias is there? mean = 1.00471. Not much, so I apparently didn't screw things up

sd(y$ratio)                                        # how noisy are results? sd = 0.09648087, so results are pretty noisy - we'll need a >20% change in edge weight

hist(y$edgeweight, nclass = 50)


# well, damn. I think this is too noisy to work
# Options:
# 1. just go ahead with it and see how it works
# 2. increase reps from n = 30 to much larger. Would have to run before and after, so runtime will be 2 x multiple of n
# 3. use mean instead of median?
# 4. mess with meander or other RLCP parameters to make paths less noisy
# 5. just cut to the chase and use least-cost paths. Would have to run for before and after.