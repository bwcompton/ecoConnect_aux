Z←S GRIDDESCRIBE G;D;D_;I;Q;T;O;B;N;M;Q_
⍝Return info for named grid ⍵ - high-level version. Only return statistics if ⍺[1]; suppress errors if ⍺[2]; no local gridinfo caching if ⍺[3]
⍝Returns:
⍝   Z[⍳4]   cols, rows, xll, yll
⍝   Z[5]    cellsize
⍝   Z[6]    nodata
⍝   Z[7]    cell type (1 = integer, 2 = real)
⍝   Z[8-11] minimum value in grid, maximum, mean, and standard deviation
⍝   Z[12]   mosaic (1 if mosaic)
⍝B. Compton, 13 Sep 2013
⍝7 Oct 2013: add mosaic flag
⍝21 Oct 2013: protect against rare collisions using local grid server to do ∆GRIDDESCRIBE: try again a few times, then use remote grid server. Check caching date right.
⍝5 Nov 2013: localize stuff from GETPARS
⍝14 Nov 2013: use the correct remote gridserver if local ∆GRIDDESCRIBE fails
⍝8-9 Dec 2013: suppress caching if ⍺[3] or if global caching = 0
⍝15 Dec 2013: get a lock before reading mosaicdescrip.txt - otherwise, it sometimes isn't readable. 16 Dec: now it happens in MOSAICINFO
⍝28 Jan 2014: fix a handful of bugs (3) in mosaic stats; 28 Feb: and make sure pane names are short!
⍝24 Apr 2014: never get grid description from cache
⍝28 Apr 2014: add local gridinfo caching; ⍺[3] now suppresses this
⍝8 May 2014: always go to disk when getting stats (leaving for the Little J in a little while...)
⍝21 Nov 2014: lowercase names in gridinfo
⍝29 Sep 2021: change for TIFF gridservers - now ⍺[1] in ∆GRIDDESCRIBE is ⍺[2]
⍝4 Jan 2022: when collecting stats, base path depth on tiff
⍝23 Mar 2022: update grid stats in TIFF if we're asking for them



 ⍎(0=⎕NC'S')/'S←0 0 0'
 S←3↑S

 →((~S[1])^(~S[3])^~0≡Z←⊃(gridinfo[;2],0)[gridinfo[;1]⍳⊂TOLOWER G])/0       ⍝If grid is in local gridinfo cache and caching isn't suppressed and not asking for stats, return info

 Q Q_ ← (0,S[3]) MOSAICINFO G←FRDBL G
 :if ~0∊⍴Q                                                  ⍝If it's a mosaic,
    TRACK '   [GRIDDESCRIBE ',G,' from mosaic]'
    Z←(⊃Q[Q_ COL 'extent']),(4⍴MV),1
    :if S[1]
       Z[8 9]←(⌊/⍳0),⌈/⍳0                                   ⍝   if we want stats,
       B←⎕FI((2×⍴⊃Q[Q_ COL 'panemap'])⍴1 0)\⊃Q[Q_ COL 'panemap']
       N←FRDBL ((tiff×1E3)⌈13-D←1+⌊10⍟⍴B)↑⊃Q[Q_ COL 'name'] ⍝      Base name for panes
       M←'ZI',⍕D                                            ⍝      and number format
       :for I :in ⍳+/B                                      ⍝      For each pane,
          T←1 GRIDDESCRIBE G,((~tiff)/T),T←'\',N,(tiff/'_'),(,M ⎕FMT (B/⍳⍴B)[I]),tiff/'.tif'   ⍝         get grid description of pane
          Z[8]←Z[8]⌊T[8]                                    ⍝         take min and max
          Z[9]←Z[9]⌈T[9]
       :end
    :end
    →L9
 :end                                                       ⍝else,

 :if S[1]                                                   ⍝   if asking for grid stats, update them in TIFF
    UPDATE_GRIDSTATS G
 :end

 O←activeconnection                                         ⍝   Switch to local grid server
 SETCACHE 1
 SETCONNECTION O[1]
 ACTIVATECONNECTION
 TRACK '   [GRIDDESCRIBE ',G,' from local grid server]' 
 Z←0 1 ∆GRIDDESCRIBE G                                      ⍝   Describe grid, suppressing errors
 :if 0∊⍴Z                                                   ⍝   If an empty result, we may have a collision (even if errors should be suppressed),
    →(~0∊⍴Z←0 1 ∆GRIDDESCRIBE G)/L2                         ⍝      try again
    T←⎕DL 0.2                                               ⍝      then wait 0.2 sec and try again
    →(~0∊⍴Z←0 1 ∆GRIDDESCRIBE G)/L2
    T←⎕DL 1                                                 ⍝      now wait 1 sec and try again
    →(~0∊⍴Z←0 1 ∆GRIDDESCRIBE G)/L2

    SETCONNECTION FINDCONNECTION referencewindow (STRIPDRIVE G) ⍝      Total failure; must use remote server - activate the right grid server!
    SETCACHE 0
    ACTIVATECONNECTION
    TRACK '   [*** GRIDDESCRIBE ',G,' from remote grid server ***]'
    Z←(0,S[2]) ∆GRIDDESCRIBE G                              ⍝      do ∆GRIDDESCRIBE on the remove server, and throw an error if it fails
 :end

L2:SETCACHE O[2]                                            ⍝   and switch back
 ACTIVATECONNECTION
 :if ~O[3]∊0,MV
    SETCONNECTION O[3]
 :end
 :if ~O[4]∊0,MV
    SETCACHE O[4]
 :end

L9:I←gridinfo[;1]⍳⊂TOLOWER G                                ⍝Save info in local gridinfo cache
 :if I>1↑⍴gridinfo
    gridinfo←gridinfo⍪(TOLOWER G) 0 0
 :end
 gridinfo[I;2]←⊂Z