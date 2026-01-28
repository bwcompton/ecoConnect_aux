Z←P GRIDNAME N;G;head;K;T;Q;tablepath;S;Y;O
⍝Return name of grid ⍵ from inputs.par; prepend path if 1⊃⍺; use replacement file 2⊃⍺.par (default = inputs.par; use '' to not replace)
⍝Simply return ⍵ if ⍺[1]=¯1
⍝Give mosaic out-of-date error if ⍺[1]=¯2
⍝Replace #'s with timestep (##, ###, and #### indicate number of digits; # indicates no zero padding)
⍝Replace % with year (same deal as #'s), and [scenario] with scenario
⍝Can supply alternate grid names in inputs.par for time step 0, ≥1
⍝B. Compton, 25 Feb 2009
⍝3 Nov 2011: strip path when looking up grids
⍝9 Dec 2011: substitute time steps; 4 Jan 2012: also do years and scenarios
⍝6 Jan 2012: separate inputs.par and results.par
⍝9 Apr 2012: use path instead of pathI if pathI doesn't exist, for compatability with Habit@; 12 Apr 2012: more on pathI/tablepath for TABLE
⍝5 Mar 2013: replace variables in brackets with values (instead of just [scenarios])
⍝13 Mar 2013: be robust to timestep and year not set
⍝2 Jan 2014: go to if-else structure
⍝9 Jan 2014: if no drive letter in inputs.par, get it from path; if usemosaics, substitute mosaic with suffix '_m' if it exists and isn't outdated
⍝28 Jan 2014: ?
⍝13 Feb 2014: if ⍺[1]=¯2, called from READ, so give error if _m mosaic is outdated
⍝20 Mar 2014: don't do _m mosaic substitution for results!
⍝10 Apr 2014: do a quick and dirty check right up front on _m substitution to make sure the thing isn't already a mosaic
⍝9 Sep 2014: use cached inputs.par and results.par
⍝12 Nov 2021: deal with geoTIFFs (part of TIFF revolution); 18 Nov 2021: use ISMOSAIC to keep from confounding Arc and TIFF mosaics without _m, _tm
⍝2 Dec 2021: don't append .tif to result mosaics; do append _tm to result mosaics
⍝7 Jul 2022: simplify writing non-mosaic TIFFs: always append .tif! -- NO!  it appends .tif to new mosaics, so I get x.tif_tm. Undone.
⍝8 Jul 2022: use ⍺[2]='' to prevent name replacement from inputs.par or results.par
⍝2 Aug 2022: disentangle convoluted andifs
⍝31 Aug 2022: try appending .tif again, but only if it's not a mosaic and not a result... 6 Sep 2022: but only if landscapewide!
⍝13 Nov 2023: append .tif to landscapewide, even if result. Was failing to add .tif for Mass CAPS. Affected BACKKILL



 ⍎(0=⎕NC'P')/'P←0'

 :if 2≤≡N                               ⍝If argument is nested,
    Z←(⊂P) GRIDNAME¨N                   ⍝   recurse
    →0
 :end

 ⍎(2>≡P)/'P←P 0'
 ⍎((S←0)≠⎕NC'timestep')/'S←timestep'
 ⍎((Y←0)≠⎕NC'year')/'Y←year'
 Z←N ⋄ →((0∊⍴N)∨P[1]=¯1)/0              ⍝Bail if ⍺[1]=¯1
 P[1]←P[1]×~O←P[1]≡¯2                   ⍝Set out-of-date error flag and clear P[1]
 P[2]←(P[2]) (⊂inputspar)[1+0≡2⊃P]

 Z←TOLOWER N
 :if 0≠⎕NC 'pathI'                      ⍝If pathI doesn't exist, use path
    Q←pathI
 :else
    Q←path
 :end

 :if (T←inputspar resultspar⍳P[2])∊⍳2   ⍝If reading from inputs.par or results.par,
 :andif 0≠⎕NC T←T⊃'inputsP' 'resultsP'  ⍝   and it's already cached,
    G←⍎T                                ⍝   use it
 :elseif IFEXISTS (tablepath←Q) PATH (2⊃P),'.par'
    G←1 0 TABLE 2⊃P
 :end

 :if 0≠⎕NC'G'
    :if ~G≡1 1⍴⊂''                      ⍝If inputs.par exists,
       G[;2]←(FRDBL¨T\(T←⊃,/('\'=1↑¨LJUST¨G[;2])^0=⍴¨STRIPDRIVE¨G[;2])/(1↑⍴G)⍴⊂STRIPDRIVE path),¨G[;2]  ⍝If no drive letter, get it from path
       Z←⊃(G[;2],⊂Z)[(TOLOWER¨G[;1])⍳⊂FRDBL STRIP Z]  ⍝   get alternate grid name

       :if '|'∊Z                        ⍝If alternate grid names supplied,
          Z←FRDBL¨↓'|' MATRIFY Z        ⍝   first is time step 0, second is time step 1, ..., last is time step ≥ alternatives supplied
          Z←((⍴Z)⌊S+1)⊃Z
       :end
    :end
 :end

 :if '#'∊Z                              ⍝If time steps,
    K←⊃,/'.',¨'####' '###' '##' '#',¨'.',¨(,¨('ZI4' 'ZI3' 'ZI2') ⎕FMT¨S),⊂⍕S
    Z←K TEXTREPL Z                      ⍝   Insert time steps
 :end
 :if '%'∊Z                              ⍝If years,
    K←⊃,/'.',¨'%%%%' '%%%' '%%' '%',¨'.',¨(,¨('ZI4' 'ZI3' 'ZI2') ⎕FMT¨(10*4 3 2)×T-⌊T←Y÷10*4 3 2 ),⊂⍕Y
    Z←K TEXTREPL Z                      ⍝   Insert years
 :end
 :if '['∊Z                              ⍝If variables in brackets,
    Z←⍎'''',('.[.'',(⍕.].),''' TEXTREPL Z),''''    ⍝   replace with values
 :end
 :if ~(0∊⍴Z)∨~1⊃P                       ⍝If prepending path (only if grid has a name!)
    Z←pathG PATH Z
 :end
 →(0∊⍴Z)/0

⍝⎕←'***** GRIDNAME: ',N,' → ',Z,' *****' ⋄ FLUSH

 :if tiff                                       ⍝If we're using geoTIFFs,
    :if mosaics^substmosaics                    ⍝   If mosaics and substituting mosaics,
       :if '_m'≡TOLOWER ¯2↑STRIP Z              ⍝      if name ends in _m, change it to _tm
          Z←(STRIPPATH Z),(¯2↓STRIP Z),'_tm',((0≠⍴T)/'.'),T←STRIPEXT Z
       :end
       :if ~resultspar≡2⊃P                      ⍝   if this is not a result,
       :andif ~ISMOSAIC Z                       ⍝   and it's not a mosaic,
       :andif 0≠⍴⊃MOSAICINFO Q←(FRDBL Z),'_tm'  ⍝   and a '_tm' mosaic exists in same directory,
          :if 2≠FRISKMOSAICS ⊂Q                 ⍝      if the source isn't out of date,
             Z←Q                                ⍝         use the mosaic
          :elseif O                             ⍝         but if source is out of date and called from READ,
             ⎕ERROR 'Error: mosaic out-of-date with respect to source grid: ',Q
          :end
       :end
    :end
    
    :if landscapewide^0=⍴⊃MOSAICINFO Z          ⍝   if we're doing landscapewide and this is not a mosaic,   
⍝    :andif ~resultspar≡2⊃P                      ⍝   and if this is not a result,     WHY WAS THIS HERE? IT BROKE IMPLIED .TIF RESULTS IN MASS CAPS
       Z←Z,(~'tif'≡STRIPEXT Z)/'.tif'           ⍝      append .tif extension if it's not already there
    :end
    
    :if mosaics^substmosaics                    ⍝   if we're writing mosaics,
    :andif 0=⍴⊃MOSAICINFO Z                     ⍝   but this one doesn't exist yet,
    :andif resultspar≡2⊃P                       ⍝   and is a result,
    :andif ~(¯3↑STRIP Z)≡'_tm'                  ⍝   and doesn't already end in _tm
       Z←Z,'_tm'                                ⍝      append _tm to the name
    :end

 :else                                          ⍝Else, they're Arc grids,
    :if mosaics^substmosaics^~resultspar≡2⊃P    ⍝If mosaics and substituting mosaics (but not for results!),
    :andif ~ISMOSAIC Z                          ⍝   and it's not a mosaic,
    :andif 0≠⍴⊃MOSAICINFO Q←(FRDBL Z),'_m'      ⍝   and a '_m' mosaic exists in same directory,
       :if 2≠FRISKMOSAICS ⊂Q                    ⍝   and the source isn't out of date,
          Z←Q                                   ⍝      use the mosaic
       :elseif O                                ⍝      but if source is out of date and called from READ,
          ⎕ERROR 'Error: mosaic out-of-date with respect to source grid: ',Q
       :end
    :end
 :end