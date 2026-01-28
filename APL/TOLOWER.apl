Z←TOLOWER X;A;B
⍝Convert ⍵ to lowercase

 A←'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 Z←,X
 Z[B/⍳⍴Z]←A[1+27∣¯1+A⍳(B←Z∊A)/Z]
 Z←(⍴X)⍴Z