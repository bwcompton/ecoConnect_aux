 Z←VTOM V;T;F;I;W;E;M
 ⍝Converts delimited vector ⍵ to matrix.  Delimiter is 1↑⍵.
 ⍝9 Feb 2024: APL+Win/APL64 version
 ⍝14 Feb 2024: SStoMATa is different. Type in Jim Weigang's code from APL Notes, 1992!


 :if APL64
    F←V=1↑V←,V
    I←(F/⍳⍴F),1+⍴F
    W←(1↓I)-¯1↓I
    E←W∘.≥⍳M←0⌈⌈/W
    Z←(,E)\V
    Z←((⍴W),M)⍴Z
    Z←0 1↓Z    
 :else
    →(T←''⍴(⎕STPTR'Z V')⎕CALL VTOM∆OBJ)↓0
    ⍝ Uncomment the next line to make VTOM accept a matrix argument:
    ⍝ →((T=5)^2=⍴⍴Z←V)/0⍝return matrix unchanged
    ⎕ERROR(5 7 8⍳T)⊃'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'
 :end
 

 ⍝ Copyright (c) 1994 Jim Weigang.  All rights reserved.