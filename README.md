# R and APL code for graph processing and various post-processing and packaging for ecoConnect 

Note: Passes 1 and 3 are APL code, in APL/*.apl. All other code is in R.

## Top-level call and all passes for ecoConnect (APL)

	ECOCONNECT (top-level function, with info on passes and parameters in comments)
		ECONODES (pass 0)
		ECOPATHS (pass 1)
		ECOGRAPH (pass 2)
		ECOPATHS (again, pass 3)

## Pass 2 of ECOCONNECT, (in R, called by APL function ECOGRAPH)

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
