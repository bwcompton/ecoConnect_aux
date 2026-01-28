Z←TEXTIFYGI X;Q
⍝Format grid info vector ⍵ so it's ready to write to a file, read back in, and ⍎
⍝B. Compton, 29 Apr 2014



 →(0∊⍴⍴Z←X)/0
 Z←'(',(DEB ⍕FMTALL X),')'