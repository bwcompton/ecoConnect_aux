Z←FINDSERVER W;P;S;S_;U;V;D;Y;L;B;C;head
⍝Find a grid server in gridservers.txt that matches window (and optional path) ⍵ and return server and port or 0 if no match
⍝B. Compton, 4 Nov 2013
⍝19 Nov 2013: read gridservers.txt with GETTABLE
⍝11 Nov 2021: drop entries in gridservers.txt that don't match global tiff setting (part of TIFF revolution)



 ⍎(1≥≡W)/'W←W '''''
 W P ← W

 S S_ ← GETTABLE pathA,'gridservers.txt'
 S←(S[;S_ COL 'active']^S[;S_ COL 'tiff']=tiff)⌿S   ⍝Drop the inactive servers and those for the other grid type (grid vs tiff)

 D←S[;S_ COL 'drive']                               ⍝drives,
 Y←S[;S_ COL 'ncol nrow xll yll cellsize']          ⍝and windows

 B←(↓Y)≡¨⊂5↑W                                       ⍝Grid servers that match our window
 C←D FIND STRIPDRIVE P                              ⍝and drive
 B←B^C∨~∨/B^C                                       ⍝match window and drive if possible
 Z←⍳0
 →(^/~B)/0                                          ⍝If we've got our match,
 Z←S[B⍳1;S_ COL 'server port']                      ⍝return server and port