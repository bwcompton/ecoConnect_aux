Z←A LOCKDIR P;W;R;W;R;N;L;T;I;C;X;M;V
⍝Lock cluster run for thread, maxid, weight, and bonus ⍵ and directory ⍺ (default = pathA)
⍝This function "locks" a directory by creating a series of lock files.
⍝if those files already exist it assumes the directory is locked by someone else
⍝and waits for them to disapear.  Because it might be possible for multiple processes to
⍝create a file simulatiously each thread has a series of pauses that is unique to it.
⍝Global:
⍝   pathA   cluster path to lock
⍝Arguments:
⍝   ⍵[1] = thread       id of the current thread
⍝   ⍵[2] = timeout      time in seconds beyond which it assumes a collision has occured and resets the locks
⍝                       if 0, than never reset; default = 3600 (1 hour)
⍝   ⍵[3] = bonus lock   include one extra random lock for testing; default = 0
⍝   ⍵[4] = pause wait   wait between pauses; default = 0.1
⍝   ⍵[5] = n pauses     number of pauses between keys = (keys-1); default = 4
⍝   ⍵[6] = n threads    number of threads; default = threadlimit
⍝Globals:
⍝   pathA               default cluster path; used if not passed in ⍺
⍝   name                computer name
⍝Result:
⍝   wait time           total wait time (Seconds)
⍝   collision count     count of how many times the lock file existed when the prior lock file didn't
⍝   reset count         count of how many times it reset the locks (because of a timeout specified by maxwait)
⍝B. Compton, 8-11 Apr 2011, from E. Plunkett, lock.dir()
⍝11 Apr 2011: Drop unnecessary IFEXISTS calls
⍝14 Apr 2011: Add call to TIMEOUT, pass in path, change parameter order and defaults. 9 Jan 2014: delete TIMEOUT - we don't use it any more
⍝2 Jun 2011: Write computer.thread to lock files.  14 Jun 2011: also date.  20 Jul 2011: and 'APL'
⍝23 Aug 2011: Don't be so quick to give Waiting for lock message when sleeping
⍝1 May 2012: oh!  Recreate stuff to write to lock file within loop so it's not stale!
⍝12 Mar 2013: maxthreads → threadlimit (this function is deprecated)


 OBSOLETE VERSION


⍝⍞←'→ Getting a lock...' ⋄ FLUSH
 ⍎(0=⎕NC'A')/'A←pathA'
 ⍎(0=⎕NC'threadlimit')/'threadlimit←625'
 P←6↑P,(⍴,P)↓0 3600 0 .1 4,threadlimit           ⍝Defaults
 threadlimit←P[6]
 X←CALCPAUSES P[1 6 5 4]                        ⍝Get number of pauses
 W←R←0                                          ⍝Total wait time, count of resets
 N←(P[5]+⍴X)⍴0                                  ⍝Number of pauses (one more pause than lock), not counting bonus
 M←0
 ⍎(0=⎕NC'name')/'name←GETNAME'

L1:V←name,'.',(⍕P[1]),', ',NOW,' (APL)'         ⍝Computer name and thread, date and time, system
 →(V FILECREATE L←A,'lock1')/L3                 ⍝Create 1st lock file.  If we fail,
 ⍎(0=⎕NC'slept')/'slept←0'
 ⍞←(~M←~slept^W≥30)/'Waiting for lock (',L,')...',⎕TCNL ⋄ FLUSH     ⍝   Don't give this message until we've waited for at least 30 seconds
 slept←slept^M                                  ⍝   reset slept flag if we've displayed a message
 M←1
 →(~(P[2]≠0)^W>P[2])/L2                         ⍝   If we'll have waited longer than timeout,
⍝ R←R+A TIMEOUT (⊂name),P[1 2]                   ⍝      start timeout procedure to recover from file locking crash
 W←0                                            ⍝      and reset total wait time
 →L1                                            ⍝      dive back in without waiting
L2:W←W+⎕DL 0 3 UNIFORM 1                        ⍝   Now wait 0 to 3 seconds
 →L1

L3:I←C←0                                        ⍝Else, Reset collision flag
L4:→((⍴X)<I←I+1)/L5                             ⍝For each lock in sequence,
 T←⎕DL X[I]                                     ⍝   Wait for pause
 →(V FILECREATE L←A,'lock',⍕I+1)/L4             ⍝   Create lock file.  If successful, next
 N[I]←N[I]+C←1                                  ⍝   Else, collision
 →L1                                            ⍝      back to square one

L5:→(~P[3])/L6                                  ⍝If bonus lock
 T←⎕DL 0 3 UNIFORM 1                            ⍝   Sleep 0 to 3 seconds
 →(~V FILECREATE L←A,'lock',⍕2+⍴X)/L7           ⍝   Create bonus lock file.  If successful,
L6:Z←(ROUND W),N,R                              ⍝      return wait time, # of collisions, # of resets
⍝⎕←'got it.' ⋄ FLUSH
 →0                                             ⍝      and we're done
L7:N[1+⍴X]←N[1+⍴X]+C←1                          ⍝   Else, we have a collision
 →L1                                            ⍝      Back to square one