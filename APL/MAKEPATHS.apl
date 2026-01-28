Z←Z MAKEPATHS D;⎕ELX;I;K;E
⍝Make paths ⍵; return error message if failure


 ⍎(0=⎕NC'Z')/'Z←'''''
 ⍎(1≥≡D)/'D←⊂D'
 D←,D
 ⎕ELX←'→L2'
 K←1
 E←I←0
L1:→((⍴D)<I←I+1)/L9
 MAKEDIR I⊃D
 Z←Z OVER (K/'~'),'Note | Created directories ',I⊃D
 →L1

L2:Z←Z OVER (K/'~'),'Error | Can''t create directory ',I⊃D
 E←1
 K←0
 →L1

L9:Z←Z E