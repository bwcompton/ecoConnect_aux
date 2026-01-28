Z←NUM X
⍝Convert string ⍵ to a number (unless it already is one)
⍝B. Compton, 18 Jun 2013
⍝8 Jun 2021: convert , to space, so it can act as a separator
⍝20 Feb 2024: and work for a scalar, duh!



 →(0=1↑0⍴Z←X)/0
 Z←⎕FI '.,. ' TEXTREPL ,X