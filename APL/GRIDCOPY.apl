A GRIDCOPY B;Q
⍝Copy grid or mosaic ⍺ to grid or mosaic ⍵
⍝B. Compton, 18 Feb 2009; E. Ene, 6 Feb 2009
⍝2 May 2011: set global gridwait for task manager
⍝5 Nov 2013: copy mosaics too
⍝13 Nov 2013: add grid server recovery
⍝26 Nov 2013: split from ∆GRIDCOPY
⍝17 Dec 2013: ignore non-mosaic/non-grids



 Q←GRIDDESCRIBE A←FRDBL A               ⍝What is it?
 →(0∊⍴Q)/0                              ⍝If it's neither a mosaic nor a grid, it's not our problem
 :if Q[12]                              ⍝If it's a mosaic,
    (A,'\') COPYDIRSUB (FRDBL B),'\'    ⍝   copy it
 :else                                  ⍝Else, treat it as a grid
    A ∆GRIDCOPY B
 :end