Z←PATHSDOTPAR;P;Q
⍝Return the contents of paths.par
⍝B. Compton, 20 Jan 2012


 Q←'paths.par'
 ⍎(0≠⎕NC'pathdir')/'Q←pathdir'
 P←path PATH Q
 Z←NREAD P