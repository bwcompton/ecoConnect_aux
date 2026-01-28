 Z←A MTOV B
 ⍝Converts character matrix ⍵ to ⍺-delimited vector
 ⍝ If the left argument is omitted, ⎕TCNL is used as the delimiter
 ⍝9 Feb 2024: APL+Win/APL64 version


 :if APL64
    ⍎(0=⎕NC'A')/'A←⎕TCNL'
    Z←A MATtoSSa B
 :else
    →(B←''⍴(⎕STPTR'Z A B')⎕CALL MTOV∆OBJ)↓0
    ⎕ERROR(1 2 3⍳B)⊃'WS FULL' 'LENGTH ERROR' 'RANK ERROR' 'DOMAIN ERROR'
 :end
 
 
 ⍝ Copyright (c) 1988, 1994 by Jim Weigang