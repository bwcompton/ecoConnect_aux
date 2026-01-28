Z←TIMESTAMP
⍝Cover for ⎕TS, giving proper local system time in APL64
⍝B. Compton, 16 Feb 2024



 Z←⎕TS
 :if APL64
    Z[4 5]←LOCALTS
 :end