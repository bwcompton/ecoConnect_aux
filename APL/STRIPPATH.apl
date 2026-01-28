Z←D STRIPPATH F
⍝Strip path from path\file ⍵ and return just the path; use default path ⍺
⍝Sort of the opposite of STRIP
⍝B. Compton, 27 Jul 2011

 Z←(⌽~^\⌽~F∊'\:')/F
 →((0≠⍴Z)∨0=⎕NC'D')/0
 Z←D