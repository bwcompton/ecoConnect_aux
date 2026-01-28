Z←MODEL
⍝Return model name from ffile

 →(∨/'.\'∊ffile)/L1     ⍝If simple model name,
 Z←ffile
 →0
L1:Z←(Z⍳'.')↓Z←⌽ffile   ⍝Else extract from path
 Z←⌽(¯1+Z⍳'\')↑Z