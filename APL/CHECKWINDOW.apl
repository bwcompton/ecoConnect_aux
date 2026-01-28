Z←CHECKWINDOW W;X;R;Q;C;S
⍝Check grid server window 1⊃⍵ with set flag 2⊃⍵ against existing connections
⍝Returns (conformation flag) (message)
⍝Checks that:
⍝   1. Upper left corner matches reference window
⍝   2. Extent matches reference window, within one cell
⍝   3. Cell size is an integer multiple or factor of reference cell size
⍝B. Compton, 10-12 Sep 2013
⍝4 Oct 2013: bug fix with lower right corner
⍝2 Jan 2014: more messing with stupid high-precision extents



 W S ← W
 Z←1 ''
 →(S=0)/0                           ⍝Everything is okay: ∘ if window isn't set
 →(0=⎕NC'connections')/0            ⍝   ∘ if connections are not set
 →(0∊⍴connections)/0                ⍝   ∘ if connections are empty
 →(0∊⍴R←referencewindow)/0          ⍝   ∘ if no reference window

 X←W[3],W[4]+W[2]×W[5]              ⍝Upper left corner
 Q←R[3],R[4]+R[2]×R[5]
 Z←0 'Upper left corner doesn''t match previous connections'
 →(∨/X≠Q)/0                         ⍝Upper left corner doesn't conform

 X←(W[3]+W[1]×W[5]),W[4]            ⍝Lower right corner
 Q←(R[3]+R[1]×R[5]),R[4]
 Z←0 'Grid extent doesn''t match previous connections'
 →((∨/X≠Q)^∨/(0>X-Q)∨R[5]<X-Q)/0    ⍝Extent does't match
 →((W[4]<R[4])∨R[5]≤W[4]-R[4])/0

 C←(↑5↑¨(⊃,/0≠⍴¨C)/C←connections[;connections_ COL 'window'])[;5]   ⍝Existing cell sizes
 Z←0 'Cell size isn''t a multiple or factor of all existing cell sizes'
 →(~^/((W[5]<C)∨0=C∣W[5])^(W[5]>C)∨0=W[5]∣C)/0

 Z←1 ''