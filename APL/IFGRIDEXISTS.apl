Z←IFGRIDEXISTS G
⍝Return 1 if grid (or mosaic) ⍵ exists. Note: doesn't give errors for outdated mosaics!
⍝B. Compton, 11-13 Dec 2013
⍝13 Jan 2014: pass through empty grid names quickly



 →(0∊⍴FRDBL G)/Z←0
 Z←0≠⍴0 1 GRIDDESCRIBE G    ⍝A solid but slow approach--checking for files circumvents locking and gives wrong answers sometimes