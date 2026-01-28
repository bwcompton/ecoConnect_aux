Z←PARSEDATE D;A;T;M
⍝Parse date in NOW format into ⎕TS format
⍝B. Compton, 14 Apr 2011
⍝Return 0 if date is '0'
⍝Don't fail if seconds are missing



 Z←0 ⋄ →((0∊⍴D)∨D≡,'0')/0
 A←(7 0⌈⍴A)↑A←MATRIFY '.,. .:. ' TEXTREPL D
 A[6+(⊂FRDBL TOUPPER A[6;])∊'AM' 'PM';]←A[6;] ⍝If no seconds, put AM/PM in the right place
 Z←7⍴0
 Z[1]←(2000×T<1900)+T←⎕FI A[3;]             ⍝Pull out year; convert to 4 digits if necessary
 M←MATRIFY 'January February March April May June July August September October November December'
 Z[2]←(M COL A[2;])⌈M[;⍳3] COL A[2;]        ⍝Month, either full name or 3-letter abbreviation
 Z[3]←⎕FI A[1;]                             ⍝Day
 Z[4]←(¯12×(T=12)^1↑'am' COL A[7;])+(12×(T≠12)^1↑'pm' COL A[7;])+T←⎕FI A[4;]       ⍝Hour, am or pm; or 24 hour time with am/pm omitted
 Z[5]←⎕FI A[5;]                             ⍝Minutes
 Z[6]←⎕FI A[6;]                             ⍝Seconds