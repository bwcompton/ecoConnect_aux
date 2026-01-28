Z←P FRISKCACHE N;D;D_;B;L;R;head;X;Y;T;C;E;F;G;A;lock;I;J;V;H;Q;S;lock2;th;M;cachelogdetails;ch
⍝Frisk the local grid cache directory: free up ⍵ MB and clear hung copying attempts, missing grids, and spurius folders
⍝   ⍺[1] - deletecopies - TRUE if 'copying' grids should be deleted whether or not they're stale and unindexed grids should be deleted
⍝   ⍺[2] - getlock - if TRUE, gets a lock at start and release it when done
⍝Two primary uses:
⍝   1. At initial launch: called with freeup = 0, deletecopies = TRUE, getlock = TRUE (when no threads are running yet).
⍝      Deletes all grids that are not indexed, removes index entries that have no corresponding grid, and deletes grids/removes
⍝      entries for all grids that have status 'copying'.
⍝   2. From READBLOCKC, when space needs to be made to copy a grid: called with freeup = (default: deletesize), deletecopies = FALSE,
⍝      getlock = FALSE.  Does frisking as above, but only deletes 'copying' grids if they're more than 24 hours old.  Deletes
⍝      least-recently accessed grids in order to free up at least freeup GB.
⍝Returns 1 if success, 0 if couldn't free up ⍵ MB
⍝B. Compton, 10 Mar 2014
⍝18 Apr 2014: also delete any leftover crap in directory
⍝16 Jun 2014: add hours option and change so this can be run while threads are running + check for bad entries + optional delay
⍝Clearing missing grids was giving negative number of spurious folders to clear
⍝5 Feb 2015: exit if caching is turned off
⍝23 May-7 Jun 2016: COMPLETE REWRITE for new hashed caches
⍝6 Sep 2016: I had the default bit vector for grid deletion backwards (my well went dry yesterday; worst drought in decades)
⍝7 Sep 2016: add logging to Anthill log & fix bug in getting elapsed time on copying grids
⍝22 Aug 2017: check amount of free space after getting lock--another thread may have just frisked this cache, so maybe we don't need to do anything (my 1st D2R2 on Saturday; 66% solar eclipse on Monday)
⍝23 Aug 2017: oops
⍝5 Sep 2017: bail as unnecessary if ≥50% of requested is available, as we were still getting cascades
⍝16 Nov 2017: bug: deleted grids in 1st pass (expired, stale copying, missing or damaged) were not removed from master list, thus sizes were kept for cacheinfo.txt
⍝             and: if we determined in 2nd pass that we couldn't delete grids, we still excluded them from size count
⍝9 Feb 2018: add logging each deleted grid to try to catch vanishing grid bug
⍝12 Mar 2018: don't delete unindexed grids unless deletecopies is true. We were plagued for 3 months with a horrible bug that was caused by FRISKCACHE deleting
⍝             unindexed grids that were copying at the time--these don't have cache entries yet, as READBLOCKC doesn't know where they're going at that point.
⍝             So we'll only delete unindexed grids on startup.
⍝13 Jun 2018: bail out if caching is turned off
⍝15 Nov 2021: when checking for all parts of grid, do it for TIFFs too (part of TIFF revolution)



 cachelogdetails←1

 ⍎(0=⎕NC'P')/'P←0 1'
 P←2↑P,1
 ch←0

 ⍎((th←0)≠⎕NC'thread')/'th←thread'
 M←(1+N=0)⊃'FRISKCACHE is freeing up space in grid cache on ' 'FRISKCACHE is cleaning up grid cache on '
 (⎕←M,name) ANTLOG pathA 'anthill.log' (name←GETNAME) th '' 0 0

 GETCACHECONFIG ⋄ CONFIG
 →(0=1↑cache)/0                                     ⍝Bail if caching is off
 :if P[2]                                           ⍝If getlock,
    A←⎕AI[2]                                        ⍝      Start cachewait timer
    lock←LOCKFILE GETNAME,' cache'                  ⍝      Get a lock on cacheinfo
 :end

 S←(FILEINFO 2⊃cache)[3]                            ⍝Free space on cache drive
 Q←,0 MATIN F←(2⊃cache),'index\cacheinfo.txt'       ⍝Read cacheinfo
 :if (N≠0)^((S-cache[4])⌊cache[3]-Q[2])≥N×0.5       ⍝If trying to free space and our target has already been met: ((free-minfree)⌊maxsize-used)≥50% of requested (because another thread already frisked), we're done here
    Z←1                                             ⍝   return success
    (⎕←'FRISKCACHE is unnecessary--another thread just did it on ',name) ANTLOG pathA 'anthill.log' name th '' 0 0
    →L5
 :end

 :if tiff
    C←⊂'.tif'
 :else
    C←'\',¨FRDBL¨↓MATRIFY 'dblbnd.adf hdr.adf sta.adf w001001.adf w001001x.adf'
 :end
 L←12⍴0  ⍝Log vector: [1] date, [2] computer, [3] system (APL), [4] duration, [5] result, [6] missing, [7] expired, [8] copying,
         ⍝[9] unindexed, [10] purged, [11] GBcleaned, [12] GBfreed
 V←⎕AI[2]                                           ⍝Start timer for duration
 L[1 2 3]←NOW name 'APL'
 E←0 7⍴0

 ⎕←'FRISKING cache...' ⋄ FLUSH

 I←0
L1:→(cache[5]<I←I+1)/L4                             ⍝For each cache index,
  DOT
  D T lock2 A ← 0 GETCACHEDIR I                     ⍝   get cache directory   →→→ Holding lock; ⎕ELX will release it ←←←
  D D_ ← D
  B←(1↑⍴D)⍴1                                        ⍝   selection vector for index
  H←P[1]∨24≤((⊂TIMESTAMP) ELAPSED¨PARSEDATE¨D[;D_ COL 'cachedate'])÷60*2    ⍝   mark grids that are older than 24 hours; always true if deletecopies

  J←0
L2: →((1↑⍴D)<J←J+1)/L3                              ⍝   For each grid in cache,
      :if D[J;D_ COL 'status']≡⊂'expired'           ⍝      If grid is expired,
         ⎕←'   [FRISKCACHE is deleting expired grid ',(⊃D[J;2]),']' ⋄ FLUSH
         RDIR STRIPPATH ⊃D[J;2]                     ⍝         delete grid
         :if cachelogdetails
             head←1↓⎕TCHT MTOV MATRIFY 'date computer system cachepath sourcepath message'
             (NOW name 'APL',D[J;2 1],⊂'expired') LOCKWRITE pathA,'friskcachedetails.log'
             ch←1
         :end
         B[J]←0                                     ⍝         will clear it from index
         L[7]←L[7]+1                                ⍝         increment expired grid count
      :elseif H[J]^D[J;D_ COL 'status']≡⊂'copying'  ⍝      If grid is 'copying' and older than 24 hours or deletecopies,
         ⎕←'   [FRISKCACHE is deleting copying grid ',(⊃D[J;2]),']' ⋄ FLUSH
         :if cachelogdetails
             head←1↓⎕TCHT MTOV MATRIFY 'date computer system cachepath sourcepath message'
             (NOW name 'APL',D[J;2 1],⊂'copying') LOCKWRITE pathA,'friskcachedetails.log'
             ch←1
         :end
         RDIR STRIPPATH ⊃D[J;2]                     ⍝         delete grid (or fragments)
         B[J]←0                                     ⍝         will clear it from index
         L[8]←L[8]+1                                ⍝         increment copying grid count
      :elseif (~^/IFEXISTS¨D[J;D_ COL 'cache'],¨C)^D[J;D_ COL 'status']≡⊂'ready'    ⍝      If grid is 'ready' and missing or damaged, *** may want to use CHECKGRID, test = false, when I implement it
         ⎕←'   [FRISKCACHE is deleting missing or damaged grid ',(⊃D[J;2]),']' ⋄ FLUSH
         :if cachelogdetails
             head←1↓⎕TCHT MTOV MATRIFY 'date computer system cachepath sourcepath message'
             (NOW name 'APL',D[J;2 1],⊂'missing') LOCKWRITE pathA,'friskcachedetails.log'
             ch←1
         :end
         RDIR STRIPPATH ⊃D[J;2]                     ⍝         delete remains of grid if they exist
         B[J]←0                                     ⍝         will clear it from index
         L[6]←L[6]+1                                ⍝         increment missing grid count
      :end
      →L2

 L3:
      D←B⌿D                                         ⍝   drop deleted grids from index
      :if 0∊B                                       ⍝   If any changes to index,
         D D_ PUTCACHEDIR I                         ⍝      save new index with entries dropped
      :end
      E←E⍪D                                         ⍝   append to comprehensive index
      UNLOCKFILE lock2
      →L1

L4:⎕←'' ⋄ FLUSH
 :if P[1]                                           ⍝If deletecopies, look for unindexed grids
    X←⎕LIB 2⊃cache                                  ⍝   Now delete spurious grids that aren't in index...
    X←X[(⍳1↑⍴X)~X MATIOTA MATRIFY 'old_gridcache.txt index\';]      ⍝   Don't want extra junk
    X←¯1↓¨FRDBL¨↓(,'\'=(RJUST X)[;1↓⍴X])⌿X          ⍝   Folders in cache directory on disk
    Y←STRIP¨¯1↓¨STRIPPATH¨E[;D_ COL 'cache']        ⍝   Folders in gridcache.txt
    X←cache[2],¨(~X∊Y)/X                            ⍝   Spurious folders not in cache directory - we'll delete these
    L[9]←⍴X                                         ⍝   Number of unindexed grids deleted
    :if ~0∊⍴X
       ⎕←'   [FRISKCACHE is deleting unindexed grids:'
       ⎕←' ',' ',' ',' ',(⎕PW-4) TELPRINT ↑X
       :if cachelogdetails
          head←1↓⎕TCHT MTOV MATRIFY 'date computer system cachepath sourcepath message'
          T←↑(⊂NOW name 'APL'),¨(⊂¨X),¨(⊂⊂''),¨⊂⊂'unindexed'
          T LOCKWRITE pathA,'friskcachedetails.log'
          ch←1
       :end
       RDIR¨X                                       ⍝   Away they go
    :end
 :end

 L[11]←0⌈3 ROUND 0.001×(FILEINFO 2⊃cache)[3]-S      ⍝Amount of space freed up by cleaning (GB) -- don't report <0, as there may be interference

 B←0                                                ⍝Default: not deleting any!
 :if N>0                                            ⍝If need to free up space,
    B←(⊂'ready')≡¨E[;D_ COL 'status']               ⍝   Only 'ready' grids (not 'copying') can be deleted
    F←PARSEDATE¨¨↓¨'/' MATRIFY¨E[;D_ COL 'reads']   ⍝      Access dates
    B←B^B\1≤((⊂TIMESTAMP) ELAPSED¨⊃¨B/F)÷60*2             ⍝      Don't delete anything read in the past hour
    R←⍋↑MEAN¨B/F                                    ⍝      Sort mean read date, oldest to newest
    B←B\(1,¯1↓N>+\(B/E[;D_ COL 'size'])[R])[⍋R]     ⍝      These are the grids to delete from the cache
    L[12]←3 ROUND 0.001×T←+/B/E[;D_ COL 'size']     ⍝      Amount of space freed up by freeing (GB)
    :if Z←N≤T                                       ⍝      If we'll be able to clear enough (set success flag),
       Q←B/E[;D_ COL 'cache']                       ⍝         cached grids to delete
       G←1 GETCACHEPATH¨B/E[;D_ COL 'source']       ⍝         hashes of these grids
       L[10]←⍴Q                                     ⍝         number of grids purged to free up space
       ⎕←'   [FRISKCACHE is deleting cached grids ',(2↓⊃,/(⊂', '),¨Q),']'

       :if cachelogdetails
          head←1↓⎕TCHT MTOV MATRIFY 'date computer system cachepath sourcepath message'
          (↑(⊂NOW name 'APL'),¨↓(B⌿E[;2 1]),⊂'purged') LOCKWRITE pathA,'friskcachedetails.log'
          ch←ch∨1∊B
       :end

       Q←Q[T←⍋G]                                    ⍝         Sort grids to delete by hash so we can take advantage of multiple grids/index
       H←UNIQUE G
       :for I :in H                                 ⍝         For each affected cache index,
          D T lock2 A ← 0 GETCACHEDIR I             ⍝            get cache directory   →→→ Holding lock; ⎕ELX will release it ←←←
          D D_ ← D
          D←(~D[;D_ COL 'cache']∊Q)⌿D               ⍝            remove target grids from index
          D D_ PUTCACHEDIR I                        ⍝            write index
          UNLOCKFILE lock2
       :end
       RDIR¨STRIPPATH¨Q                             ⍝         Delete all of these grids
    :else
       B←0                                          ⍝       Else, we've failed to delete anything, so don't drop from size sum!
    :end
 :end


 Q←,0 MATIN F←(2⊃cache),'index\cacheinfo.txt'       ⍝Read cacheinfo
 Q[2]←+/(~B)/E[;D_ COL 'size']                      ⍝update total cache size of remaining grids
 ((⍕Q[1]),⎕TCNL,⍕Q[2]) NWRITE F                     ⍝and write cacheinfo

 L[4]←⊂TIME ⎕AI[2]-V
 Q←+/L[6 7 8 9]
 L[5]←'ok' ((⍕Q),' error',(Q≠1)/'s')[1+Q≠0]
 ⍎(0=⎕NC'cluster')/'cluster←1'
 head←1↓⎕TCHT MTOV MATRIFY 'date computer system duration result missing expired copying unindexed purged GBcleaned GBfreed'
 L LOCKWRITE pathA,'friskcache.log'

 ⎕←'FRISKCACHE results:'
 ⎕←(RJUST ⎕TCHT MATRIFY head),':',' ',MIX ⍕¨L       ⍝Print out report
 FLUSH

 :if cachelogdetails^~ch
    head←1↓⎕TCHT MTOV MATRIFY 'date computer system cachepath sourcepath message'
    (NOW name 'APL' '' '' 'nochange') LOCKWRITE pathA,'friskcachedetails.log'
 :end

 ⍎((th←0)≠⎕NC'thread')/'th←thread'
 ('FRISKCACHE is done on ',name) ANTLOG pathA 'anthill.log' name th '' 0 0


L5:
 :if P[2]                                           ⍝If getlock,
    UNLOCKFILE lock                                 ⍝   return cacheinfo lock
    CACHEWAIT A
 :end