Z←R UNIFORM N
⍝Return ⍵ uniform random numbers between ⍺[1] and ⍺[2] (default = 0,1)

 ⍎(0=⎕NC'R')/'R←0 1'
 Z←R[1]+(R[2]-R[1])×(¯1+?N⍴1E6+1)÷1E6