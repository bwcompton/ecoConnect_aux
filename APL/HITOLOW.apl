 Z←HITOLOW M
 ⍝Converts high minus signs (¯) in ⍵ to low minus signs (-)
 Z←(⍴M)⍴'/¯/-'TEXTREPL,M