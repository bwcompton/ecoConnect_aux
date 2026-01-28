C ECOCONNECT subdir;X;override_metrics;P;override_pars;systems;spacing;prune;maxdist;npaths;meander;momentum;iterations;randomize;randomdrop;maxpernode;F;pass1conduct;subsys;S;Z;T;long_diag
⍝Run regional ecosystem connectivity for subdir ⍵ and passes ⍺ (default: 0 1 2 3)
⍝Sets project name; uses existing priority and other parameters
⍝Calls:
⍝   Pass 0: ECONODES
⍝   Pass 1: ECOPATHS
⍝   Pass 2: ECOGRAPH
⍝   Pass 3: ECOPATHS (again)
⍝
⍝Writes finish_run.txt in top-level directory with calls to stitch results and make shapefiles
⍝After this process finishes, (see c:\Work\LCCdocs\Regional Connectivity FAQ.docx for full details)
⍝   x:/LCC/Code/ecoConnect/rescale.ecoconnect.R         rescales metrics for posting on SFTP and GeoServer
⍝   x:/LCC/Code/ecoConnect/ecoConnect_tool_prep.R       preps ecoConnect and IEI for posting on the GeoServer
⍝   x:/LCC/Code/ecoConnect/package.ecoconnect.R         package and post results for umassdsl.org
⍝   copy geoTIFFs from x:/LCC/GIS/Final/ecoRefugia/ecoConnect_final/ to umassdsl.webgis1.com, 
⍝       /appservers/apache-tomcat-8x/webapps/geoserver/data/EcoConnect via FileZilla
⍝   x:/LCC/Code/ecoConnect/ecoconnect.quantiles.R       calculates percentiles for ecoConnect.tool
⍝
⍝Primary parameters, set in [ecoconnect]:
⍝ Shared parameters
⍝   subdir              path for results (full path or subdirectory of clii path; use x:\LCC\GIS\Final\ecoRefugia\)
⍝
⍝ Selected ECONODES parameters
⍝   systems         list of systems to include, comma-separated. Use synonyms for formations or other groupings.
⍝   subsys          if no, use standard landcover; if yes, use subsyswet. Use yes for groups with subsystems such as floodplains
⍝   spacing         spacing for points (m). Will be adjusted to be an integral number of cells.
⍝   prune           pruning radius. If nonzero, drop points to enforce spacing of at least prune (m)
⍝
⍝ Selected ECOPATHS parameters
⍝   maxdist         maximum path length, Euclidean clip (m). [1] Bandwidth for the kernel; nodes are only connected within this 
⍝                   functional distance; [2] don't connect nodes beyond this Euclidean distance (optional)
⍝   npaths          number of random low-cost paths to find between each pair of nodes npaths[1] for Pass 1, npaths[2] for Pass 3
⍝   meander         how far should RLCPs deviate from the least-cost path? (0 = LCP; 1 = random walk)
⍝   momentum        strength and persistence for momentum (use 0 to turn momentum off)
⍝   long_diag       yes if using 1.4 for diagonals (ecoConnect), no if running square kernels (RCLPATHS)
⍝   pass1conduct    if 1, write conductance grid in Pass 1. Conductance is always written in Pass 3

⍝
⍝ Selected ECOGRAPH parameters
⍝   iterations      number of iterations for randomize or randomdrop. Use 1 if not randomizing.
⍝   randomize       s.d. for randomization.  Randomize edge cost, multiplying
⍝                   cost by random normal deviates with s.d. <randomize>.    Use 0 to 
⍝                   turn off randomization. Don't try using both randomize and 
⍝                   randomdrop in the same run!
⍝   randomdrop      proportion of edges to randomly drop.  Use 0 to turn off randomdrop.
⍝                   Don't try using both randomize and randomdrop in the same run!
⍝   maxpernode      Maximum number of threads on each machine, as APL + R hog memory
⍝
⍝Boring parameters that rarely change are set directly in [econodes], [ecopaths], and [ecograph]
⍝Note: pass is reset from 1 to 3 in ECOPATHS_P3
⍝B. Compton, 26-31 May 2022 (from REFUGIA)
⍝10 Jun 2022: add maxpernode for ECOGRAPH call so we don't blow out memory
⍝16 Jun 2022: call FINISH_ECOCONNECT explicitly; bring in pass1conduct; create result paths
⍝4 Oct 2022: add subsys option to accomidate floodplain forests or riparian
⍝7 Oct 2022: write finish_run.txt to create GIS results
⍝7 Aug 2023: clean up minor bug with passes
⍝17 Jan 2025: add long_diag for RCLPATHS



 ⍎(0=⎕NC'C')/'C←0 1 2 3'        ⍝Default is all passes
 
 INIT
 READPARS ME
 ⎕←'Running passes ',(⍕C),' for subdir ',(subdir←subdir,('\'≠¯1↑subdir←FRDBL TOLOWER subdir)/'\'),', systems ',systems ⋄ FLUSH

 
 C←C,(F←∨/C∊1 3)/4              ⍝If doing Pass 1 or 3, also call FINISH_ECOCONNECT
 X←(((4+F),6)⍴'ECONODES' 'yes' '*' 1 0 0 'ECOPATHS' 'yes' '*' 1000 0 0 'ECOGRAPH' 'yes' '*' 1 0 maxpernode 'ECOPATHS_P3' 'yes' '*' 1000 0 0 'FINISH_ECOCONNECT' 'yes' '*' 1 0 0)[(C←,C)+1;]
 X←(1↓(2×1↑⍴X)⍴0 1)⍀X
 X[¯1↓2×⍳⍴C;]←((¯1+⍴C),6)⍴'@wait' '' '' 0 0 0
 override_metrics←X
 

 ⍝Set CAPS parameters
 P←'[caps]∣project = ''ecoconnect-',((subdir≠'\')/subdir),''''

 ⍝Set parameters for ECONODES
 P←P,'∣[econodes]∣subdir = ''',subdir,'''∣systems = ''',systems,'''∣spacing = ',(⍕spacing),'∣prune = ',⍕prune
 :if subsys
    P←P,'∣landcovername = ''subsys_wet''∣landclasses = ''landcover_subsys.par''∣synonymsname = ''synonyms_subsys.par'''
 :else
     P←P,'∣landcovername = ''land''∣landclasses = ''landcover.par''∣synonymsname = ''synonyms.par'''
 :end
 
 ⍝Set parameters for ECOPATHS (we set pass 1 here; pass 3 is set when we call ECOPATHS_P3
 P←P,'∣[ecopaths]∣subdir = ''',subdir,'''∣maxdist = ',(⍕maxdist),'∣npaths = ',(⍕npaths),'∣meander = ',(⍕meander),'∣momentum = ',(⍕momentum),'∣long_diag = ',(⍕long_diag),'∣pass1conduct = ',(⍕pass1conduct),'∣pass = 1∣finish = '''''

 ⍝Set parameters for ECOGRAPH
 P←P,'∣[ecograph]∣subdir = ''',subdir,'''∣iterations = ',(⍕iterations),'∣randomize = ',(⍕randomize),'∣randomdrop = ',⍕randomdrop

 ⍝Set parameters for FINISH_ECOCONNECT
 P←P,'∣[finish_ecoconnect]∣subdir = ''',subdir,'''∣passes = ',⍕(1⌈⍴T)↑T←(C∊(pass1conduct/1),3)/C

 override_pars←('.∣.',⎕TCNL) TEXTREPL P
 MAKEDIR pathQ PATH subdir,'tables\'
 MAKEDIR pathQ PATH subdir,'results\'
 CAPSx


⍝Put together file for finishing off everything
 Z←'Finishing off run for ',(S←pathQ PATH subdir),(2⍴⎕TCNL),'--- Stitch source data:',⎕TCNL
 READPARS 'econodes'
 Z←Z,MTOV MIX (⊂'STITCH ''',(S,'tables\')),¨(savesystems saveieis savetiles / 'systems' 'ieis' 'tiles'),¨⊂'_tm'''
 Z←Z,⎕TCNL,⎕TCNL,'--- Stitch results:',⎕TCNL
 Z←Z,MTOV MIX (⊂'STITCH ''',(S,'results\')),¨'conduct''' 'conduct_p1'''
 Z←Z,⎕TCNL,⎕TCNL,'--- Make shapefiles: (note: export edges to a geodatabase for far faster display)',⎕TCNL,⎕TCNL
 Z←Z,'source(''x:/LCC/Code/Prep/shapefiles/make.shapefile.R'')',⎕TCNL
 Z←Z,'source(''x:/LCC/Code/ecoRefugia/both.graph2shape.R'')',⎕TCNL,⎕TCNL
 Z←Z,'make.shapefile(''',('.\./' TEXTREPL S,'tables\nodes.txt'''), ', x = ''x'', y = ''y'', ref = ''DSL'')',⎕TCNL
 Z←Z,'both.graph2shape(''','.\./' TEXTREPL S,'tables/'')'

 Z NWRITE S,'finish_run.txt'


 ⎕←⎕TCNL,⎕TCNL,'ECOCONNECT launched. Finishing file is ',S,'finish_run.txt' ⋄ FLUSH
 CLEAR