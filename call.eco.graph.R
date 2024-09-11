# call.eco.graph
# Shell script to call eco.graph under Anthill from ECOGRAPH
# 
# Arguments (must be in order--don't change these without updating ECOGRAPH to match):
#	subdir		base path for source and results
#	randomize	s.d. for randomization.  Randomize edge cost, multiplying
#				cost by random normal deviates with s.d. <randomize>.	Use 0 to 
#				turn off randomization. Don't try using both randomize and randomdrop
#				in the same run!
#	randomdrop	proportion of edges to randomly drop.  Use 0 to turn off randomdrop.
#				Don't try using both randomize and randomdrop in the same run!
#	iteration   iteration number, if called in parallel by ECOGRAPH. If nonzero, 
#			   	results are written to ew<iteration>.txt, and ECOGRAPH will compile
#				temporary files into a single result, edgeweights.txt.
#
# B. Compton, 6-7 Apr 2022
# 26 Apr 2022: add keepcost for debugging and assessment. 6 May: no, drop it--both.graph2shape brings it across to shapefile



if(Sys.getenv("R_ARCH") != '/x64') stop('call.eco.graph needs to be run in 64-bit R!')

source('x:/LCC/Code/ecoConnect/eco.graph.R')

cat('Calling eco.graph...\n')
x <- commandArgs(trailingOnly = TRUE)
try(eco.graph(subdir = x[1], randomize = as.numeric(x[2]), randomdrop = as.numeric(x[3]), iteration = as.numeric(x[4])))

Sys.sleep(10)         # in case someone is watching

q('no')
