MOSAICINIT M;R;G;T;∆set;rowsize;colsize;rows;cols;panemap;W;extent;Q;B;S;C;L;I;U;V;S_;head;Y;D;O;Q_;J;H
⍝Defines the mosaic scheme used for all grids given ⍵ and ⍺
⍝Arguments:
⍝   ⍵[1] path to a mosaic
⍝   ⍵[2] path to gridservers.txt (default path: pathA)
⍝Sets:
⍝   mosaic, mosaic_ - definition of current mosaic scheme:
⍝      rowsize     cells in each pane row
⍝      colsize     cells in each pane column
⍝      rows        pane rows in each mosaic
⍝      cols        pane columns in each mosaic
⍝      panes       panes in mosaic (rows x cols)
⍝      lastrowsize number of rows of cells in bottom pane row
⍝      lastcolsize number of columns of cells in bottom pane column
⍝      panemap     string with compression binary vector (e.g.,
⍝                  '001010') indicating which panes contain data
⍝      compression always 'no' when created from gridio; a separate
⍝                  process compresses the TIFFs after the fact
⍝   mosaicwindow - virtual reference window of a mosaic
⍝    - xll, yll, nrow, ncol, cellsize for entire mosaic
⍝   connections for each pane
⍝*** NOTE: the previous version allowed several options that I dropped as part of the TIFF revolution, as I'm not 
⍝          using them. The only questionable one was the ability to use '' for gridservers.txt to allow local use
⍝          of mosaics. Ethan is keeping this, but I dropped it. It's in the old forked code (CAPS_pre-tiff_fork.w3)
⍝          but would take some work to catch it up.
⍝Sample call:
⍝   MOSAICINIT 'd:\caps\mosaics\land' 'gridservers.txt'
⍝B. Compton, 6 and 12 and 30 Sep 2013
⍝8 Oct 2013: deal with drives
⍝15 Oct 2013: count panes properly.  Government still shut down, debt ceiling hit this week?
⍝1 Nov 2013: use MOSAICINFO instead of cowboying it; only include grid servers with windows that match panes in our mosaic
⍝14-15 Nov 2013: revise for mosaics + drives
⍝19 Nov 2013: use GETTABLE
⍝16 Dec 2013: use MOSAICINFO
⍝3 Feb 2015: work properly when there is more than one grid server for a window
⍝3-4 Aug 2017: oh boy...this totally didn't work when using grid servers on multiple machines (banding at Fort River this morning...22 GRCAs) + drop inactive servers!
⍝9 Nov 2021: drop ability to take a reference grid; ability to take vector of servernames, ports, etc.; rowsize, colsize, etc.; include refgrid in connections (part of TIFF revolution)
⍝11 Nov 2021: drop entries in gridservers.txt that don't match global tiff setting (part of TIFF revolution)
⍝12 Oct 2022: add compression field for compatability



 ⍎(1=≡M)/'M←M '''''
 M G ← M                                    ⍝Reference mosaic and grid server info

 O←⍳0
 :if 0≠⎕NC 'mosaic'                         ⍝If there's already a mosaic,
 :andif ~0∊⍴mosaic
    O ← mosaic mosaicwindow                 ⍝   save it
 :end

 Q←'rowsize colsize rows cols panes lastrowsize lastcolsize panemap compression'
 mosaic←(⍴mosaic_←FRDBL¨↓MATRIFY Q)⍴0       ⍝set up mosaic and header

 Q Q_ ← MOSAICINFO M                        ⍝Get lock and read reference mosaic info
 mosaic[mosaic_ COL 'rowsize colsize rows cols panemap compression'] ← Q[Q_ COL 'rowsize colsize rows cols panemap compression']
 W←⊃Q[Q_ COL 'extent']

 mosaic[mosaic_ COL 'lastrowsize lastcolsize'] ← 1+mosaic[mosaic_ COL 'rowsize colsize']∣¯1+W[2 1]
 mosaic[mosaic_ COL 'panes']←×/mosaic[mosaic_ COL 'rows cols']

 mosaicwindow←5↑W
 INITCONNECTIONS                            ⍝create connection variables if they don't exist
 :if 0∊⍴referencewindow                     ⍝If reference window isn't set, set it
    referencewindow←mosaicwindow
    workingresolution←mosaicwindow[5]
 :end

 :if ~0∊⍴O                                  ⍝If a mosaic already exists,
 :andif ~O≡mosaic mosaicwindow              ⍝   check to see if new mosiac matches old one
    ⎕ERROR 'Error: Prior mosaic doesn''t match new mosaic'   ⍝      this used to be a warning
 :end

 :if ~1⊃Q←CHECKWINDOW mosaicwindow 1        ⍝Check against existing window
    T←⎕EX 'mosaic'
    ⎕ERROR 'Virtual mosaic window doesn''t match existing windows: ',2⊃Q
 :end

⍝Now add gridsevers for each pane to connections
 :if 0∊⍴G                                   ⍝If gridservers list is empty,
    L←1                                     ⍝   use local grid server
    U←V←D←Y←R←⊂''
 :else                                      ⍝else, it's a path to gridservers.txt
    S S_ ← GETTABLE pathA PATH G            ⍝   read gridservers.txt
    S←(S[;S_ COL 'active']^S[;S_ COL 'tiff']=tiff)⌿S       ⍝   drop the inactive servers and those for the other grid type (grid vs tiff)
    U V ← ↓[1]S[;S_ COL 'server port']      ⍝   servers, ports,
    D←S[;S_ COL 'drive']                    ⍝   drives,
    Y←S[;S_ COL 'ncol nrow xll yll cellsize']  ⍝   windows,
    R←S[;S_ COL 'refgrid']                  ⍝   and reference grids
    L←0                                     ⍝   not local
 :end

 B←⎕FI((2×⍴T)⍴1 0)\T←⊃mosaic[mosaic_ COL 'panemap']                         ⍝Expand panemap to bit vector
 W←1⊃¨(⊂mosaicwindow) PANEWINDOW¨B/(⊂mosaic[mosaic_ COL 'rowsize colsize']),¨(⍳mosaic[mosaic_ COL 'panes'])   ⍝Window for each pane with data
 J←⊃,/H←(⊂0,(↓Y),0,U,((V,[1.5]0),0),D) FINDCONNECTION¨(⊂¨W),¨1              ⍝We only want grid servers that match panes in our mosaics
 Y←Y[J;] ⋄ U←U[J] ⋄ V←V[J] ⋄ D←D[J] ⋄ R←R[J]                                ⍝Expand these out when multiple servers per pane

 :if L                                                                      ⍝If local grid server,
    U←V←D←⊂''
 :end

 C←(0,(↓Y),L,U,V,[1.5]serverlog),((⊃,/⍴¨H)/B/⍳mosaic[mosaic_ COL 'panes']),D,[1.5]R  ⍝Data for connections

 I←(FRDBL¨↓MATRIFY 'set window local server port log pane drive refgrid')⍳connections_         ⍝Index columns of connections
 connections←connections⍪C[;I]                                              ⍝Add to connections

 connections[;connections_ COL 'drive']←TOLOWER¨connections[;connections_ COL 'drive']  ⍝Make sure drives are all in same case!
 Q←↓connections[;connections_ COL 'window drive']
 connections←((Q⍳Q)=⍳⍴Q)⌿connections                                        ⍝Drop duplicates from connections

 SETCONNECTION (↓connections[;connections_ COL 'window drive'])⍳⊂C[?''⍴1↑⍴C;connections_ COL 'window drive']  ⍝Set active connection to a random pane in mosaic
 SETCACHE 1
 ACTIVATECONNECTION