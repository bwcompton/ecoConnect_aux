Z←D PANEWINDOW P;C;L;I;J;Y
⍝Return GRIDDESCRIBE-style window into pane ⍵ of mosaic window ⍺
⍝   ⍵ = rowsize, colsize, pane index
⍝   ⍺ = Mosaic window: cols, rows, xll, yll, cellsize
⍝   returns (pane window: cols, rows, xll, yll, cellsize) (READBLOCK args: start row, start col, rows, cols)
⍝   use 1st result for setting window to pane, 2nd for reading/writing block in full mosaic
⍝B. Compton, 5-6 Sep 2013. From THISBLOCK.



 C←⌈D[2 1]÷P[1 2]                       ⍝Number of pane rows and columns
 L←1+P[1 2]∣¯1+D[2 1]                   ⍝Number of cell rows and columns in last row and column
 I J ← (⌈P[3]÷C[2]) (1+C[2]∣P[3]-1)     ⍝Pane row and column

 Z←5⍴0 ⋄ Y←4⍴0

 Z[1]←(1+J=C[2])⊃P[2],L[2]              ⍝Cell columns in tile
 Z[2]←(1+I=C[1])⊃P[1],L[1]              ⍝Cell rows in tile
 Z[3]←D[3]+D[5]×P[2]×J-1                ⍝Xll
 Z[4]←D[4]+(D[5]×P[1]×0⌈¯1+C[1]-I)+D[5]×L[1]×I<C[1]  ⍝Yll
 Z[5]←D[5]                              ⍝Cell size

 Y[1]←1+P[1]×I-1                        ⍝Start row
 Y[2]←1+P[2]×J-1                        ⍝Start column
 Y[3 4]←Z[2 1]                          ⍝Cell rows, columns in tile

 Z←Z Y