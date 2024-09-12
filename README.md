# R code for graph processing and various post-processing and packaging for ecoConnect 

## Pass 2 of ECOCONNECT, called by ECOGRAPH

	call.eco.graph.R
		eco.graph.R
			read.graph.R

		
## Data finishing, called after ECOCONNECT run

	both.graph2shape.R
		read.vectors.R
		save.vectors.attribs.R
		make.sf.line.segments.R
	
	make.shapefile.R (from x:/LCC/Code/Prep/shapefiles/)


## Post processing
	
	rescale.ecoConnect.R
	prep.ecoConnect.quantiles.R
	ecoConnect.quantiles.R


## Packaging/prep for GeoServer

	package.ecoConnect.R
	ecoConnect_tool_prep.R


## Species Refugia project

	graph2shape.R


## ecoConnect vulnerability (Objective 3 of 2022 NE CASC project)

	regional_connect_vuln.R
