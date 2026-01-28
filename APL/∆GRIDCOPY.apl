A ∆GRIDCOPY B;Q;err;K;M;firstfail
⍝Copy grid to ⍵
⍝B. Compton, 18 Feb 2009; E. Ene, 6 Feb 2009
⍝2 May 2011: set global gridwait for task manager
⍝5 Nov 2013: copy mosaics too
⍝26 Nov 2013: split from GRIDCOPY; don't do mosaics
⍝5 Dec 2013: use 8.3 paths to keep Arc from crashing on otherwise legal long names
⍝9 Dec 2013: shorten the source path, but not grid name--this causes ∆GRIDCOPY to fail!
⍝12 Dec 2013: remove SHORTPATH calls: they were provoking random hard-to-find hangs in CAPS_LIB.gridcopy. Thanks, ESRI!
⍝1 Feb 2024: now use gridio_lib



 →(aplc=1)/0                        ⍝If C version,
 →(3=⎕NC'GRIDCOPYc')/L1             ⍝   If not loaded,
 Q←⎕EX 'GRIDCOPYc'
 ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.gridcopy(*C1, *C1)' ⎕NA 'GRIDCOPYc'
⍝⎕←'GRIDIO_LIB.gridcopy loaded.'

L1:K←⎕AI[2]
L3:err←GRIDCOPYc (A,⎕TCNUL) (B,⎕TCNUL)
 →(RECOVERY err)/L3         ⍝Wait for crashed grid servers to recover
 GRIDWAIT K
 ⎕ERROR REPORTC err