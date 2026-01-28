Z←E READBLOCK G;E;C;M;M_;L;R;K;T;I;P;Rx;Ry;Px;Py;ROL;Xr;Yr;O;H;V;Y;F;N;U
⍝Read block 1↓⍵ from grid 1⊃⍵, potentially using mosaics (and caching); optional griddescribe ⍺
⍝   ⍵[1]    grid path & name
⍝   ⍵[2 3]  starting row & column
⍝   ⍵[4 5]  nrows & ncols
⍝   ⍵[6]    buffer in cells (default = 0)
⍝   ⍵[7]    nocache - okay to cache grid? (default = 0)
⍝B. Compton, 7-10 Oct 2013
⍝1 Nov 2013: take optional grid describe
⍝14 Nov 2013: now use FINDCONNECTION, thanks to mosaics + drives



 :if 0≠⎕NC'noread'
    →noread/1↑⍴Z←0 0⍴''
 :end

 G ← 7↑G,0 0
 :if 0=⎕NC'E'                       ⍝If grid description wasn't passed,
    E←GRIDDESCRIBE 1⊃G              ⍝   Get info
 :end
 :if ~E[12]                                             ⍝If it's not a mosaic,
    ⎕ERROR (MV=C←FINDCONNECTION (5↑E) (1⊃G))/'Error: There is no connection for grid ',TOLOWER 1⊃G
    SETCONNECTION C                                     ⍝   Find & set the connection
    Z←E READBLOCKC G                                    ⍝   Read the block from a normal (possibly cached) grid
    →0
 :end                                                   ⍝Else, it's a mosaic,
 ⎕ERROR (0=⎕NC'mosaicwindow')/'Error: mosaics not initialized'
 ⎕ERROR (0=⍴mosaicwindow)/'Error: mosaics not initialized'
 ⎕ERROR (~(5↑E)≡mosaicwindow)/'Error: mosaic grid doesn''t conform to mosaic window'

 M M_ ← MOSAICINFO 1⊃G
 ⎕ERROR (∨/M[M_ COL 'rowsize colsize']≠mosaic[mosaic_ COL 'rowsize colsize'])/'Mosaic grid''s rowsize and colsize don''t match the scheme defined by MOSAICINIT'

 L←(E[3]+E[5]×G[3]-1),E[4]+E[5]×E[2]-G[4]+G[2]-1        ⍝Lower left corner (xll, yll) of block we're reading
 R←G[5 4],L,E[5]                                        ⍝Extent of result (ncol, nrow, xll, yll, cellsize)
 R[⍳4]←R[⍳4]+G[6]×2 2,2⍴-E[5]                           ⍝Expand by buffer
 Z←R[2 1]⍴MV                                            ⍝Result grid

 K←N/⍳⍴N←⎕FI((2×⍴N)⍴1 0)\N←⊃M[M_ COL 'panemap']
 T←⎕DEF 'Z←A ROL B' OVER 'Z←(A[1]⌈B[1])≤A[2]⌊B[2]'      ⍝Define range overlap function
 I←0
L1:→((⍴K)<I←I+1)/0                                      ⍝For each nonempty pane,
 P←⊃mosaicwindow PANEWINDOW mosaic[mosaic_ COL 'rowsize colsize'],K[I] ⍝   window of pane

 Rx Ry ← (R CELL2POINT R[2],1),¨R CELL2POINT 1,R[1]     ⍝   x & y ranges of result
 Px Py ← (P CELL2POINT P[2],1),¨P CELL2POINT 1,P[1]     ⍝   x & y ranges of pane

 →((~Rx ROL Px)∨~Ry ROL Py)/L1                          ⍝   If no overlap, skip tile

 Xr←(Rx[1]⌈Px[1]),Rx[2]⌊Px[2]                           ⍝   Range of overlaps
 Yr←(Ry[1]⌈Py[1]),Ry[2]⌊Py[2]

 O←(P POINT2CELL Xr[1],Yr[2]),P POINT2CELL Xr[2],Yr[1]  ⍝   Overlap of pane and result, in cells
 O←O[1 2],O[3 4]-O[1 2]-1                               ⍝   starting row, col, nrows, ncols

 SETCONNECTION FINDCONNECTION (-K[I]) (1⊃G)             ⍝   find and set matching connection

 H←⊂PANEPATH G[1],(⊂STRIP⊃M[M_ COL 'name']),K[I],⍴N     ⍝   Path to mosaic pane
 F←P,MV,E[7],4⍴MV                                       ⍝   Griddescribe of pane
 Y←F READBLOCKC H,O,0,G[7]                              ⍝   Read the block!

 U V ← ↓[1]2 2⍴⊃,/(⊂R) POINT2CELL¨(Xr[1],Yr[2]) (Xr[2],Yr[1])  ⍝   Row range, column range
 Z[U[1]+0,⍳-/⌽U;V[1]+0,⍳-/⌽V]←Y                         ⍝   Put our values into the result
 →L1