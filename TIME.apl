Z←TIME S
⍝Give hrs:min:sec from seconds ⍵
⍝B. Compton, 15 Apr 2011


 Z←1E6 60 60⊤S
 Z←(⍕Z[1]),':',(,'ZI2' ⎕FMT Z[2]),':',,'ZI2' ⎕FMT Z[3]
 
 convert and then paste