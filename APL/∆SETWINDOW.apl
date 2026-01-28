S ∆SETWINDOW G;Q;N;err;REST;A;Z;firstfail
⍝Sets grid access window to grid ⍵; ignore window already set if ⍺
⍝Sets gridwindow to cols, rows, xll, yll, cellsize
⍝B. Compton, 14 Jan 2009; E. Ene, 6 Feb 2009
⍝2 May 2011: set global gridwait for task manager
⍝6 Sep 2013: call ∆CLEANUP to release old buffers
⍝9 Sep 2013: set gridwindow instead of returning window
⍝10 Sep 2013: change from SETWINDOW
⍝13 Nov 2013: add grid server recovery
⍝10 Nov 2021: don't return MV nor blockonly - they're not used anywhere (part of TIFF revolution). Plus, drop APL .asc version.
⍝1 Feb 2024: now use gridio_lib



 ⍎(0=⎕NC'S')/'S←0'
 →(3=⎕NC'SETWINDOWc')/L1                        ⍝   If not loaded,
 Q←⎕EX 'SETWINDOWc'
 ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.setwindow(*C1,*I4←,*I4←,*F8←,*F8←,*F8←,*I4←)' ⎕NA 'SETWINDOWc'
⍝⎕←'GRIDIO_LIB.setwindow loaded.'

L1:A←⎕AI[2]
L3:err←1↑Z←SETWINDOWc (G,⎕TCNUL) 1 2 3 4 5 6
 →(RECOVERY err)/L3                             ⍝Wait for crashed grid servers to recover
 GRIDWAIT A
 ⎕ERROR REPORTC (1+err≠S×¯10014)⊃1 err          ⍝If ⍺, ignore window already set error
 Z←Z[3 2 5 4 6]
 gridwindow←Z