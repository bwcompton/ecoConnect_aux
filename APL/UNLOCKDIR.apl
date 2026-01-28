A UNLOCKDIR N
⍝Delete ⍵ lock files from pathA
⍝Global:
⍝   pathA   cluster path to lock
⍝B. Compton, 8-14 Apr 2011, from E. Plunkett, unlock.dir()


 ⍎(0=⎕NC'A')/'A←pathA'
 N←1↑(N=0)↓N,4+2                    ⍝Default # of lock files = n pauses + 1 + bonus file; okay to go too large here
 NDROP¨(⊂A),¨(⊂'lock'),¨⍕¨⌽⍳N
⍝ ⎕←'→ Returned the lock.' ⋄ FLUSH