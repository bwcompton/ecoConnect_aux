Z←BRACECASE X;I;N;Q
⍝Apply brace-drive CASE statements to text matrix ⍵
⍝Designed for use with READPARS in CAPS, to allow switching among multiple parameter sets
⍝Example:
⍝   {use name2}
⍝   {name1
⍝   ...
⍝   }
⍝   {name2
⍝   ...
⍝   }
⍝   {name3
⍝   ...
⍝   }
⍝would return the lines after name2, up to the next close brace. Names can be any name. You can
⍝have multiple blocks sharing a name; they'll all be selected.
⍝The 'use' name can come from a defined varible, like this:
⍝   {use $variable_name}
⍝   ...
⍝Don't put any braces in comments or quoted text, or you'll be sorry!
⍝B. Compton, 13 Dec 2019 (it's a Friday!)
⍝29 Apr 2022: add $variable (1st of NOLA Jazz Fest, after 3 long years)



 X←MTOV X
 I←X⍳'{}'                                   ⍝Look for braces
 →(I>[1]⍴X)/L3                              ⍝If found,
 N←TOLOWER FRDBL(MATRIFY X[I[1]↓⍳I[2]-1])[2;]    ⍝   Use name
 :if '$'=N[1]                               ⍝   If $variable,
    N←⍎1↓N                                  ⍝      use variable in workspace
 :end
 X[(I[1]-1)↓⍳I[2]]←' '                      ⍝   Erase name block

L1:I←((TOLOWER X) ⎕SS '{',N)⍳1              ⍝   Find named block
 →(I>[1]⍴X)/L2                              ⍝   If found,
 I←I,(I↓X)⍳⎕TCNL,'}'                        ⍝      and end of tag and end of named block
 Q←I[2]↓X[I[1]↓⍳¯1++/I[1 3]]                ⍝      This is our selected block
 X←((I[1]-2)↑X),Q,(+/I[1 3])↓X              ⍝      Replace brace-block with selected block
 →L1                                        ⍝   Repeat

L2:I←X⍳'{}'                                 ⍝   Now find any leftover stuff in braces
 →(I[1]>⍴X)/L3                              ⍝   If found,
 X←((I[1]-1)↑X),I[2]↓X                      ⍝      drop it and have another go
 →L2

L3:Z←VTOM ⎕TCNL,X