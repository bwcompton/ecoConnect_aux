Z←GETWINDOW;Q;err;A;firstfail
⍝Returns current grid access window or ⍳0 if window not set
⍝Returns: cols, rows, xll, yll, cellsize
⍝B. Compton, 7 Jun 2011, from SETWINDOW
⍝10 Sep 2013: return ⍳0 if window isn't set
⍝13 Nov 2013: add grid server recovery
⍝10 Nov 2021: don't return MV nor blockonly - they're not used anywhere (part of TIFF revolution)
⍝1 Feb 2024: now use gridio_lib



 →(aplc=1)/0                                    ⍝If C version,
 →(3=⎕NC'GETWINDOWc')/L1                        ⍝   If not loaded,
 Q←⎕EX 'GETWINDOWc'
 ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.getwindow(*I4←,*I4←,*F8←,*F8←,*F8←,*I4←)' ⎕NA 'GETWINDOWc'
⍝⎕←'GRIDIO_LIB.getwindow loaded.'

L1:A←⎕AI[2]
L3:err←1↑Z←GETWINDOWc ⍳6
 →(RECOVERY err)/L3         ⍝Wait for crashed grid servers to recover
 GRIDWAIT A

 →(err≠¯10013)/L2
 Z←⍳0
 →0
L2:⎕ERROR REPORTC err
 Z←Z[3 2 5 4 6]
 
 
 ⍝⍝⍝Z[4]←Z[4]-Z[2]×Z[5]   ⍝************** TEMPORARY FIX FOR EDI'S TOP CORNER FUCKUP