 Z←DTB A
 ⍝Deletes trailing blank columns in character vector or matrix ⍵
 ⍝9 Feb 2024: APL+Win/APL64 version


 :if APL64
    Z←~A∊' '
    ⍎(2=⍴⍴A)/'Z←∨⌿Z'
    Z←(⌽∨\⌽Z)/A
 :else
    →(A←''⍴(⎕STPTR'Z A')⎕CALL DTB∆OBJ)↓0
    ⎕ERROR(5 7 8⍳A)⊃'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'
 :end
    
    
 ⍝ Copyright (c) 1992, 1994 by Jim Weigang