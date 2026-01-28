M WARN Q;F
⍝Add warning ⍺ to warnings if ⍵ is not empty

 →(0∊⍴Q)/0
 ⍎(0=⎕NC'M')/'M←'''''
 F←'' ⋄ ⍎(0≠⎕NC'fn')/'F←''['',fn,''] '''
 Q←(F,M) OVER ' ',' ',' ',⍕Q
 Q←((-^/Q[2;]=' '),0)↓Q
 ⍎(0=⎕NC'warnings')/'warnings←0 0⍴'''''
 warnings←warnings OVER Q