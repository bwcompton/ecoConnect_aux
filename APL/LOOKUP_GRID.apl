Z←D LOOKUP_GRID G;D_;I;B;C
⍝Look up grid ⍵ in cache directory & columns ⍺
⍝Find last 'ready' grid, if there is one; otherwise find last 'copying' grid (or return 0 if nothing)
⍝B. Compton, 26 Apr 2017



 D D_ ← D
 I←D[;D_ COL 'source'] FINDI G
 B←D[I;D_ COL 'status']≡¨⊂'ready'
 C←D[I;D_ COL 'status']≡¨⊂'copying'
 :if 1∊B            ⍝If any are ready,
    Z←¯1↑B/I        ⍝   take last one
 :elseif 1∊C        ⍝Else, if any are copying,
    Z←¯1↑C/I        ⍝   take last one
 :else              ⍝Else,
    Z←0             ⍝   grid not found
 :end