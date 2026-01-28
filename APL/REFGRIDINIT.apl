A REFGRIDINIT X
⍝Initialize gridserver and set window. ⍵ = refgrid server [port] [drive]; ⍺ = [add [ignore]]
⍝   ⍵[1]    refgrid
⍝   ⍵[2]    server ('' for local grid server)
⍝   ⍵[3]    port (not needed for local server)
⍝   ⍵[4]    drive (optional)
⍝   ⍺[1]    add - if 1, add to connection list; if 0, replace all connections. Default = 0.
⍝   ⍺[2]    ignore - ignore window already set. Default = 0.
⍝Initializes grid server; sets gridwindow to cols, rows, xll, yll, and cellsize; sets connections
⍝B. Compton, 9 Nov 2021. Combined call to GRIDINIT and SETWINDOW for TIFF revolution. 5 Jul 2022: refgrid was nested in SETWINDOW call.
 
 

 ⍎(0=⎕NC'A')/'A←0'
 A←2↑A

 A[1] GRIDINIT X
 A[2] SETWINDOW 1⊃X