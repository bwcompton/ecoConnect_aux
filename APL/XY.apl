Z←XY X
⍝Give numeric x,y from ArcMap's fucked up rendition with commands and 'm's, and round to the nearest meter
⍝B. Compton, 11 Dec 2017
⍝3 May 2021: work with ArcGIS Pro too



 Z←0 ROUND ⎕FI '.,..m..N..E..S..W.' TEXTREPL X