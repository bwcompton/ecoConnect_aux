Z←N GETCACHEPATH X
⍝Return path to grid ⍵'s cache index file (or hash index ⍵, if numeric); if ⍺, just return numeric hash
⍝Uses kind of stupid algorithm now; we might update it some day
⍝B. Compton, 16 May 2016



 ⍎(0=⎕NC'N')/'N←0'
 :if 0≠1↑0⍴Z←X                          ⍝If argument is non-numeric,
    Z←1+cache[5]∣+/¯1+⎕AV⍳(TOUPPER X)   ⍝   get hash
 :end
 :if ~N                                 ⍝If returning path,
    Z←(2⊃cache),'index\',(⍕Z),'.txt'
 :end