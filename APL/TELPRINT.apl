Z←A TELPRINT B;W;N;R
⍝Reshapes character matrix ⍵ into multiple columns with overall width ≤⍺
⍝ The optional left argument is a limit on the width of the result;
⍝    the default value is ⎕PW
⍝9 Feb 2024: APL+Win/APL64 version



 ⍎(0=⎕NC'A')/'A←⎕PW'

 :if APL64
    ⎕IO←1 ⋄ W←2+(⍴B)[2] ⋄ N←1⌈⌊(A+2)÷W
    R←⌈(1⍴⍴B)÷N ⋄ N←⌈(1⍴⍴B)÷R ⋄ B←((N×R),-W)↑B ⋄ B← 2 1 3 ⍉(N,R,W)⍴B
    Z←0 2↓(R,N×W)⍴B
 :else
    →(W←''⍴(⎕STPTR'Z A B W')⎕CALL TELPRINT∆OBJ)↓0
    →(~(W=3)^A<¯1↑⍴B)/L1 ⍝If the argument was too wide,
    Z←B ⍝   just return it unchanged
    ⍝ (An error in this situation is not really useful.)
    →0
L1: Z←'LENGTH ERROR' 'LIMIT ERROR' 'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'
    ⎕ERROR(3 4 5 7 8⍳W)⊃Z
:end

    
 ⍝ Copyright (c) 1988, 1994 by Jim Weigang