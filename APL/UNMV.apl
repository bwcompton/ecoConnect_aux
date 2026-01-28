Z←V UNMV A
⍝Set all MV in ⍵ to 0, or to ⍺ if supplied

 ⍎(0=⎕NC'V')/'V←0'
 Z←(×/⍴A)⍴A
 Z[(Z∊MV)/⍳⍴Z]←V
 Z←(⍴A)⍴Z