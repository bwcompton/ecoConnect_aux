SETTILE;T
⍝Set block so THISBLOCK gives correct READ/WRITE coordinates
⍝block must have already been set, presumably in BLOCKCALL
⍝A better alternative to the old noread/READ nonsense
⍝B. Compton, 22 Jan 2014
⍝19 Apr 2022: don't mess with ifchat (now chatter)



 ffile←''
 T←THISBLOCK