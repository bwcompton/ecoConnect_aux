Z←GETTABLE F;head;N;T;H
⍝Read table ⍵; if it doesn't exist, just keep trying
⍝For use with cluster software
⍝B. Compton, 19 Apr 2011
⍝26 Jan 2012: don't strip semicolons!
⍝27 Jun 2013: if file doesn't exist, don't create it--just keep trying



 ⍎(0=⎕NC'H')/'H←'''''
L0:→(IFEXISTS F)/L1                     ⍝If file doesn't exist,
 ⎕←'Anthill control file ',F,' not found. Trying again...'
 T←⎕DL 5
 →L0

L1:Z←1 ⎕TCHT ¯1 1 MATIN F               ⍝   Read file
 H←⎕TCHT MATRIFY '.".' TEXTREPL head    ⍝   Set header
 Z←(1+0∊⍴Z)⊃Z ((0,1↑⍴H)⍴0)              ⍝   Deal with empty file
 Z←Z,((1↑⍴Z),(1↑⍴H)-1↓⍴Z)⍴⊂,''          ⍝   Make sure we haven't lost trailing blank columns
 Z←Z H