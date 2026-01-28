Z←NREAD F;N;I;T
⍝Read and return dos file ⍵
⍝11 Apr 2011: tie in non-exclusive mode
⍝2 May 2011: try again a few times if error
⍝22 Jul 2011: Report file not found errors politely; attempt to read Unix files properly
⍝4 Mar 2024: getting file not found errors now. Include this error in tries system and report it politely



 I←0
L1:T←⎕DL ¯1+2*¯1+I←I+1                              ⍝Delays before retry: 1 s, 3 s, 7 s, 15 s, 31 s, ...

:Try
 F ⎕XNTIE (N←-1+0⌈⌈/∣⎕XNNUMS),64                    ⍝If file exists,
 Z←⎕NREAD N,82,⎕NSIZE N                             ⍝   return contents
 ⎕NUNTIE N

⍝:CatchIf 1∊⎕DM ⎕SS 'The system cannot find the file specified'
⍝ ⎕ERROR 'Error: file not found: ',F

:CatchIf 1∊⎕DM ⎕SS 'The system cannot find the path specified'
 ⎕ERROR 'Error: file path not found: ',F


:CatchAll
 ⍎(0=⎕NC'tries')/'tries←1'
 ⎕←'[',NOW,'] NREAD failure #',(⍕I),' on ',F,' (',(FRDBL (VTOM ⎕TCNL,⎕DM)[1;]),')...trying again' ⋄ FLUSH
 →(I<tries)/L1                                      ⍝Try again tries times
 :if 1∊⎕DM ⎕SS 'The system cannot find the file specified'
    ⎕ERROR 'Error: file not found: ',F
 :else
    ⎕ERROR ⎕DM
 :end 
 
 

:EndTry
 Z←((^/Z≠⎕TCNL)/'.',⎕TCLF,'.',⎕TCNL) TEXTREPL Z     ⍝If no newlines, might be in Unix format, so convert linefeeds to newlines
 Z←(Z≠⎕TCLF)/Z                                      ⍝Strip linefeeds
 Z←(^\Z≠'→')/Z                                      ⍝Strip after EOF
 Z←(-+/^\⌽Z=⎕TCNL)↓Z                                ⍝Strip trailing newlines
 Z←(Z≠⎕AV[1])/Z                                     ⍝Strip nulls