Z←D ROUND X
⍝Cut off excess digits

 ⍎(0=⎕NC'D')/'D←2'
 Z←(⌊.5+X×10*D)÷10*D