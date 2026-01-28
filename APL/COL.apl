Z←X COL N
⍝Return column numbers of ⍵ in list ⍺
⍝Use to index table columns
⍝B. Compton, 13 Apr 2011


 ⍎(2>≡X)/'X←FRDBL¨↓MATRIFY X'
 ⍎(2>≡N)/'N←FRDBL¨↓MATRIFY N'
 Z←(Z≤⍴X)×Z←(FRDBL¨TOUPPER¨X)⍳FRDBL¨TOUPPER N
 ⍎((,1)≡⍴Z)/'Z←⍬⍴Z'