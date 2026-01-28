Z←P SUBNAME X;T
⍝Replace filename in ⍵ using substitution in inputs.par with default path ⍺
⍝Use path from (1) inputs.par, or (2) supplied path, or (3) ⍺
⍝B. Compton, 27 Jul 2011
⍝2 Aug 2013: make sure path comes through
⍝3 Jun 2014: return empty name if inputs.par converts a name to empty; 19 Jun 2014: do it right



 →(1≥≡X)/L1         ⍝If nested,
 ⍎(1≥≡P)/'P←⊂P'
 Z←P SUBNAME¨X      ⍝   recurse
 →0                 ⍝else,
L1:Z←(~0∊⍴T)/(P STRIPPATH P PATH X) PATH T←GRIDNAME STRIP X