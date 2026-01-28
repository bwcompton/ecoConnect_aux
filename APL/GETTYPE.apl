Z←GETTYPE F;T;Q
⍝Reads type of metric function ⍵
⍝Each metric must have a label 'type:' with watershed, standard, table, or exclusive
⍝Types must be one word
⍝Current types:
⍝   standard    Standard metric, run in blocks with BLOCKRUN
⍝   watershed   Watershed metric, run with WATERSHEDRUN
⍝   exclusive   Exclusive metric--this must be the only one run (it's a standard block metric)
⍝B. Compton, 17 and 25 Aug 2009


 T←(Q←(∨\T ⎕SS 'type:')/T←⎕VR TOUPPER F)⍳⎕TCNL
 →(0∊⍴Z←Q)/0
 Z←¯1↓5↓T↑Q
 Z←TOLOWER FRDBL(Z⍳' ')↑Z