Z←SA_PROB E
⍝Subroutine of SA, gives probability of transition from energy ⍵[1] to ⍵[2],
⍝given temperature ⍵[3]
⍝Original Kirkpatrick et al. formulation


 Z←1
 →(E[2]<E[1])/0      ⍝If ⍵[2] is better, change state
 Z←0
 →(E[3]<⎕CT)/0       ⍝If temperature ~= 0, don't change to worse ⍵[2]
 Z←*(-/E[1 2])÷E[3]  ⍝P(change)