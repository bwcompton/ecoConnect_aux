Z←TOUPPER A;S
⍝Convert ⍵ to uppercase. Pass numbers through.

 →(1≥≡A)/L1
 Z←TOUPPER¨A
 →0
L1:→((0∊⍴A)∨0=1↑0⍴Z←A)/0
 Z←TOUPPERX A