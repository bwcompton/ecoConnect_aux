S MAKEDIR D;P;T;Q
⍝Create new directory ⍵, creating parent directory if necessary. Get lock, but suppress locking if ⍺.
⍝B. Compton, 5 May 2011
⍝21 Nov 2013: check for collisions
⍝27 Mar 2014: do several tries in IFEXISTS before throwing an error
⍝31 Mar-1 Apr 2014: that didn't work. Use Ethan's approach of locking the containing directory
⍝2 Apr 2014: a different approach
⍝3 Apr 2014: and yet a different one...this might work (it does)
⍝4 Apr 2014: a new variation...hold the lock until the directory exists
⍝9 Mar 2022: oops: need to pass ⍺ when recursing!



 ⍎(0=⎕NC'S')/'S←0'
 D←(-'\'=¯1↑D)↓D←FRDBL D
 →(IFEXISTS D,'\')/0                        ⍝If directory already exists, exit
 :if ~IFEXISTS P←(-¯1+(⌽D)⍳'\')↓D           ⍝If parent directory doesn't exist,
    S MAKEDIR P                               ⍝   Create it, recursively
 :end

 :if ~S
    Q←LOCKFILE D,'\'                        ⍝   Lock the directory (unless suppressed)
 :end

 →(IFEXISTS D,'\')/L9                       ⍝   If it exists now, exit

 T←TRY '⎕MKDIR D'                           ⍝   Create directory
 →(60 WAITUNTILEXISTS D,'\')/L9             ⍝   Wait a whole minute for directory to be created before throwing error

 :if ~S
    UNLOCKFILE Q
 :end

⍝('Crash in MAKEDIR at ',((1+NOW⍳',')↓NOW),' (',(⍕?1E3),')') GETLOCK 0 ⋄ STOP                ⍝Temporary code to help with debugging ***

 ⎕ERROR 'MAKEDIR failed to create directory ',D,'\'

L9:→S/0
 UNLOCKFILE Q