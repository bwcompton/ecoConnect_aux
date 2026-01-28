Z←P SUBNAMER X;T
⍝Replace filename in ⍵ using substitution in results.par with default path ⍺
⍝Use path from (1) inputs.par, or (2) supplied path, or (3) ⍺
⍝B. Compton, 6 Jan 2011, from SUBNAME; this version from results.par; 20 Jan 2012: oops; 19 Jun 2014: do it right



 →(1≥≡X)/L1         ⍝If nested,
 ⍎(1≥≡P)/'P←⊂P'
 Z←P SUBNAMER¨X      ⍝   recurse
 →0                 ⍝else,
L1:Z←(~0∊⍴T)/(P STRIPPATH X) PATH T←0 resultspar GRIDNAME STRIP X