NDROP F;N;I;T
⍝Erase native file ⍵
⍝11 Apr 2011: tie in exclusive mode
⍝22 Apr 2011: check to see if file exists
⍝2 May 2011: try again a few times if error



 I←0
L1:T←⎕DL ¯1+2*¯1+I←I+1

:Try
 →(~IFEXISTS F)/0
 F ⎕XNTIE (N←-1+0⌈⌈/∣⎕XNNUMS),18
 F ⎕XNERASE N

:CatchAll
 ⍎(0=⎕NC'tries')/'tries←1'
 →(I<tries)/L1                    ⍝Try again tries times
 ⎕ERROR ⎕DM

:EndTry