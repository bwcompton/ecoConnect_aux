 Z←FRDBL A
 ⍝Deletes leading and trailing blank columns in matrix or vector ⍵
 ⍝9 Feb 2024: APL+Win/APL64 version


 :if APL64
    Z←DLB DTB A
 :else
    →(A←''⍴(⎕STPTR'Z A')⎕CALL FRDBL∆OBJ)↓0
    ⎕ERROR(5 7 8⍳A)⊃'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'
 :end
    
    
 ⍝ Copyright (c) 1988, '92, '94 by Jim Weigang