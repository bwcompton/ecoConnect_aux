Z←C TABLE F;Q;T;warnings;P
⍝Read parameters file from ⍵.par or ⍵.csv in path ⍺
⍝Force all-character result if ⍺[1], and character empty cells if ⍺[1]=¯1; has header if ⍺[2]; force table id if ⍺[3]
⍝If global tablepath exists, use it as path
⍝26 Aug 2010: enforce ids
⍝1 Sep 2010: force empty cells to character if ⍺[1]=¯1
⍝3 Sep 2010: enforced ids must be sequential
⍝12 Aug 2011: read from tablepath if it's passed in
⍝11 Jul 2013: if table is empty, don't add id!
⍝1 Sep 2014: don't fail when table ids aren't numeric
⍝12 May 2016: if table id is requested, ALWAYS add it--otherwise bad things can happen in calling code



 ⍎(0=⎕NC'C')/'C←0 2'
 C←3↑C,(1≥⍴,C)/2
 ⍎(0=⎕NC'tablepath')/'P←pathI' ⋄ ⍎(0≠⎕NC'tablepath')/'P←tablepath'                ⍝Read from model path, unless global tablepath says otherwise
 →(IFEXISTS Q←P PATH (FRDBL F),(~'.'∊F)/'.par')/L1
 CHECKFILE Q
 Z←1 1⍴(MV '')[1+∣C[1]]
 →(0=⎕NC'warn')/L3
 →warn/0
L3:⎕ERROR MTOV warnings
L1:Z←(C[2],',',C[1]>0) MATIN Q
 →(C[1]≠¯1)/L2                                              ⍝If empty cells must be character,
 Q[(,Z≡¨⊂MV)/⍳⍴Q←,Z]←⊂''
 Z←(⍴Z)⍴Q
L2:→((Z≡1 1⍴MV)∨~(3↑C)[3])/0                                ⍝If enforcing id on non-empty table,
⍝⍝⍝ →(^/Z[;1]≡¨⍳1↑⍴Z)/0                                        ⍝   If we don't already have it,  NO!
 Z←(⍳1↑⍴Z),Z                                                ⍝   Add it
 head←'row',((',',⎕TCHT)[1+⎕TCHT∊head]),head