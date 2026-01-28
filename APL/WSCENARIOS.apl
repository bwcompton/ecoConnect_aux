Z←WSCENARIOS W;T;Q;I
⍝Disentangle watershed metrics & scenarios from metrics.par lines ⍵
⍝Give list of scenario name ('' for scenario-free) and list of metrics and systems
⍝B. Compton, 12 Aug 2009
⍝10 Jun 2022: scenarios is now 7th column thanks to maxpernode



 T←MIX W[;7]←TOLOWER W[;7]
 T←T[⎕AV⍋T;]
 Q←T MATIOTA T
 Q←T[((Q⍳Q)=⍳⍴Q)/Q;]
 Z←0 2⍴''
 I←0
L1:→((1↑⍴Q)<I←I+1)/0        ⍝For each scenario,
 Z←Z⍪(⊂FRDBL Q[I;]),⊂(W[;7]≡¨⊂FRDBL Q[I;])⌿W[;1 3]
 →L1