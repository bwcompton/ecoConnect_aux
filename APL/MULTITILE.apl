Z←MULTITILE G;Q
⍝Return 1 if ⍵ is a multitile ESRI grid
⍝B. Compton, 20-21 Nov 2013
⍝15 Nov 2021: don't do nothing if we're working with TIFFs (part of TIFF revolution)



 →tiff/Z←0
 :Try
    Q←⎕LIB G
 :catch
    →Z←0      ⍝If something goes wrong, just bail out and let someone else deal with it
 :end
 Q←MTOV Q ⋄ Q[(Q∊'0123456789')/⍳⍴Q]←'*' ⋄ Q←VTOM Q
 Z←1<+/Q^.=(1↓⍴Q)↑'w******x.adf'