X NWRITEe F;N;⎕ELX
⍝Write ⍺ to dos file ⍵; retry if error

 ⎕ELX←'→L1'
 →(1≥⍴⍴X)/L1
 X←1↓MTOV X
L1:NDROP F
 F ⎕XNCREATE N←-1+0⌈⌈/∣⎕XNNUMS
 X←('/',⎕TCNL,'/',⎕TCNL,⎕TCLF) TEXTREPL X  ⍝Use crlf for compatability
 X ⎕NAPPEND N
 ⎕NUNTIE N