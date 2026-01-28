Z←P NGET N
⍝Read block of size ⍵[2] from open native file ⍵[1]; reset file ptr if ⍺

 ⍎(0=⎕NC'P')/'P←0'
 ⍎(0=⎕NC'fileptr')/'fileptr←0'
 fileptr←fileptr×~P     ⍝If ⍺=1, reset to start of file

 Z←⎕NREAD N[1],82,N[2],fileptr
 →(0∊⍴Z)/0
 fileptr←fileptr+⍴Z
 Z←(Z≠⎕TCLF)/Z          ⍝Strip formfeeds
 Z←Z,(⎕TCNL≠¯1↑Z)/(fileptr≥⎕NSIZE N[1])/⎕TCNL  ⍝Newline if EOF and without
⍝ Z[(Z=⎕TCHT)/⍳⍴Z]←' '   ⍝Tab to space - 31 Aug 2010: This is wrong, I think
 Z←LOWTOHIX Z
 Z←(-0⌈¯1++/^\⌽Z=⎕TCNL)↓Z