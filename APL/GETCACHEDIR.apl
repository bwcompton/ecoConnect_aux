Z←L GETCACHEDIR G;C;P;maxsize;minfree;head;T;cachepath;Q;A;nbins;deletesize
⍝Get a lock and fetch the grid caching directory for grid or index number ⍵.  Release lock if ⍺.
⍝Must call GETCACHECONFIG 1st
⍝Results:
⍝   Z[1]   (cache directory) (header)
⍝   Z[2]   1 if holding lock
⍝   Z[3]   UNLOCKFILE parameters (only returned if ⍵ = 0)
⍝   Z[4]   timer for cachewait
⍝B. Compton, 12 Sep 2013
⍝30 Sep 2013: lock computer name + path to prevent collisions
⍝1 Oct 2013: convert maxsize and minfree to MB; add computer name to cache path
⍝6 Feb 2014: if keeping lock, return RETURNLOCK parameters
⍝Jul 2014: use <computer> cache as the lock name
⍝21 Nov 2014: add cachewait
⍝16 May 2016: add nbins and deletesize for new hashed caching; code moved to GETCACHECONFIG; now find correct individual index
⍝17 May 2016: also take index number as an argument
⍝19 May 2016: don't call GETCACHECONFIG--this happens earlier



 ⍎(0=⎕NC'L')/'L←1'
 A←⎕AI[2]                                   ⍝Start cachewait timer
 P←GETCACHEPATH G
 Q←LOCKFILE GETNAME,' ',P                   ⍝Lock (computer name) 'cache'
 Z←(GETTABLE P) 0                           ⍝Read grid cache diretory
 :if ~Z[2]←~L                               ⍝If return lock,
    UNLOCKFILE Q
    CACHEWAIT A
 :else                                      ⍝Else
    Z←Z,Q A                                 ⍝   Lock is held and ⎕ELX is set to release it. These are UNLOCKFILE pars and cachewait timer
 :end