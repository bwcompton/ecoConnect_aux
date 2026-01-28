Z←STRIP F;S
⍝Strip path and extension from filename ⍵
⍝13 Sep 2010: Don't confuse ..\path with .extension
⍝5 Feb 2018: work properly with paths that have dots in them (2017-18 Plague of Squirrels--I killed #10 halfway through this comment)



 S←⌽^\⌽F≠'\'
 Z←(⌽^\'\'≠⌽F)/F←(^\((~S)∨'.'≠F)∨S^(1⌽S^F='.')∨¯1⌽S^F='.')/F