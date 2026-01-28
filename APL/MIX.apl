Z←MIX X
⍝Do ↑ for uneven-length strings
⍝31 Mar 2009: preserve blank rows
⍝8 Sep 2010: pass through unnested arguments


 Z←0 0⍴'' ⋄ →(0∊⍴X)/0
 →(1≥≡Z←X)/0
 Z←VTOM ('.⍫.',⎕TCNL) TEXTREPL ⊃,/'⍫',¨X