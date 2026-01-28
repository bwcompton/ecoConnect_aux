X PUTCACHEDIR G;head;X_
⍝Write the grid cache directory and header ⍺ for grid or index number ⍵.
⍝Assumes lock on cache directory is already held.
⍝If caching is off, just return
⍝B. Compton, 17 May 2016 (from GETCACHEDIR)



 →(cache[1]=0)/0                    ⍝If caching is off, return 0

 X X_ ← X
 head←1↓⎕TCHT MTOV X_
⍝ X[;X_ COL 'xll yll cellsize']←FMTALL X[;X_ COL 'xll yll cellsize']    ⍝   Format xll, yll, and cellsize with a zillion digits
 X TMATOUT GETCACHEPATH G           ⍝      Write directory