Z←POSTRUN;O;P
⍝Generate call to POST or REGIONALPOST, depending on [caps] regionalpost option
⍝B. Compton, 24 Sep 2012
⍝21 Mar 2014: call REGIONALPOST if regionalpost = yes
⍝15 Jun 2022: include columns for maxthreads and maxpernode



 O←''
 →(0=⎕NC'override_pars')/L1             ⍝If override_pars exists,
 override_pars NWRITE O←pathP,'temp\temp',(FRDBL 15 0⍕?1E5),'.tmp'
L1:P←(regionalpost+1) ⊃ 'POSTCALL' 'REGIONALPOSTCALL'
 Z←'wait' (P,' ''',O,''''),(2 2⍴⊂''),2 2⍴0