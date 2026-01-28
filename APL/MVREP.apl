Z←R MVREP X;I;J;Q;err
⍝Replace missing values in 1⊃⍵ corresponding to 1's in binary 2⊃⍵ with ⍺ (default = MV)
⍝If ⍵ is a matrix, look for MVs in it
⍝Runs APL version if aplc=1, or C version if aplc=2
⍝B. Compton/E. Ene, 19 Dec 2008
⍝17 Feb 2010: return integer for integer argument
⍝8 Oct 2010: separate floating point and integer versions
⍝27 Aug 2012: make sure MV grid is integer but do it quickly
⍝20-26 Sep 2012: new version from Edi takes binary template
⍝22 Oct 2012: fixed bug in higher-dimensional arrays



 ⍎(0=⎕NC'R')/'R←MV'
 ⍎(2>≡X)/'X←X (X=MV)'           ⍝If passed only 1 matrix, template is X=MV
 ⎕ERROR (~≡/⍴¨X)/'MVREP: matrices with different shapes'
 →(aplc=1)/L2                   ⍝If C version,
 →(3=⎕NC'MVREPc')/L1            ⍝   If not loaded,
 Q←⎕EX 'MVREPc'
 ⎕ERROR REPORTC 'DLL I4← CAPS_LIB.mvrep_dbl(I4,I4,F8,F8,*F8←,*B1)' ⎕NA 'MVREPc'
 ⎕ERROR REPORTC 'DLL I4← CAPS_LIB.mvrep_int(I4,I4,I4,I4,*I4←,*B1)' ⎕NA 'MVREP_Ic'
⍝⎕←'CAPS_LIB.mvrep loaded.'

L1:X Z ← X
 →(0∊⍴Z)/0
 I J ← (1↑⍴X),1⌈×/1↓⍴X          ⍝Make sure we're good for vectors and higher-dimensional arguments
 ⍝I J ← ¯2↑1 1,⍴X   FAILS FOR 3 DIMENSIONAL ARRAYS!
 →(645∊⎕DR¨X R)/L3              ⍝If matrix and replacement are integers,
 err Z←MVREP_Ic I J MV R X Z
 →L4

L3:→(323=⎕DR Z)/L5              ⍝If missing value grid is floating point, change it to integer
L5:err Z←MVREPc I J MV R X Z    ⍝Else, floating point version
L4:⎕ERROR REPORTC err
 →0

L2:Z X←X                        ⍝Else, APL version
 Z←R UNMV X REMV Z