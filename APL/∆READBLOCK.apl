Z←H ∆READBLOCK GP;Q;A;T1;T2;T3;T4;T5;T6;G;P;err;E;firstfail
⍝Read block 1↓⍵ from grid 1⊃⍵, with optional grid description ⍺; primitive function
⍝   ⍵[1]    grid path & name
⍝   ⍵[2 3]  starting row & column
⍝   ⍵[4 5]  nrows & ncols
⍝   ⍵[6]    buffer in cells (default = 0)
⍝Optionally passed grid description ⍺
⍝B. Compton, 15 Jan 2009; E. Ene, 7 Jan 2009
⍝2 May 2011: set global gridwait for task manager (20 May: do it right!)
⍝25 Apr 2013: make robust to attempts to read beyond origin
⍝5 Sep 2013: rename from READBLOCK
⍝9 Sep 2013: no longer set header/gridwindow
⍝30 Sep 2013: optionally passed grid description
⍝13 Nov 2013: add grid server recovery
⍝21 Nov 2013: check for multitiled grid and give error
⍝24 Jan 2014: give an error when attempting to read too large a block
⍝20 Jun 2016: round to single-precision (Full moon solstice). 28 Jun 2016: but don't round integer grids!!!
⍝20 Jan 2020: comment out check for grid > 16E6 R×C--it's wrong and messes with Mass CAPS runs
⍝1 Feb 2024: now use gridio_lib



 :if 0≠⎕NC'noread'
    →noread/1↑⍴Z←0 0⍴''
 :end
 G←1⊃GP ⋄ P←5↑1↓GP

⍝ ⎕ERROR (16E6<×/P[3 4])/'Error: block of ',(⍕P[3]),' rows by ',(⍕P[4]),' columns is too large to read from a grid'

 →(aplc=1)/L9                        ⍝If C version,
 →(3=⎕NC'READBLOCKc')/L1             ⍝   If not loaded,
 Q←⎕EX 'READBLOCKc'
 ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.readblock_dbl(*C1,I4,I4,I4,I4,I4,F8,*F8←)' ⎕NA 'READBLOCKc'
 ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.readblock_int(*C1,I4,I4,I4,I4,I4,I4,*I4←)' ⎕NA 'READBLOCKIc'
⍝⎕←'GRIDIO_LIB.readblock_dbl and .readblock_int loaded.'

L1:E←0⌈1-P[1 2] ⋄ P[⍳4]←(1⌈P[1 2]),P[3 4]-E   ⍝Make sure we're not reading beyond west/north edges
 ⎕ERROR (MULTITILE G)/'Error: grid ',G,' is a multitiled ESRI grid - it can''t be read'
 :if 0=⎕NC'H'                       ⍝If grid description wasn't passed,
    H←∆GRIDDESCRIBE G               ⍝   Get info
 :end
 T1 T2 T3 T4 T5 T6←P,MV
 A←⎕AI[2]
 →(H[7]=2)/L2                       ⍝If integer grid,
 Z←(P[3 4]+2×P[5])⍴0
L4:err Z←READBLOCKIc (G,⎕TCNUL) T1 T2 T3 T4 T5 T6 Z
 →(RECOVERY err)/L4                 ⍝Wait for crashed grid servers to recover
 →L3

L2: Z←(P[3 4]+2×P[5])⍴0.1           ⍝Else, floating point
L5:err Z←READBLOCKc (G,⎕TCNUL) T1 T2 T3 T4 T5 T6 Z
 Z←7 ROUND Z                        ⍝Round to single precision to prevent goofy rounding errors
 →(RECOVERY err)/L5                 ⍝Wait for crashed grid servers to recover

L3:GRIDWAIT A
 Z←((E[1],(⍴Z)[2])⍴MV)⍪Z            ⍝Fill out grid if we've read beyond 0,0
 Z←(((⍴Z)[1],E[2])⍴MV),Z
 ⎕ERROR G REPORTC err
 →0

L9:Z←P READBLOCKa G,(~'.'∊G)/'.asc' ⍝APL version: read from .asc file