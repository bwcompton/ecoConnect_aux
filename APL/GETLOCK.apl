Z←A GETLOCK P;R;R;P;T;M;Q;E;L;err;O
⍝Lock cluster run for thread/requestor, timeout, priority, and message ⍵, key ⍺ (default = pathA)
⍝This function "locks" a directory (or arbitrary key) using Edi's lock server
⍝(if lockserver=1) or old file-based LOCKDIR (if lockserver=0).
⍝Arguments:
⍝   ⍵[1] = thread       id of the current thread / requestor name (0 = use 'thread' if it exists, otherwise 0)
⍝   ⍵[2] = timeout      time in seconds beyond which it assumes a collision has occured and resets the locks
⍝                       if 0, than never reset; default = 3600 (1 hour)
⍝   ⍵[3] = priority     lock priority (default = 5)
⍝   ⍵[4] = message      message for lock server & log
⍝Globals:
⍝   pathA               default cluster path; used if not passed in ⍺
⍝   name                computer name
⍝   locktimeout         how long until a lock (not a project) times out? (default = 1800)
⍝   uselockserver       use lock server (default = 1)
⍝Result:
⍝   wait time           total wait time (seconds)
⍝   lockwait            add wait time to global variable lockwait
⍝B. Compton, 12 Feb 2013, from LOCKDIR and previous version of GETLOCK (11-16 Jan 2013)
⍝12 Mar 2013: include timeout
⍝6 May 2013: if unknown error from lock server, try reinitializing
⍝23 Jul 2013: wait lockpause sec to hopefully prevent file system collisions
⍝13 Aug 2013: if lock server times out, display a message and try again
⍝15 Nov 2013: thread of 0 defaults to thread if it's set; 15 Dec: do it right
⍝9 Dec 2013: exit if ~cluster
⍝13 Jan 2014: work if locktimeout doesn't exist yet
⍝17 Apr 2014: add wait time to global lockwait
⍝6 Jun 2016: 'clear Lock server timed out' message on recovery



 :if (0≠⎕NC 'cluster')              ⍝If cluster exists, exit if ~cluster
    →(~cluster)/Z←0
 :end


 ⍎(0=⎕NC'A')/'A←pathA'
 L←1800 ⋄ ⍎(0≠⎕NC'locktimeout')/'L←locktimeout'
 R T P M ← 4↑P,(⍴,P)↓0,L,5 ''               ⍝Requestor, timeout, priority, message
 ⍎((R≡0)^0≠⎕NC'thread')/'R←thread'          ⍝Default to current thread if thread = 0
 E←1                                        ⍝Reinitializaiton flag
 ⍎(0=⎕NC'uselockserver')/'uselockserver←1'
 →uselockserver/L1                          ⍝If uselockserver = 0,
 Z←A LOCKDIR R T                            ⍝   call old file-based locker
 →0                                         ⍝Else,

L1:⍎((0≠⎕NC'computername')^0=1↑0⍴R)/'R←computername,''.'',⍕R'⍝   default requestor
 ⍎(0∊⍴M)/'M←1↓FIRSTCOL STRIP ⎕WSID'         ⍝   default message
 M←M,' (APL)'                               ⍝   append (APL) to message

 →(3=⎕NC'GETLOCKc')/L2                      ⍝   If not loaded,
 Q←⎕EX 'GETLOCKc'
 ⎕ERROR REPORTC 'DLL I4←LOCK_LIB.request_lock(*C1,*C1,*C1,I4,I4)' ⎕NA 'GETLOCKc'

L2:Q←⎕AI[2]
 O←0
L3:⍝⎕←'[Locking ',A,' from ',R,'] - (',(FRDBL⍕FRDBL¨(¯1+(↓⎕SI)⍳¨'[')↑¨↓⎕SI),')' ⋄ FLUSH
 ⍝⎕←'[Locking ',A,' from ',R,', priority ',(⍕P),']' ⋄ FLUSH
 err←GETLOCKc ((FRDBL A) (⍕R) M,¨⎕TCNUL),P T⍝   get a lock from Edi's lock server
 :if err=3
    ⎕←'*** Lock server timed out (',NOW,'). Trying again...' ⋄ FLUSH
    O←1
    →L3
 :endif

 :if E^err=2                                ⍝   if unknown error,
    lockport LOCKINIT lockserver            ⍝      reinitialize
    E←0                                     ⍝      only do this once
    →L2
 :end

 ⎕ERROR REPORTC err

 :if O
    ⎕←'Lock server recovered (',NOW,').' ⋄ FLUSH
 :end

 T←⎕DL lockpause
 ⍎(0=⎕NC'lockwait')/'lockwait←0'
 lockwait←lockwait+Z←⎕AI[2]-Q               ⍝   return lock wait time and update global lockwait