X TMATAPPEND F;J;D;T
⍝Write tab-delimited numeric matrix ⍺ to existing file ⍵, optional delimiter 2⊃⍵
⍝If file doesn't exist, create it, using global head as header line
⍝B. Compton, 28 Jan 2010 (From TMATOUT)
⍝4 Aug 2010: allow passing delimiter as 2⊃⍵
⍝8 Apr 2011: make sure X is a matrix (Republicans shut down the government again...not quite)
⍝25 Jul 2011: don't trash quotes!
⍝1 Aug 2011: Create file (with head) if it doesn't exist
⍝Make very sure file doesn't exist!



 X←(¯2↑1 1,⍴X)⍴X
 →(0∊⍴X)/0                  ⍝If empty matrix, quit now
 D←⎕TCHT
 ⍎(2≤≡F)/'F D ← F'          ⍝If 2⊃⍵ passed, it's the delimiter
 →(0∊⍴X)/L3
 J←0
L1:→((1↓⍴X)<J←J+1)/L2
 →(' '≠1↑0⍴⊃X[1;J])/L1
 X[;J]←↓VTOM '. .⍬' TEXTREPL MTOV MIX⍕¨X[;J]
 X[;J]←'⍞',¨(FRDBL¨X[;J]),¨'⍞'
 →L1
L2:X←0 1↓MIX,/D,¨⍕¨X
L3:X←1↓MTOV X
 X←'.⍬. .⍞.' TEXTREPL X
 →(IFEXISTS F)/L4           ⍝If file doesn't exist yet,
 T←⎕DL 1
 →(IFEXISTS F)/L4
 T←⎕DL 2
 →(IFEXISTS F)/L4
 T←⎕DL 4
 →(IFEXISTS F)/L4
 head NWRITE F              ⍝   create it
L4:(DEB HITOLOW,X) NAPPEND F