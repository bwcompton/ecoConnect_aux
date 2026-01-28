Z←S REMV A;I;M;Q
⍝Replace values in ⍵ corresponding with MVs in any ⍺ with correct MV
⍝Allows multiple MV types in global MV (e.g., NODATA, developed, etc.)
⍝Matrices must conform.  ⍺ may be nested vector of matrices.  In case
⍝of MV conflict among ⍺ grids, earlier entries in MV list prevail.
⍝16 Feb 2006: passes scalars through - they must not be missing
⍝29 Aug 2012: in simple cases, call MVREP instead
⍝  *** I'm not convinced we usually want this; I bet we could usually use MVREP directly



 →(0=⍴⍴Z←A)/0

 →((1<≡S)∨1<⍴,MV)/L0    ⍝If simple case (one ⍺ and one kind of missing value),
 Z←MVREP A (S=MV)       ⍝   Do it fast
 →0

L0:M←,MV
 →(1≥≡S)/L1             ⍝If ⍺ contains multiple matrices,
 S←(0≠⊃,/⍴¨⍴¨S)/S       ⍝   Scalars are excluded for MV replacement
 S←,(1+⍴M)∣⌊⌿M⍳↑S       ⍝   Combine grids
 →L2
L1:S←,(1+⍴M)∣M⍳S        ⍝Else, just have one
L2:Z←(×/⍴A)⍴A
 I←0
L3:→((⍴M)<I←I+1)/L4     ⍝For each missing value type,
 Z[(S=I)/⍳⍴Z]←M[I]      ⍝   replace MV in result
 →L3
L4:Z←(⍴A)⍴Z