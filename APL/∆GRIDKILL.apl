E ∆GRIDKILL G;Z;C;R;Q;err;A;B;firstfail
⍝Kill a single grid ⍵.  Suppress grid not found error unless ⍺.
⍝B. Compton, 8 Jan 2009; E. Ene, 19 Feb 2009
⍝2 May 2011: set global gridwait for task manager
⍝14 Nov 2013: split from GRIDKILL, which kills multiple grids and mosaics
⍝20 Nov 2023: also kill auxiliary files
⍝1 Feb 2024: now use gridio_lib



 ⍎(0=⎕NC'E')/'E←0'
 →(aplc=1)/L9                       ⍝If C version,
 →(3=⎕NC'GRIDKILLc')/L1             ⍝   If not loaded,
 Q←⎕EX 'GRIDKILLc'
 ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.gridkill(*C1)' ⎕NA 'GRIDKILLc'

L1:A←⎕AI[2]
L3:NDROP G,'.aux.xml'
 NDROP G,'.ovr'
 NDROP (¯4↓G),'.tfw'
 
 err←GRIDKILLc ⊂G,⎕TCNUL
 →(RECOVERY err)/L3                 ⍝Wait for crashed grid servers to recover
 GRIDWAIT A
 ⎕ERROR REPORTC 1⌊(E∨err≠¯10007)×err⍝Report errors (except grid not found)
 →0

L9:⍝No APL version of this one.