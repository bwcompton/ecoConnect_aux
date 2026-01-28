Z←B SLASHEACH X;I
⍝Cover for ⍺/¨⍵, which doesn't work for some reason

 Z←(⍴X)⍴0
 I←0
L1:→((⍴X)<I←I+1)/0
 Z[I]←⊂(I⊃B)/I⊃X
 →L1