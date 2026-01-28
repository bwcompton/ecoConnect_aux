 Z←S DEB A;T
 ⍝Deletes leading, trailing, and multiple imbedded blanks in ⍵. In APL64 only, ⍺ is an alternative separator (for MATRIFY)
 ⍝ The argument may be a character scalar, vector, or matrix.
 ⍝ The result is a character vector or matrix.
 ⍝9 Feb 2024: APL+Win/APL64 version
 ⍝29 Feb 2024: Allow alternative separators



 ⍎(0=⎕NC'S')/'S←'' '''
 :if APL64
    Z←(A←(⍬⍴S),A)∊S ⋄ ⍎(1<⍴⍴A)/'Z←^⌿Z' ⋄ Z←((-⍴⍴A)↑1)↓(Z⍲1⌽Z)/A
 :else
    →(T←''⍴(⎕STPTR'Z A T')⎕CALL DEB∆OBJ)↓0
    ⎕ERROR(5 7 8⍳T)⊃'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'
 :end
 
 
 ⍝ Copyright (c) 1988, 1994 Jim Weigang