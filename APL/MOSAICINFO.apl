Z←H MOSAICINFO M;T;∆set;N;name;type;timestamp;source;sourcetimestamp;extent;rowsize;colsize;rows;cols;panemap;compression;Q;X;L;I
⍝Return (info) (header) from mosaic ⍵ if it exists, otherwise (⍳0) (⍳0)
⍝Gets a lock and returns it unless ⍺[1]
⍝If ⍺[2], suppress local gridinfo caching
⍝B. Compton, 7 Oct 2013, from PANEMAP
⍝16 Dec 2013: get a lock; check for mosaic and return ⍳0 if it doesn't exist
⍝28 Jan 2014: return not found for empty mosaic!
⍝28 Apr 2014: add local gridinfo caching; ⍺[2] now suppresses this
⍝21 Nov 2014: lowercase names in gridinfo
⍝12 Oct 2022: add compression field for compatability



 ⍎(0=⎕NC'H')/'H←0'
 H←2↑H
 Z←2⍴⊂⍳0
 →(0∊⍴M)/0

 N←'name type timestamp source sourcetimestamp extent rowsize colsize rows cols panemap compression'
 compression←'no'                                ⍝For backward compatability
 :if (~H[2])^~0≡Z←⊃(gridinfo[;3],0)[gridinfo[;1]⍳⊂TOLOWER M]  ⍝If grid is in local gridinfo cache and caching isn't suppressed,
    Z←Z ((1+0∊⍴Z)⊃(MATRIFY N) (⍳0))                   ⍝    return info (header only if info is non-empty)
    →0
 :end

 :if ~H[1]
    L←LOCKFILE M                                ⍝Get a lock
 :end
 :if IFEXISTS Q←(FRDBL M),'\mosaicdescrip.txt'  ⍝if the mosaic exists,
    X←NREAD Q                                   ⍝   read info
    :if ~H[1]
       UNLOCKFILE L                             ⍝   return the lock
    :end
    SETPARS X                                   ⍝   get variables
    Z←(⍎N) (MATRIFY N)                          ⍝   and return them
    T←⎕EX ∆set                                  ⍝   Clear variables we set (they should all be local)
 :else                                          ⍝else, it doesn't exist,
    :if ~H[1]
       UNLOCKFILE L                             ⍝   return the lock
    :end
    Z←2⍴⊂⍳0                                     ⍝   and empty vectors
 :end

 I←gridinfo[;1]⍳⊂TOLOWER M                              ⍝Save info in local gridinfo cache
 :if I>1↑⍴gridinfo
    gridinfo←gridinfo⍪(TOLOWER M) 0 0
 :end
 gridinfo[I;3]←Z[1]