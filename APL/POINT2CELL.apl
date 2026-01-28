Z←W POINT2CELL XY
⍝Give r,c of cell x,y ⍵ given window ⍺ (ncol, nrow, xll, yll, cellsize)
⍝B. Compton, 8 Oct 2013



 Z←⌈(W[2]-(XY[2]-W[4])÷W[5]),(XY[1]-W[3])÷W[5]