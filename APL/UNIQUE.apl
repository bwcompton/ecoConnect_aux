Z←UNIQUE X
⍝Return unique elements of vector ⍵
⍝Far, far faster than ((X⍳X)=⍳⍴X)/X for large vectors
⍝B. Compton, 8 Sep 2014
⍝2 Mar 2022: work for character vectors too



 →(0∊⍴Z←X←,X)/0
 :if ' '=1↑0⍴⊃X             ⍝If 1st element is character (won't work for mixed vectors),
    X←X[⎕AV⍋MIX X]
    Z←(~X≡¨(⊂'⌹⌹⌹⍬⍬⍬%%%'), ¯1↓X)/X
 :else                      ⍝Else, numeric
    X←X[⍋X]
    Z←(X≠(X[1]+1),¯1↓X)/X
 :end