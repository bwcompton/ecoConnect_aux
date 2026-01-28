Z←H RC F
⍝Return matrix ⍵ with row and column numbers or optional header vectors ⍺


 F←(¯2↑1 1,⍴F)⍴F
 ⍎(0=⎕NC'H')/'H←(⍳1↑⍴F) (⍳1↓⍴F)'
 Z←((⊂' '),1⊃H),(⍕¨2⊃H)⍪F

 Z←Z[1;]⍪' '⍪1 0↓Z
 Z←Z[;1],' ',0 1↓Z
 Z[2;]←'-'
 Z[;2]←'∣'
 Z[1 2;1 2]←' '
 Z←⍕¨Z