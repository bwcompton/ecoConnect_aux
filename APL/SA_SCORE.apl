Z←P SA_SCORE X;cost;cellsize
⍝Scoring function for SA


 cost←3 2⍴¯1 1 1 1 0 1
 cellsize←1
⍝ Z←X×P KERNEL X     ⍝Score for each cell, using kernel (max of 1)
⍝ →L9

  X←0,0⍪(X⍪0),0
 ⍝  Z←(÷4)×(1⌽X)+(1⊖X)+(¯1⌽X)+(¯1⊖X)    ⍝Number of orthogonal neighbors
 Z←(÷9.6)×(1⌽X)+(1⊖X)+(¯1⌽X)+(¯1⊖X)+1.4×(1⌽1⊖X)+(¯1⌽1⊖X)+(1⌽¯1⊖X)+¯1⌽¯1⊖X    ⍝Number of neighbors
  Z←(÷76.8)×(1⌽Z)+(1⊖Z)+(¯1⌽Z)+(¯1⊖Z)+1.4×(1⌽1⊖Z)+(¯1⌽1⊖Z)+(1⌽¯1⊖Z)+¯1⌽¯1⊖Z    ⍝Scores of neighbors
  Z←1 1↓¯1 ¯1↓Z

L9:  Z←Z×iei
 ⍝     Z←Z×(T-(⍴Z)↑DIST T)÷T←⌈/⍴Z
