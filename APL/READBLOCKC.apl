Z←E READBLOCKC GP;G;P;D;L;D_;T;I;V;H;Q;head;C;mingrids;W;⎕ELX;lock;A;S;cacheok;iscached;copying;F;ci;N
⍝Get block from grid 1⊃⍵, with optional grid description ⍺; potentially using caching
⍝   ⍵[1]    grid path & name
⍝   ⍵[2 3]  starting row & column
⍝   ⍵[4 5]  nrows & ncols
⍝   ⍵[6]    buffer in cells (default = 0)
⍝   ⍵[7]    nocache - okay to cache grid? (default = 0)
⍝Optionally passed grid description ⍺
⍝This version manages the local grid cache. Caching is initialized on each machine with CACHEINIT
⍝B. Compton, 16 Sep 2013
⍝30 Sep 2013: optionally passed grid description
⍝1 Oct 2013: finish this off, after a long hiatus on the Allagash
⍝21 Oct 2013: oops. Set sourcedate to the grid's modification date, not caching date.  Gay marriages in NJ today; Christie drops appeals.
⍝21 Nov 2013: format xll and yll to a whole lot of digits in cache directory; 25 Nov: and cellsize
⍝25 Nov 2013: call FILEINFO separately for grid and cache drive
⍝3 Dec 2013: save cached directory while we still have the lock; throw an error if it takes longer than 10 minutes for another thread to copy a grid to the cache
⍝9 Dec 2013: suppress caching if global caching = 0; 19 Dec: and, or, it's all the same...isn't it?
⍝6 Feb 2014: Deal properly with lock-releasing ⎕ELX from call to GETCACHEDIR; check here for multitiled grids so we don't copy them to the cache
⍝11 Mar 2014: unlock before ⎕ERROR, though error-handling should catch it anyway
⍝1 Apr 2014: tell MAKEDIR not to get a second lock on cache--we already have the right one
⍝1 May 2014: wait 30 min instead of 10 for grid to be copied by another thread
⍝28 Aug 2014: oops! was double-counting existing cache when figuring out whether to delete grids from cache.
⍝18 Nov 2014: oops! check for grid×10 being too big was wrong, turning off caching when cache was full!
⍝21 Nov 2014: add cachewait
⍝2 Dec 2014: Nov 18th change broke check for cached grid too big (Reva's funeral today)
⍝4 Dec 2014: redo cache size checking & grid deletion to give much-needed clarification (and test it)
⍝12 Aug 2015: I broke caching with a new directory on 18 Nov 2014, and finally found it when we replaced a bad drive!; 17 Aug 2015: oops
⍝19-20 May 2016: MAJOR REWRITE for hashed caches
⍝7 Jun 2016: throw error if FRISKCACHE fails--it's crazy to frisk for every read
⍝6 Sep 2016: When waiting for copy, re-find grid in index in case it moved...if it's no longer in the index, move on semi-gracefully
⍝31 Jan 2017: change 'wait' to 'cachetimeout' and add it to config.txt. Needs to be 60 min, because frisking takes up to 40 min
⍝26 Apr 2017: when waiting for a copying grid times out, instead of giving an error, initiate another copy (because KILL often leaves hanging copying entries)
⍝7 Nov 2017: call CHECKCACHEINFO to try to find cache discrepancy bug
⍝27 Nov 2017: was crashing if another process frisked away stuck copying grid
⍝1 Dec 2017: reread cacheinfo.txt after FRISKCACHE, dummy!
⍝5 Dec 2017: simplify if stuck copying grid is frisked away



 mingrids←10                               ⍝Minimum number of grids in cache (mingridcapacity)
 ⍎(0=⎕NC'cachetimeout')/'cachetimeout←60'  ⍝Number of minutes to wait for grid to be copied to cache by another thread before giving error...10 min was too short...30 was too
 G←TOLOWER 1⊃GP ⋄ P←6↑1↓GP
 :if 0≠⎕NC'noread'
    →noread/1↑⍴Z←0 0⍴''
 :end


⍝-----PART I: figure out caching, copy grid if necessary-----

 GETCACHECONFIG

 W←0 ⋄ N←'---) as cache-in-place'                   ⍝Wait count, for copying; tracking for cache-in-place
 :if cacheok←cache[1]^caching^~P[6]                 ⍝If caching is on and not suppressed for this grid,
    V←FILEINFO G,'\'                                ⍝   Get grid size & make sure it exists
    ⎕ERROR (0∊⍴V)/'Source grid ',G,' does not exist'
    →((⊂2↑2⊃cache) FIND ⊂2↑H←G)/L1                  ⍝   If grid is on same drive as cache, cache-in-place
    D L lock A ← 0 GETCACHEDIR G                    ⍝   Get cache directory   →→→ Holding lock; ⎕ELX will release it ←←←
    D D_ ← D                                        ⍝   grid cache directory & header

    :if iscached←0≠I←I←D D_ LOOKUP_GRID G           ⍝   If grid is in directory,
       :while (⊃D[I;D_ COL 'status'])≡'copying'     ⍝      While waiting for grid to be copied by another thread,
          CACHEWAIT A
          :if cachetimeout<T←(TIMESTAMP ELAPSED PARSEDATE ⊃D[I;D_ COL 'cachedate'])÷60      ⍝         Wait an hour (or whatever) for grid to copy
              iscached←0                            ⍝            if it times out, clear iscached and drop out of while...we'll copy the damn thing ourselves later
              :leave
⍝             ⎕ERROR 'Error: grid ',G,' cached on ',GETNAME,' has had ''copying'' status for ',(⍕⌊T),' minutes'
          :end                                      ⍝         else, wait for copy
          UNLOCKFILE lock                           ⍝         return lock
          :if 1=W←W+1
             ⎕←'--> Waiting for grid ',G,' to be copied to cache (',NOW,')...' ⋄ FLUSH
          :end
          T←⎕DL 120                                 ⍝         wait 2 minutes
          D L lock A ← 0 GETCACHEDIR G              ⍝         get cache directory   →→→ Holding lock; ⎕ELX will release it ←←←
          D D_ ← D                                  ⍝         grid cache directory & header
          I←D D_ LOOKUP_GRID G                      ⍝         re-find grid in directory--it may have moved if FRISKCACHE deleted grids
          :if I=0                                   ⍝         if the grid isn't in the directory,
             iscached←0                             ⍝            the copying thread must have given up...trigger the whole process again
             →L2                                    ⍝            skip ahead to dealing with uncached grid
          :end
       :end

       :if ~(PARSEDATE ⊃D[I;D_ COL 'sourcedate'])≡PARSEDATE 2⊃V     ⍝      If grid is stale,
          iscached←0
          D[I;D_ COL 'source status']←⊂'expired'    ⍝      Cached grid is out of date--we'll deleted it on next frisk
       :end
    :end

L2:
    :if ~iscached                                   ⍝   If grid isn't in cache,
       :if MULTITILE G                              ⍝      If multitiled grid,
          UNLOCKFILE lock                           ⍝         return lock & throw error
          CACHEWAIT A
          ⎕ERROR 'Error: grid ',G,' is a multitiled ESRI grid - it can''t be read'
       :end

       D←D⍪0                                        ⍝      add grid to index
       D[I←1↑⍴D;D_ COL 'source status size reads cachedate sourcedate']←G 'copying' (V[1]) '' NOW (2⊃V)
       D D_ PUTCACHEDIR G
       UNLOCKFILE lock                              ⍝      return cache index lock
       CACHEWAIT A

       A←⎕AI[2]                                     ⍝      Start cachewait timer
       lock←LOCKFILE GETNAME,' cache'               ⍝      Get a lock on cacheinfo
       copying←1



       ci←,0 MATIN F←(2⊃cache),'index\cacheinfo.txt'⍝      Read cacheinfo
       S←cache[3]⌊ci[2]+(FILEINFO 2⊃cache)[3]-cache[4] ⍝      Space available for cache (maxsize MIN used + free - minfree)
       :if (V[1]×mingrids)>S                        ⍝      If (grid×10) is too big to fit in empty cache
          TRACK '   [READBLOCKC: cache isn''t big enough to cache ',G,' ',NOW,']'
          copying←cacheok←0                         ⍝         suppress caching and read from gridserver
       :else                                        ⍝      else
          :if S<(V[1]+ci[2])                        ⍝         If we're requesting too much space ((grid size + cache size) > total available for cache),
             TRACK '   [READBLOCKC: calling FRISKCACHE to free up space for grid ',G,' ',NOW,']'
             :if ~0 0 FRISKCACHE V[1]⌈cache[6]      ⍝            FRISKCACHE to delete a bunch of grids and make space
                UNLOCKFILE lock                     ⍝            return cache index lock
                ⎕ERROR 'Cache is full and there is no way to free sufficient space without deleting grids that have been read recently. Probably your cache is too small to be useful.'                   ⍝            If FRISKCACHE fails, throw error
             :end
             ci←,0 MATIN F                          ⍝         Re-read cacheinfo, as FRISKCACHE will have changed it!
          :end
       :end





       :if copying                                  ⍝      If we're copying the grid (1st time),
          ci[1]←ci[1]+1                             ⍝         increment cache id
          ci[2]←ci[2]+V[1]                          ⍝         and update total cache size
          ((⍕ci[1]),⎕TCNL,⍕ci[2]) NWRITE F          ⍝         write cacheinfo
       :end

       UNLOCKFILE lock                              ⍝         return cache index lock
       CACHEWAIT A


       :if copying                                  ⍝      If we're copying the grid (2nd time),
          TRACK '   [READBLOCKC copying grid ',G,' to cache, ',NOW,']'
          SETCACHE 1                                ⍝         use local grid server to copy grid
          ACTIVATECONNECTION
          1 MAKEDIR C←(2⊃cache),(⍕ci[1]),'\'        ⍝         target to cached grid; make containing folder
          G GRIDCOPY C←C,STRIP G                    ⍝         copy grid to the cache
          TRACK '   [READBLOCKC has copied grid ',G,' to cache, ',NOW,']'
       :end

       D L lock A ← 0 GETCACHEDIR G                 ⍝      Get cache directory   →→→ Holding lock; ⎕ELX will release it ←←←
       D D_ ← D                                     ⍝      grid cache directory & header
       I←D D_ LOOKUP_GRID G                         ⍝      find grid in directory

       :if copying                                  ⍝      If we're copying the grid (3rd time),
          D[I;D_ COL 'cache status']←C 'ready'      ⍝         update cache location and status
       :else                                        ⍝      else,
          D←(I≠⍳1↑⍴D)⌿D                             ⍝         remove this grid from index
          D D_ PUTCACHEDIR G                        ⍝         write cache index




          UNLOCKFILE lock                           ⍝         return cache index lock
          CACHEWAIT A
       :end
    :end
 :end


 ⍝-----PART II: read block-----
 :if cacheok                                        ⍝If caching, read block from cache,
    Q←1↓'/' MTOV T[⍳5⌊1↑⍴T←NOW OVER '/' MATRIFY Q←⊃D[I;D_ COL 'reads'];]
    D[I;D_ COL 'reads']←⊂Q                          ⍝    Update access timestamps
    head←1↓⎕TCHT MTOV D_
⍝    D[;D_ COL 'xll yll cellsize']←FMTALL D[;D_ COL 'xll yll cellsize']    ⍝   Format xll, yll, and cellsize with a zillion digits
    H←⊃D[I;D_ COL 'cache']                          ⍝   Cached grid name
    N←(GETCACHEPATH G),') as cached version'        ⍝   (for tracking)
    D D_ PUTCACHEDIR G                              ⍝   Write directory
    UNLOCKFILE lock                                 ⍝   Unlock
    CACHEWAIT A

L1: SETCACHE 1                                      ⍝   Read from local grid server (entry for cache-in-place)
    ACTIVATECONNECTION
    TRACK '   [READBLOCKC reading ',G,', from ',H,' (index: ',N,']'
    :if 0=⎕NC 'E'                                   ⍝   Read from the grid (pass grid info if we already have it)
       Z←∆READBLOCK (⊂H),P
    :else
       Z←E ∆READBLOCK (⊂H),P
    :end
 :else                                              ⍝Else, read from grid server
    ⎕ERROR (MULTITILE G)/'Error: grid ',G,' is a multitiled ESRI grid - it can''t be read'
    SETCACHE 0                                      ⍝   turn off reading from local grid server
    ACTIVATECONNECTION
    TRACK '   [READBLOCKC reading ',G,', uncached]'
    Z←∆READBLOCK (⊂G),P                             ⍝   and read the block normally
 :end