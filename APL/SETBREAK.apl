SETBREAK
⍝Set up to check for break file
⍝Use RESTART to restart after break


 ⍎(0=⎕NC'break')/'break←0'
 →((0≠⍴break)^1<(+/(MTOV ⎕SI) ⎕SS ⎕TCNL,'RUN[')++/(MTOV ⎕SI) ⎕SS ⎕TCNL,'CAPS[')/0      ⍝If under ≤1 RUN or CAPS call or break is clear,
break←pathP PATH 'break'
⍝ 'To stop the current CAPS run, delete this file' NWRITE break←pathP PATH 'break'
⍝ LOG '[to stop run, delete ',break,']'