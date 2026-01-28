Z←MASKGROUP G;M;I
⍝Return maskbits group for metric ⍵, or 0 if not in a group
⍝See MASKBITS for more info
⍝B. Compton, 21-22 Aug 2012



 →((0∊⍴maskbits)∨0∊⍴mask)/Z←0                               ⍝If maskbits has been set and we're using a mask,
 M←0 0 TABLE pathI PATH maskbits,(~'.'∊maskbits)/'.txt'     ⍝   Read maskbits table
 →((M≡1 1⍴MV)∨(0∊⍴M)∨M≡MV)/0                                ⍝   If anything in table,
 I←(TOUPPER MIX M[;1]) MATIOTA TOUPPER G                    ⍝      and look it up in table
 →(I=0)/0                                                   ⍝      if not in table, we'll use entire mask
 Z←M[I;2]                                                   ⍝      Return mask group for this metric