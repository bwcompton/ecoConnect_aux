Z←STRIPDRIVE F
⍝Return just the drive of path ⍵
⍝B. Compton, 7 Oct 2013



 :if ':'∊F←FRDBL F                  ⍝If drive: ...
    Z←(F⍳':')↑F                     ⍝   return drive:
 :elseif ^/'\'=2↑F                  ⍝else, if \\computer\...
    Z←(-'\'=¯1↑Z)↓Z←((2↓F)⍳'\')↑2↓F ⍝   return \\computer\
 :else                              ⍝otherwise,
    Z←''                            ⍝   no drive
 :end