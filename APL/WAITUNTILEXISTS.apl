Z←D WAITUNTILEXISTS F;N;⎕ELX;⎕DM;A;T
⍝Wait until file or path ⍵ exists with timeout of ⍺ seconds; return success flag
⍝B. Compton, 3 Apr 2014



 ⍎(0=⎕NC'D')/'D←1E6'            ⍝Default: wait almost forever
 A←⎕AI[2]+D                     ⍝Timeout mark

L1:→(Z←IFEXISTS F)/0            ⍝If it doesn't exist,
 T←⎕DL 0.1                      ⍝   Wait 1/10 sec
 →(A>⎕AI[2])/L1                 ⍝   If we haven't timed out, try again