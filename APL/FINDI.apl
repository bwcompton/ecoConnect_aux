Z←A FINDI B
⍝Find row(s) ⍵ in table ⍺; return index
⍝B. Compton, 19 Apr 2011


 A←(2↑(⍴A),1 1)⍴A       ⍝If A is a vector, treat it as a single column
 Z←((Z≤1↑⍴A)×Z←(A FIND B))/⍳1↑⍴A