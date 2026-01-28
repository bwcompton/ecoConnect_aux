Z←M PULLPARS X;J;I
⍝Pull parameter lines out of character matrix ⍵ matching bracket tag ⍺
⍝Allows for multiple instances of ⍺
⍝Returns (1 if found) (matrix of parameters)
⍝B. Compton, 11 Apr 2012
⍝21 Aug 2020: OMG: for all these years, this has been picking up [metric] in mid-line, in comments or whatever. Now must be 1st thing in line (leading spaces are okay)



 Z←0 (0 0⍴'')
L1:I←(∨/¨(↓TOUPPER '⌷',LJUST X) ⎕SS¨⊂'⌷[',(TOUPPER M),']')⍳1
 X←(I,0)↓X
 →(0∊⍴X)/0
 J←¯1+X[;1]⍳'['
 Z←1 ((2⊃Z) OVER FRDBL X[⍳J;])
 X←(J,0)↓X
 →(~0∊⍴X)/L1