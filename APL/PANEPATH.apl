Z←PANEPATH P;M;N;S;D;T
⍝Give path to mosaic pane given path & mosaic 1⊃⍵, origial mosaic name 2⊃⍵, pane # 3⊃⍵, number of panes 4⊃⍵
⍝B. Compton, 30 Sep 2013. Back from the Allagash, Repubs about to shut down government.
⍝16 Nov 2021: if tiff, don't truncate name, less nesting, _ before pane number (part of TIFF revolution)



 P M N S ← P    ⍝path and mosaic, original mosaic name, pane number, number of panes in mosaic

 :if tiff                           ⍝If doing TIFF-based mosaics,
    Z←FRDBL M                       ⍝   base name for panes
    Z←P,'\',Z,'_',(,('ZI',⍕1+⌊10⍟S) ⎕FMT N),'.tif'
 :else                              ⍝Else, Arc grids,
    Z←FRDBL(13-D←1+⌊10⍟S)↑M         ⍝   base name for panes, number of digits to use
    Z←P,T,T←'\',Z,,('ZI',⍕D) ⎕FMT N
 :end