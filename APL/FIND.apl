Z←A FIND B;I;X;Y
⍝Find row ⍵ in table ⍺; return bit vector
⍝B. Compton, 15 Apr 2011


 A←(2↑(⍴A),1 1)⍴A       ⍝If A is a vector, treat it as a single column
 ⍎(1≥≡B)/'B←⊂B'
 Z←(1↑⍴A)⍴1
 I←0
L1:→((1↓⍴A)<I←I+1)/0    ⍝For each column,
 ⍎(' '=1↑0⍴⊃X←A[;I])/'X←FRDBL¨TOLOWER¨X'
 ⍎(' '=1↑0⍴⊃Y←(,B)[I])/'Y←FRDBL¨TOLOWER¨Y'
 Z←Z^(⍕¨X)≡¨⍕¨Y
 →L1