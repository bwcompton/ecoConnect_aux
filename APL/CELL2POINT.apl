Z←W CELL2POINT RC
⍝Give x,y of cell r,c ⍵ given window ⍺ (ncol, nrow, xll, yll, cellsize)
⍝B. Compton, 8 Oct 2013



 Z←W[3 4]+W[5]×(RC[2]-.5),.5+W[2]-RC[1]