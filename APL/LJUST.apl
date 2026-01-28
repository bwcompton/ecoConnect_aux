 Z←LJUST A
 ⍝Left-justifies character vector or matrix ⍵
 ⍝8 Feb 2024: APL+Win/APL64 version
 
 
 
 :if APL64
    Z←(+/^\A=' ')⌽A
 :else
    →(A←''⍴(⎕STPTR'Z A')⎕CALL LJUST∆OBJ)↓0
    ⎕ERROR(5 7 8⍳A)⊃'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'
 :end   
    
    
 ⍝ Copyright (c) 1988, 1994 by Jim Weigang