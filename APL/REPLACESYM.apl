Z←REPLACESYM X
⍝Replace standard mathematical symbols with APL functions
⍝Note: use POWER so multiple calls don't lead to ^ → * → ×
⍝B. Compton, 13 Oct 2011 (consolidated from RUN, READPARS, etc.)



 Z←LOWTOHIX ('∣=∣←∣*∣×∣/∣÷∣^∣ POWER ∣',⎕TCHT,'∣ ') TEXTREPL X