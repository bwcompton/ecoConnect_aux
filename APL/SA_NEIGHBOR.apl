Z←A SA_NEIGHBOR X;I;K;Q;F;T;M;V
⍝Subroutine of SA, gives S' from ⍵ by moving ⍺ selected cells
⍝Use costs 2⊃⍺ to modify probability of moving cells

 A M←A
 K←(⍳1↑⍴X)∘.,⍳1↓⍴Z←X⍝Index
 I←0
L1:→(A<I←I+1)/0     ⍝For each cell to move,
 F←(1++/V≤(0, V[⍴V←+\(,Z)/,1-M]) UNIFORM 1)⊃Q←(,Z)⌿,K  ⍝   From, selected proportional to 1-score
 T←(?⍴Q)⊃Q←(,~Z)⌿,K ⍝   To
 Z[F[1];F[2]]←0 ⋄ Z[T[1];T[2]]←1
 →L1