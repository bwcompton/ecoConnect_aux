E GRIDKILL G;Z;C;R;Q;err;A;B;firstfail;I;M;M_;N;P;T
⍝Kill grid(s) and mosaics ⍵.  Suppress grid not found error unless ⍺[1]; grid is guaranteed not to be a mosaic if ⍺[2]
⍝Uses the appropriate server to kill each grid so we don't get burned by cached data
⍝B. Compton, 8 Jan 2009; E. Ene, 19 Feb 2009
⍝5 Nov 2013: also kill mosaics
⍝13 Nov 2013: add grid server recovery
⍝14 Nov 2013: split from primitive ∆GRIDKILL and kill each grid with the appropriate server; 21 Nov: make robust to bad mosaics
⍝21 Nov 2014: remove killed grids from gridinfo
⍝16 Aug 2016: crashed if the same grid was listed twice
⍝9 Aug 2017: was passing gridname to FINDCONNECTION wrong...it wasn't using it correctly before, so I didn't realize it
⍝20 Nov 2023: work for TIFFs, so drop slashes in names (won't work for Arc Grids any more)



 ⍎(0=⎕NC'E')/'E←0'
 E←2↑E

 G←FRDBL¨↓MATRIFY G
 G←((G⍳G)=⍳⍴G)/G                                            ⍝Make sure grids are unique
 →(0∊⍴G←(IFEXISTS¨G)/G)/0                                   ⍝Skip grids that don't exist

 I←0
L1:→((⍴G)<I←I+1)/L2                                         ⍝For each grid or mosaic,
 :if 0=1⊃FILEINFO I⊃G                                       ⍝   if it's a folder without files,
    RDIR I⊃G                                                ⍝      delete it
    →L1
 :end
 :if Q←~E[2]                                                ⍝   if we're sure it's not a mosaic, suppress slow GRIDDESCRIBE call
    :Try
       Q←(GRIDDESCRIBE I⊃G)[12]
    :catch
       RDIR I⊃G
       →L1
    :end
 :end
 :if Q                                                      ⍝   if it's a mosaic,
    :Try
       M M_ ← MOSAICINFO I⊃G
    :catch
       RDIR I⊃G
       →L1
    :end
    P←N/⍳⍴N←⎕FI((2×⍴N)⍴1 0)\N←⊃M[M_ COL 'panemap']          ⍝   panes
    :if ~0∊⍴Q←PANEPATH¨(⊂(G[I])),¨(⊂M[M_ COL 'name']),¨P,¨⍴N⍝   if any panes exist,
       0 1 GRIDKILL ⊃,/' ',¨Q                               ⍝      kill individual panes
    :end
    RDIR I⊃G                                                ⍝      finally, remove folder, description, and empty subfolders with info folders
 :else                                                      ⍝   else, it's a grid
    :if 0≠C←FINDCONNECTION (5↑GRIDDESCRIBE I⊃G) (I⊃G)       ⍝      find connection; if found,
       SETCONNECTION C                                      ⍝         use this connection
    :end
    SETCACHE C=0                                            ⍝      else, use local grid server because no grid server is referencing it
    ACTIVATECONNECTION
    ∆GRIDKILL I⊃G                                           ⍝      kill the grid
 :end
 →L1

L2:gridinfo←(~(TOLOWER¨gridinfo[;1])∊TOLOWER¨G)⌿gridinfo    ⍝Remove killed grids from gridinfo