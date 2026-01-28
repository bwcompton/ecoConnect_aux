Z←C READGRID G;H
⍝Read grid ⍵; disable caching if ⍺
⍝This version is just a cover for READBLOCK
⍝B. Compton, 1 Nov 2013 (old version → ∆READGRID)
⍝8 Dec 2013: suppress cacing in GRIDDESCRIBE too



 ⍎(0=⎕NC'C')/'C←0'
 H←(0 0,C) GRIDDESCRIBE G
 Z←H READBLOCK (⊂G),(1 1,H[2 1]),0,C