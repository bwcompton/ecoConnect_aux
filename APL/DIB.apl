 Z←DIB A;T
 ⍝Deletes excess internal blanks in ⍵ (but not leading & trailing)

 →(0∊⍴Z←A)/0
 Z←((' '=1↑A)⍴' '),(DEB A),(' '=¯1↑A)⍴' '
 Z←((⍴Z)⌊⍴,A)↑Z