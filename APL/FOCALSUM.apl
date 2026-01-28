Z←N FOCALSUM X;I;K
⍝Return 3×3 focal sum neighbor value of each cell
⍝Use ⍺-neighbor rule
⍝Uses global KK8

 ⍎(0=⎕NC'N')/'N←8'
 K←(N,2)↑KK8
 X←(-2+⍴X)↑(1+⍴X)↑X
 Z←0
 I←0
L1:→((1↑⍴K)<I←I+1)/L2
 Z←Z+(K[I;1]⌽K[I;2]⊖X)
 →L1
L2:Z←¯1 ¯1↓1 1↓Z