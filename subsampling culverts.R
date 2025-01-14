# look at how much we can narrow down crossings for regional Critical Linkages project
# B. Compton, 6 Jan 2025



all <- read.table('X:/LCC/Data/Crossings/results/ner_latest/sel_crossings.txt', sep = '\t', header = TRUE)



dim(all)[1]
sum(all$bridgeprob >= 0.1) / dim(all)[1]
sum(all$bridgeprob >= 0.25) / dim(all)[1]
sum(all$bridgeprob >= 0.5) / dim(all)[1]

sum(all$bridgeprob >= 0.1)
sum(all$bridgeprob >= 0.25)
sum(all$bridgeprob >= 0.5)



x <- all[sample(1:dim(all)[1], size = 1000), ]
hist(log(x$d8accum + 0.5))
plot(log(x$d8accum + 0.5), x$bridgeprob)


sum(all$bridgeprob >= 0.25 & all$ADT >= 1000)
sum(all$bridgeprob >= 0.25 & all$ADT >= 1000) / dim(all)[1] * 100
