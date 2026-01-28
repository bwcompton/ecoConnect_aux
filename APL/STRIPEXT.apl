Z←STRIPEXT F;S
⍝Strip extension from filename ⍵ and return it
⍝5 Feb 2018: work properly with paths that have dots in them



 S←⌽^\⌽F≠'\'
 Z←FRDBL 1↓(~^\((~S)∨'.'≠F)∨S^(1⌽F='.')∨¯1⌽F='.')/F