Z←A FILECREATE F;N;⎕ELX;T
⍝Create empty file ⍵; return 1 if successful.  Write ⍺ to the file, if provided.
⍝B. Compton, Apr-Jun 2011



 ⎕ELX←'→Z←0'
 F ⎕XNCREATE N←-1+0⌈⌈/∣⎕XNNUMS
 →(0=⎕NC'A')/L1
 A ⎕NAPPEND N
L1:⎕NUNTIE N
 Z←1