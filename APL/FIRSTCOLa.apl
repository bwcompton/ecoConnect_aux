 Z←D FIRSTCOLa A;Q
 ⍝Returns each row of delimited vector ⍵ up to the first ⍺ character - APL version
 ⍝ Global result REST is the remainder of each row
 ⍝B. Compton, 12 Feb 2024
 
 

 ⍎(0=⎕NC'D')/'D←'' '''
 A←VTOM ⎕TCNL,(⎕TCNL=1↑A)↓A
 Z←MTOV LJUST(⍴A)↑Q←(+/^\A≠D)⌽((⍴A)⍴' '),A
 REST←MTOV (0 1+1 ¯1×⍴A)↑Q