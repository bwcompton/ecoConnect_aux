 Z←A MATIOTA B;T;V;W;Y
 ⍝Looks up rows of ⍵ in matrix ⍺.  Returns row indices or 0 if not found
 ⍝ The args may be character or numeric scalars, vectors, or matrices.
 ⍝ The result is a vector if B is a matrix, or is a scalar if B is a
 ⍝    vector or scalar.
 ⍝9 Feb 2024: APL+Win/APL64 version


 :if APL64
    Z←A ROWFINDa B
 :else
 
L1: →(T←''⍴(⎕STPTR'Z A B T')⎕CALL MATIOTA∆OBJ)↓0
    ⍝ If the args are numeric and have different types, coerce to same type:
    →(T≠6)/L2 ⍝jump if asm code didn't signal nonce error
    Y←(⎕DR A),⎕DR B
    W←⌈/Y ⍝worse type of A and B
    →(W=11)/L3 ⍝jump if both args are Boolean
    T←''⍴(323 645⍳W)⊃(,2-2) (,.5-.5) ⍝0, in worse type (int or real)
    →(W=1↑Y)/L4 ⋄ A←T+A ⍝coerce A if not already worse type
L4: →(W=1↓Y)/L1 ⋄ B←T+B ⍝coerce B...
    ⍝ ↑ Branch to avoid unnecessary conversion in case args are Really Big.
    →L1 ⍝retry
 
    ⍝ Boolean case: pad to even byte width, convert to character using ⎕DR:
L3: A←1/A ⋄ B←1/B ⍝ravel scalars
    V←¯1↑⍴A ⋄ W←¯1↑⍴B ⍝widths
    T←5 ⋄ →(V≠W)/L2 ⍝err of widths don't match
    ⍝ ↑ This has to be done because once A and B are character type,
    ⍝   MATIOTA will happily pad the narrower with blanks, possibly
    ⍝   resulting in incorrect answers.
    A←((⍴A)⌈(-⍴⍴A)↑8×⌈V÷8)↑A ⍝pad to multiple of 8 columns
    B←((⍴B)⌈(-⍴⍴B)↑8×⌈W÷8)↑B
    A←82 ⎕DR A ⋄ B←82 ⎕DR B
    →L1 ⍝retry

L2: ⎕ERROR(1 2 3 5⍳T)⊃'RANK ERROR' 'WS FULL' 'VALUE ERROR' 'LENGTH ERROR' 'DOMAIN ERROR'
 
 :end

⍝ Copyright (c) 1988, 1989, 1994, 1995, 2000 by Jim Weigang