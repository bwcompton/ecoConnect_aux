 Z←A MATRIFY B;T
 ⍝Converts a list of words to a matrix having one word per row
 ⍝ The optional left argument is a list of separator characters; the
 ⍝    default value is blank.
 ⍝9 Feb 2024: APL+Win/APL64 version
 ⍝14 Feb 2024: deal properly with multiple delimiter characters
 ⍝29 Feb 2024: correct behavior when delimiters are repeated
 ⍝1 Mar 2024: don't matrify an empty vector



 :if APL64
    ⍎(0=⎕NC'A')/'A←'' '''
    →(1<⍴⍴Z←B)/0            ⍝Bail already a matrix (or higher)
    Z←0 0⍴'' ⋄ →((,0)≡⍴B)/0     ⍝Bail if empty
    :if 1<⍴,A               ⍝If multiple separators,
       B←(⊃,/⎕AV[1],¨A,¨⎕AV[1],¨A[1]) TEXTREPL B  ⍝   change all to 1st
       A←A[1]
    :end
    B←A DEB B               ⍝Remove excess separators
    Z←VTOM A,B
 :else
    →(T←''⍴(⎕STPTR'Z A B')⎕CALL MATRIFY∆OBJ)↓0
    ⎕ERROR(5 7 8⍳T)⊃'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'
 :end   
    
    
 ⍝ Copyright (c) 1988, 1994 by Jim Weigang