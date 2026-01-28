Z←W MEAN X;B
⍝Give mean across matrices in ⍵, weighted by ⍺
⍝2 Jun 2021: return scalar when taking mean of a vector or matrix
⍝12 Jul 2021: handled MVs wrong for vectors and matrices



 ⍎(0=⎕NC'W')/'W←1'
 →(1<≡X)/L1          ⍝If just a vector or matrix, give weighted mean of all values
 B←,~X∊MV
 Z←(W←B/,W)/X←B/,X
 Z←''⍴(+/Z)÷(⍴Z)
 →0
 
L1:Z←W/MVREP¨,X
 Z←X REMV ⊃(+/Z)÷⍴Z  ⍝Else, give weighted mean across matrices