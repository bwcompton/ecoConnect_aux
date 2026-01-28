Z←A ROWFINDa B;⎕IO;U;S;V;T;X;C;P;F;R
⍝∇inds←charmat ROWFINDa chararr -- Origin-1 indices of char rows in a char mat
⍝∇or 0 if not found
  ⎕IO←1 ⋄ S←1↑U←⍴A←(¯2↑ 1 1 ,⍴A)⍴A
  T←1↑V←⍴B←(¯2↑ 1 1 ,R←⍴B)⍴B
  X← 0 1 ×U⌈V ⋄ A←(X⌈U)↑A ⋄ B←(X⌈V)↑B
 →((S×T)>7×S+T)/L1 ⍝ If a small case, use inner-product algorithm
  Z←(⍳S)+.×<⍀A^.=⍉B ⋄ →L2
L1:A←B←0⍴C←A⍪B ⍝ Else use the sorting algorithm
  C←C[P←⎕AV⍋C;]
  F←∨/C≠¯1⊖C ⍝ First marks
  F[⍳×⍴F]←C←1 ⍝ Correct wraparound
  T←F/P ⋄ P[P]←+\F\T-¯1↓0,T
  P←S↓P
  Z←P×S≥P
L2:Z←((1<⍴R)/⍴Z)⍴Z ⍝ Return scalar if B vec