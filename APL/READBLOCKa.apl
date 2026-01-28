Z←R READBLOCKa F;H;L;X;N;I;T;J;B;C;S;P;REST;Q;O;E
⍝Get tile from ascii grid ⍵.  Get ⍺[3 4] rows & cols, starting at row & col ⍺[1 2]
⍝Also read buffer around rectangle ⍺[5] cells wide
⍝Row & column are upper left corner (Arc uses lower left)
⍝B. Compton, 31 Oct 2003
⍝15 Jan 2009: renamed from GETGRID


 L←1E5                        ⍝Block size must be >> header + longest line

 E←GRIDDESCRIBE F             ⍝Make sure block falls within original
 →(^/E[2 1]≥R[1 2]+¯1+R[3 4])/L0
 ⎕ERROR 'READBLOCKa Error: Block to read doesn''t fall within grid.'

L0:(PATH F) ⎕XNTIE N←-1+0⌈⌈/∣⎕XNNUMS
 P←1                          ⍝Start at beginning of file
 O←∣0⌊(¯1+R[1 2]-R[5]),(E[2 1]-R[1 2]-1)-R[3 4]+(R←5↑R)[5]  ⍝Buffer overshoot beyond edges of grid
 R[3 4]←R[3 4]+(2×R[5])-O[1 2]+O[3 4]
 R[1 2]←R[1 2]-R[5]-O[1 2]
 ⍝R[⍳4]←R[⍳4]+¯1 ¯1 1 1×R[5]-O ⍝Increase tile size by buffer
 I←0
 T←''
 Z←(0,R[4])⍴0
L1:X←DIB T,P NGET N,L         ⍝Read block
 →(I>P←0)/L2                  ⍝   If first block
 H←(J←(+\X=⎕TCNL)⍳6)↑X        ⍝      Get header
 T←VTOM FIRSTCOL H            ⍝      Header labels (we'll assume they're correct)
 H←⎕FI,' ',VTOM FIXE REST     ⍝      Header
 X←J↓X                        ⍝      Rest of stuff
L2:T←(-+/^\⌽X≠⎕TCNL)↑X        ⍝   Keep partial line at end in buffer
 X←(-⍴T)↓X
 B←+\X=⎕TCNL                  ⍝   Newlines
 C←((⍴X)↑Q[1],Q←R[1]>B+I+1)/X ⍝   Lines before block
 X←(⍴C)↓X                     ⍝   Lines containing our block
 I←I++/C=⎕TCNL
 →(0∊⍴X)/L1                   ⍝Next block
 →L4
L3:X←T,NGET N,L               ⍝Repeat: read another block (except first time)
 T←(-+/^\⌽X≠⎕TCNL)↑X          ⍝   Keep partial line at end in buffer
 X←DEB(-⍴T)↓X
L4:S←+/X=⎕TCNL
 X←(S,H[1])⍴⎕FI ('/',⎕TCNL,'/ ') TEXTREPL FIXE X
⍝ X←(((1↑⍴X)⌈R[4]-1↑⍴Z),1↓⍴X)  ⍝   Don't take too much
 Z←Z⍪X[⍳(0⌈R[3]-1↑⍴Z)⌊1↑⍴X;R[2]+¯1+⍳R[4]]   ⍝   Block we're reading
 →((1↑⍴Z)<R[3])/L3            ⍝Until we're finished with block
 ⎕NUNTIE N
 Z←((O[1],1↓⍴Z)⍴E[6])⍪Z⍪(O[3],1↓⍴Z)⍴E[6]      ⍝Fill overshot edges with nodata values
 Z←(((1↑⍴Z),O[2])⍴E[6]),Z,((1↑⍴Z),O[4])⍴E[6]