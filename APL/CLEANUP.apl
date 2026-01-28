CLEANUP;T
⍝Clean up all active grid server connections
⍝B. Compton, 10 and 30 Sep 2013




 ∆CLEANUP
 T←⎕EX 'connections activeconnection'

 →(0=⎕NC'mosaic')/0             ⍝If mosaic exists,
 mosaic←0⌿mosaic
 mosaicwindow←⍳0
 referencewindow←⍳0