Z←APL64
⍝Returns 1 for 64 bit APL (version 2020+) or 0 for APL+Win
⍝B. Compton, 8 Feb 2024
⍝14 Feb 2024: debugging version - global apl64 takes precedence if set



 :if 0≠⎕NC'apl64'
    Z←apl64
 :else
    Z←⎕SYS[19]≥20220
 :end