Z←TEXTIFYMI X;Q
⍝Add quotes around text in mosaic info vector ⍵ so it's ready to write to a file, read back in, and ⍎
⍝B. Compton, 28-29 Apr 2014



 →(0∊⍴Z←X)/0
 X[6]←⊂FMTALL⊃X[6]
 Q←1+(Q×2)+(0=Q←82=⎕DR¨X)^⊃,/⍴¨⍴¨X
 Z←DEB⍕' ('''[Q],¨(⍕¨X),¨' )'''[Q]