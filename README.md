# R code for graph processing and various post-processing and packaging for ecoConnect 

Pass 2 of ECOCONNECT, called by ECOGRAPH

	call.eco.graph.R
		eco.graph.R
			read.graph.R

		
Data finishing, called after ECOCONNECT run

	both.graph2shape.R
		read.vectors.R
		save.vectors.attribs.R
		make.sf.line.segments.R
	
	make.shapefile.R (from x:/LCC/Code/Prep/shapefiles/)


Post processing
	
	rescale.ecoConnect.R
	prep.ecoConnect.quantiles.R
	ecoConnect.quantiles.R


Packaging/prep for GeoServer

	package.ecoConnect.R
	ecoConnect_tool_prep.R


Species Refugia project
	graph2shape.R


ecoConnect vulnerability (Objective 3 of 2022 NE CASC project)
	regional_connect_vuln.R


Debris (moved to old\)

	temp.graph2shape.R
	edges2shape.R
		text2graph.R
	test.edge.betweenness.R
	text2graph_old.R
	test.betweenness.R
	undirect.R
	text.edges2shape.R
	save.graph.R
	many.paths.R
	messing with edge betweenness.R
	messing around with getting data into igraph.R
	an edges2shape call.R
	graph2shape fragment.R
	add.path.R
	save.vectors.R
