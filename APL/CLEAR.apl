CLEAR;∆Z;∆T
⍝Erase anything bigger than 20k + selected parameters

 ⍞←(~'CAPS'≡STRIP ⎕WSID)/'¡¡¡ WARNING: Workspace is ',⎕WSID,', not CAPS !!!',⎕TCNL
 CLEANUP        ⍝Release buffers from grid DLL
 ∆Z←(20E3<⊃,/⎕SIZE¨↓⎕NL 2)⌿⎕NL 2
 ⍎(0≠⎕NC'set')/'∆Z←∆Z OVER set'     ⍝Parameters set by metrics
 ⍎(0≠⎕NC'∆set')/'∆Z←∆Z OVER ∆set'   ⍝and by SETPARS

 ∆T←⎕EX 'erased'
 anthilldir←''
 ∆Z←∆Z OVER MATRIFY 'target iter spread donut resist suffix cost head gridwindow headlab search self logfile makearc environ'
 ∆Z←∆Z OVER MATRIFY 'needtiles logbuf result seed iei_target iei_floor loc_floor need_floor represent_target iei_scale sys_target'
 ∆Z←∆Z OVER MATRIFY 'metric_pars metrics inputs wspars set cluster post community REST noarc'
 ∆Z←∆Z OVER MATRIFY 'year scenario loop blockid fileptr computername time firstblock noread block settings clear_results break test'
 ∆Z←∆Z OVER MATRIFY 'bandwidth classes values buffer multiplier threshold err friskonly checkland newdll example qtiles timestep'
 ∆Z←∆Z OVER MATRIFY 'xml index i tags rows disp mask refgrid'  ⍝ XMLCLEAR
 ∆Z←∆Z OVER MATRIFY 'pathI pathM pathP pathG pathR pathW pathA pathE pathD pathS pathT pathU pathF pathN pathQ pathH'
 ∆Z←∆Z OVER MATRIFY 'example blocks transparent friskonly checkland timestamp cluster post clear_results threshold newdll synonyms exclude landcover'
 ∆Z←∆Z OVER MATRIFY 'pars maxsunwindow streamvectors weatherhead targettable tragethead null biglakes port sunwindows strflow linkages finish'
 ∆Z←∆Z OVER MATRIFY 'dot override_pars override_metrics warnings crosstable tilemap tilemapinclude KK8 base watershedcall noland toomanyblocks mixtype crossings scales crossscores warn'
 ∆Z←∆Z OVER MATRIFY 'comment priority project owner timelimit tries gridwait cachewait computers notask projects tasks threads'
 ∆Z←∆Z OVER MATRIFY 'projects_ tasks_ computers_ threads_ defaults rpath aplpath aplworkspace rworkspace taskwait changed current iftrap switch slept sleep gridports maxthreads HELP'
 ∆Z←∆Z OVER MATRIFY 'house_bandwidth beach_bandwidth public_bandwidth D50 DS iei window workspace capsworkspace'
 ∆Z←∆Z OVER MATRIFY 'dams scores which scaleby uncertainty split backup onerror gridname maskbits lockserver uselockserver lockport lockwait rep'
 ∆Z←∆Z OVER MATRIFY 'allnames_FINDPATHS namestrip gridserverpostfix threadlimit locktimeout altmask fn substmosaics usemosaics where gridinfo gridinfofile lockpause'
 ∆Z←∆Z OVER MATRIFY 'mosaic mosaic_ mosaicwindow landscapewide mosaics writemosaics caching scramblesubtasks name recoverservers maxrecovery gridinitcount maxlocalgridinit maxsubtasks'
 ∆Z←∆Z OVER MATRIFY 'connections connections_ activeconnection referencewindow workingresolution workingcellsize cache scramble splittasks'
 ∆Z←∆Z OVER MATRIFY 'colsize rowsize cols rows panes lastrowsize lastcolsize panemap type source sourcetimestamp compressed gridserver ∆set mosaicref zippars checkalign rflags webpath regionalpost'
 ∆Z←∆Z OVER MATRIFY 'synonyms inputsP resultsP ocean bigwatersheds splitsubtasks inputspar resultspar synonymspar landcoverpar lookedup thread futuregrids futurepath cachetimeout benchmarks redirectreadpars'


 ∆Z←∆Z OVER MATRIFY ((2×⍴∆T)⍴1 0)\∆T←'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ'    ⍝All 1 letter variables
 ∆Z←((∆Z MATIOTA ∆Z)=⍳1↑⍴∆Z)⌿∆Z
 ∆Z←(2=⎕NC ∆Z)⌿∆Z  ⍝The above are variables, not functions!

 ⍎(0≠⎕NC'toclear')/'∆Z←∆Z OVER ''toclear'' OVER MIX toclear'

 ∆T←⎕EX ∆Z
 →(0∊⍴∆Z)/L1
 erased←'Erased:'
 erased←erased OVER ' ',' ',' ',(⎕PW-3)TELPRINT ∆Z
 erased←MTOV erased
 ⎕←(⍕1↑⍴∆Z),' items erased.  Type ''erased'' to see them.'
L1:RESET