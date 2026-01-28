Z←UNPARSEDATE N;M
⍝Converts ⎕TS-style date to NOW-style date
⍝B. Compton, 3 Sep 2013, from NOW



Z←'' ⋄ →(N≡0)/0
N←1 6⍴6↑N
M← 12 3 ⍴'JanFebMarAprMayJunJulAugSepOctNovDec'
Z←(2 0 ⍕N[;,3]),' ',M[N[;2];],' ',('ZI4' ⎕FMT N[;,1]),','
Z←FRDBL,Z,' ',(2 0 ⍕1+12∣N[;,4]-1),':',('ZI2' ⎕FMT N[;,5]),':',('ZI2' ⎕FMT N[;,6]),' ','ap'[1+N[;,4]≥12],'m' ⍝Seconds
Z←DEB Z