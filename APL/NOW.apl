Z←NOW;M;N
⍝Returns current date and time

M← 12 3 ⍴'JanFebMarAprMayJunJulAugSepOctNovDec'
N←1 6⍴6↑TIMESTAMP     ⍝Use 4 digit year
⍝N←⍉(6⍴100)⊤⍉,100⊥100∣6↑TIMESTAMP
Z←(2 0 ⍕N[;,3]),' ',M[N[;2];],' ',('ZI4' ⎕FMT N[;,1]),','
⍝Z←FRDBL,Z,' ',(2 0 ⍕1+12∣N[;,4]-1),':',('ZI2' ⎕FMT N[;,5]),' ','ap'[1+N[;,4]≥12],'m' ⍝Minutes
Z←FRDBL,Z,' ',(2 0 ⍕1+12∣N[;,4]-1),':',('ZI2' ⎕FMT N[;,5]),':',('ZI2' ⎕FMT N[;,6]),' ','ap'[1+N[;,4]≥12],'m' ⍝Seconds
⍝Z←FRDBL,Z,' ',(2 0 ⍕1+12∣N[;,4]-1),':',('ZI2' ⎕FMT N[;,5]),':',('ZI2' ⎕FMT N[;,6]),'.',('ZI3' ⎕FMT TIMESTAMP[7]),' ','ap'[1+N[;,4]≥12],'m' ⍝Milliseconds

⍝Z←(DAYINWEEK TIMESTAMP[2 3 1]),', ',DEB Z
Z←DEB Z