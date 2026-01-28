Z←E ∆GRIDDESCRIBE G;Q;N;REST;err;A;firstfail
⍝Return info on named grid ⍵ regardless of access window. Global tiff switches between TIFF or ESRI gridserver
⍝If ⍺[1], rebuild TIFF stats
⍝If ⍺[2], return empty list for non-existing grid, otherwise throw error
⍝Returns: cols, rows, xll, yll, cellsize, nodata, cell type (1 = integer, 2 = real), minimum value in grid, maximum, mean, standard deviation, and 1 if mosaic
⍝B. Compton, 14 Jan 2009; E. Ene, 6 Feb 2009
⍝13 Sep 2010: returns 4 additional elements
⍝2 May 2011: set global gridwait for task manager
⍝5 Sep 2013: rename from GRIDDESCRIBE
⍝7 Oct 2013: return 12th element: flag if mosaic; pull old APL ascii file version
⍝10 Oct 2013: if ⍺, suppress errors
⍝13 Nov 2013: add grid server recovery
⍝29 Sep 2021: add update grid stats for TIFF gridservers as ⍺[1]; move old ⍺ to ⍺[2]
⍝1 Feb 2024: now use gridio_lib



 ⍎(0=⎕NC'E')/'E←0 0'
 E←2↑E
 →(3=⎕NC'GRIDDESCRIBEc')/L1             ⍝If not loaded,
 Q←⎕EX 'GRIDDESCRIBEc'
 :if tiff                               ⍝If new tiff gridserver,
    ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.griddescribe(*C1,*I4←,*I4←,*F8←,*F8←,*F8←,*I4←,*F8←,*F8←,*F8←,*F8←,I4)' ⎕NA 'GRIDDESCRIBEc'
 :else                                  ⍝else, old ESRI gridserver
    ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.griddescribe(*C1,*I4←,*I4←,*F8←,*F8←,*F8←,*I4←,*F8←,*F8←,*F8←,*F8←)' ⎕NA 'GRIDDESCRIBEc'
 :end

L1:A←⎕AI[2]
L3:err←1↑Q←GRIDDESCRIBEc (⊂(FRDBL G),⎕TCNUL),(10⍴0),tiff/E[1]
 →(RECOVERY err)/L3                     ⍝Wait for crashed grid servers to recover
 GRIDWAIT A
 →(E[2]^err=¯10007)/⍴Z←⍳0               ⍝If errors are suppressed, return empty list
 ⎕ERROR G REPORTC err
 Z←Q[3 2 5 4 6],MV,(6↓Q),0