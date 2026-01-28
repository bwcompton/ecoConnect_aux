X NAPPEND F;N;I;T
⍝Append ⍺ to dos file ⍵ (which must exist already)
⍝Modified 16 Feb 2006 to play nicely with Arc
⍝11 Apr 2011: tie in exclusive mode
⍝11 Apr 2011: This version puts newlines at the end, not beginning, to be compatible with R
⍝2 May 2011: try again a few times if error
⍝26 Oct 2015: report filename when there's an error



 I←0
 →(1≥⍴⍴X)/L1
 X←1↓MTOV X
L1:T←⎕DL ¯1+2*¯1+I←I+1
:Try
 F ⎕XNTIE (N←-1+0⌈⌈/∣⎕XNNUMS),18
 X←('/',⎕TCNL,'/',⎕TCNL,⎕TCLF) TEXTREPL X  ⍝Use crlf for compatability
 X←X,⎕TCNL,⎕TCLF
 X ⎕NAPPEND N
 ⎕NUNTIE N

:CatchAll
 ⍎(0=⎕NC'tries')/'tries←1'
 →(I<tries)/L1                    ⍝Try again tries times
 T←((-'.'=¯1↑T)↓T←FRDBL(¯1+⎕DM⍳⎕TCNL)↑⎕DM),': ',F
 ⎕ERROR T

:EndTry