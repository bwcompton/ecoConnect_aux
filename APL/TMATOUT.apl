X TMATOUT F;J;S;D;I;L;N;T
⍝Write tab-delimited numeric matrix ⍺ to file ⍵, delimiter 2⊃⍵
⍝Treat null and strings with spaces properly (28 Apr 2005)
⍝Uses global head as header line
⍝2⊃⍵ is delimiter, if present
⍝B. Compton, from CMATOUT (1 Jun 2006)
⍝23 Mar 2009: failed for ⊂''
⍝31 Mar 2009: no header if head is blank
⍝4 Aug 2010: merge with CMATOUT; write big matrices in loops.  Note: does not lock file, so not cluster-friendly
⍝19 Apr 2011: be more careful with empty matrix
⍝19 May 2011: don't trash quotes!
⍝18 Oct 2011: when creating huge files, wait for windows file system
⍝10 Dec 2012: if empty filename, exit (for use with INITIALIZE)
⍝13 Jul 2016: don't crash if one of the columns is a character scalar!



 →(0∊⍴F)/0                      ⍝If empty filename, just exit
 D←⎕TCHT
 ⍎(2≤≡F)/'F D ← F'              ⍝If 2⊃⍵ passed, it's the delimiter
 →(~0∊⍴X)/L1                    ⍝If empty matrix,
 head NWRITE F                  ⍝   just write header
 →0
L1:→((L←1E4)<1↑⍴X)/L5           ⍝If reasonably small matrix (no more than L rows),
 J←0
L2:→((1↓⍴X)<J←J+1)/L3
 →(' '≠''⍴1↑0⍴⊃X[1;J])/L2
 X[;J]←↓VTOM '. .⍬' TEXTREPL MTOV MIX,¨⍕¨X[;J]
 X[;J]←'⍞',¨(FRDBL¨X[;J]),¨'⍞'
 →L2
L3:X←0 1↓MIX,/D,¨⍕¨X
L4:X←head,(0∊⍴head)↓MTOV X
 X←'.⍬. .⍞.' TEXTREPL X
 (DEB HITOLOW,X) NWRITE F
 →0

L5:I←0                          ⍝Else, absurdly huge matrix - we'll have to loop
 head NWRITE F

L6:X[I+⍳((1↑⍴X)-I)⌊L;] TMATAPPEND F D
 ⍎(I=0)/'T←⎕DL 5'               ⍝   wait a while so windows file system realizes it exists.  Bah.
 I←I+L
 →(I<1↑⍴X)/L6