 Z←A OVER B;S
 ⍝Forms a matrix with ⍺ over ⍵
 ⍝9 Feb 2024: APL+Win/APL64 version



 :if APL64
    →L1
 :else
    →(S←''⍴(⎕STPTR'Z A B')⎕CALL OVER∆OBJ)↓0
    →(S=1)/L1
    ⎕ERROR(2 3 4⍳S)⊃'RANK ERROR' 'WS FULL' 'SYNTAX ERROR' 'DOMAIN ERROR'

    ⍝ Use an APL version for mixed types, Booleans, or nested:
L1: S←⍴A←(¯2↑1 1,⍴A)⍴A
    S←0 1×S⌈⍴B←(¯2↑1 1,⍴B)⍴B
    Z←(A←(S⌈⍴A)↑A)⍪B←(S⌈⍴B)↑B
 :end
 
 
 ⍝ Copyright (c) 1988, 1994 by Jim Weigang