Z←FRISKMOSAICS X;I;T;Q;M;M_;S
⍝Frisk vector of mosaics ⍵ to make sure they're up-to-date with respect to source grids
⍝Result is a vector corresponding to ⍵, with
⍝   0 = mosaic is original, not derived (or has been manually reset)
⍝   1 = mosaic is derived and up-to-date
⍝   2 = mosaic is out-of-date
⍝   3 = mosaic is derived, but source no longer exists
⍝   9 = name is not a mosaic
⍝B. Compton, 6 Sep 2013
⍝16 Dec 2013: use MOSAICINFO so we get a lock
⍝13 Jan 2014: also check for non-mosaics
⍝8 Sep 2014: look only at sta.adf, the grid statistics file, instead of the whole grid directory, to keep from being burned by
⍝   changes to metadata.xml and prj.adf due to grid copies, etc. in ArcMap
⍝10 Sep 2014: grandfather old mosaic dates to noon today
⍝4 Nov 2014: grandfathering clause was backwards
⍝5 Nov 2014: no it wasn't, but change it for clarity
⍝13 Feb 2015: remove grandfathering, as we've fixed mosiacs at the source (snow, snow, snow! more on the way)
⍝15 Nov 2021: new mosaic type: derived_tif; check to see if grid or TIFF exists (part of TIFF revolution)
⍝14 Feb 2021: MOSAICINFO already has .tif in source, so don't add it in FILEINFO line
⍝17 May 2022: allow relative paths for source of derived mosaics: if source starts with .\, use mosaic path
⍝29 Jul 2022: when checking date of source grid, look for .tif or Arc grid based on source name, not current tiff setting



 Z←(⍴X←,X)⍴0
 I←0
L1:→((⍴X)<I←I+1)/0           ⍝For each mosaic,
 M M_ ← MOSAICINFO I⊃X
 :if 0=⍴M
    Z[I]←9
 :elseif (M[M_ COL 'type'])∊'derived' 'derived_tif'
    S←(T/STRIPPATH I⊃X),(2×T←'.\'≡2↑S)↓S←⊃M[M_ COL 'source']        ⍝If source starts with .\, use mosaic path     
    :if 0∊⍴Q←FILEINFO S,(~'.tif'≡TOLOWER ¯4↑RJUST S)/'\sta.adf'
       Z[I]←3
    :else
       Z[I]←(1+^/(PARSEDATE 2⊃Q)=PARSEDATE ⊃M[M_ COL 'sourcetimestamp'])⊃2 1
    :end
 :end
 →L1