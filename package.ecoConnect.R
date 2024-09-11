# make regional connectivity packages 
# B. Compton, 20 Sep 2023 (from package.all.forests.NJ.R)



source('X:/LCC/LCAD/load.LCAD.R')


#pkg.names <- c('ecoConnect_forests', 'ecoConnect_ridgetops', 'ecoConnect_wetlands', 'ecoConnect_floodplains',
#                'vuln_forests', 'vuln_ridgetops', 'vuln_wetlands')
# pkg.names <- c('ecoRefugia_spruce_fir', 'ecoRefugia_fen')

pkg.names <- c('zzzecoConnect_test')

for(i in pkg.names) {
    check.for.old.package.files(i, clear = TRUE)
    call <- paste0('make.package("', i, '")')
    simple.launch(call, name = i, owner = 'bwc', priority = 6)
}