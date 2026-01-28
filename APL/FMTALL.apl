Z←FMTALL X
⍝Format ⍵ to 16 full digits
⍝B. Compton, 21 Nov 2013


 Z←(⊂', ,0,[.],0,[.,0.,[,,.],,],') TEXTREPL¨'[',¨(FRDBL¨(⊂'.0. ') TEXTREPL¨16⍕¨X),¨']'