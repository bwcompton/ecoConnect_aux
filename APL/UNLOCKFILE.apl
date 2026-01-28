UNLOCKFILE X;E;T
⍝Return lock for 1⊃⍵ and reset ⎕ELX to 2⊃⍵
⍝Paired with LOCKFILE, a simple cover for GETLOCK/RETURNLOCK that deals with ⎕ELX
⍝B. Compton, 31 Dec 2013



 →(0=⎕NC'cluster')/0
 →(~cluster)/0
 X E ← X
 T←⎕DL .1           ⍝Give OS a little time to release file
 RETURNLOCK X       ⍝return lock
 ⎕ELX←E             ⍝and reset ⎕ELX