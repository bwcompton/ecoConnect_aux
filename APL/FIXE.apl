Z←FIXE X
⍝Fix scientific notation

 Z←(X≠'+')/('/e/E')TEXTREPL X  ⍝Compatible scientific notation