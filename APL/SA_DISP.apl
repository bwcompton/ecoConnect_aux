SA_DISP X;N;Z

 Z←(' ',⎕AV[128])[1+1⊃X]
 ⍝Z←(⎕AV[1+99 103])[1+1⊃X]       ⍝Use webdings

 Z←Z OVER '' OVER 'Iteration #',⍕3⊃X
 Z←Z OVER 'Score = ',HITOLOW⍕2⊃X
⍝ Z←Z OVER 20⍴' '

 Z NWRITEe PATH 'sa.txt'