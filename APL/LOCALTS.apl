Z←LOCALTS;T;Q
⍝Return local timestamp
⍝Compensate for stupid design decision in APL64 to provide UTC but not local time
⍝B. Compton, 16 Feb 2024



 3 ⎕CMD 'time /t > ',Q←'c:\temp\zzlocaltime',(FRDBL 15 0⍕?1E15),'.tmp'
 Z←((12×T[7]='P')+NUM T[1 2]),NUM (T←NREAD Q)[4 5]
 NDROP Q