X NWRITE F;N;I;T;D
⍝Write ⍺ to dos file ⍵
⍝11 Apr 2011: This version puts newlines at the end, not beginning, to be compatible with R
⍝2 May 2011: try again a few times if error
⍝29 Nov 2012: if text is empty string, don't write newline at end
⍝10 Jul 2014: create directory if it doesn't exist
⍝19 Sep 2014: don't create directory--it can lead to double-locking the Anthill directory (and possibly others)!



 I←0
 →(1≥⍴⍴X)/L1
 X←1↓MTOV X
L1:T←⎕DL ¯1+2*¯1+I←I+1

:Try
 NDROP F
 F ⎕XNCREATE N←-1+0⌈⌈/∣⎕XNNUMS
 X←('/',⎕TCNL,'/',⎕TCNL,⎕TCLF) TEXTREPL X  ⍝Use crlf for compatability
 X←X,(~0∊⍴X)/⎕TCNL,⎕TCLF
 X ⎕NAPPEND N
 ⎕NUNTIE N

:CatchAll
 ⍎(0=⎕NC'tries')/'tries←1'
 →(I<tries)/L1                    ⍝Try again tries times
 ⎕ERROR ⎕DM

:EndTry