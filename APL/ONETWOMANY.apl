Z←A ONETWOMANY X
⍝Format nested character vector ⍵ as a pretty list: one, two, and three
⍝If more than ⍺[1] elements, return 2⊃⍺
⍝B. Compton, 17 Aug 2012
⍝17 Jan 2014: don't fail for 0/⊂''



 ⍎(0∊⎕NC'A')/'A←1E6 '''''
 Z←'' ⋄ →(0∊⍴X)/0                       ⍝If no elements, return ''
 X←(0≠⊃,/⍴¨X)/X                         ⍝Remove empty elements
 →(0∊⍴X)/0                              ⍝Check again
 Z←2⊃A ⋄ →(A[1]<⍴X←FRDBL¨X)/0           ⍝If lots of elements, return ⍺[2]


 :if 1=⍴X                               ⍝If one element, return one
    Z←⊃X
 :elseif 2=⍴X                           ⍝If two elements, return one and two
    Z←(1⊃X),' and ',2⊃X
 :else
    Z←(⊃,/(¯1↓X),¨⊂', '),'and ',(⍴X)⊃X  ⍝if three or more elements, return one, two, and three
 :endif