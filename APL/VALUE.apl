Z←D VALUE V
⍝Return value of variable ⍵, default ⍺ (default = 0) if it doesn't exist
⍝B. Compton, 9 Jul 2012



 ⍎(0=⎕NC'D')/'D←0'
 Z←D
 →(0=⎕NC V)/0
 Z←⍎V