A GRIDINIT S;P;port;M;O;W;C;E;D;R
⍝Initialize grid server on server and port ⍵, add = ⍺
⍝   ⍵[1]    refgrid
⍝   ⍵[2]    server ('' for local grid server)
⍝   ⍵[3]    port (optional; not needed for local server)
⍝   ⍵[4]    drive (optional)
⍝   ⍺       add - if 1, add to connection list; if 0, replace all connections
⍝B. Compton, 9-12 Sep 2013
⍝4 Oct 2013: add optional drive
⍝9 Nov 2021: new required 1st right arg: refgrid to add to connections, as part of TIFF revolution; 5 Jul 2022: oops--only took 3 elements
⍝10 Nov 2021: GETWINDOW no longer returns MV nor blockonly, so no need to truncate (part of TIFF revolution)



 ⍎(0=⎕NC'A')/'A←0'              ⍝Default is ADD = false
 ⍎(0=⍴S)/'S←S 0'
 R S P D ← 4↑S,0 0              ⍝Reference grid, server, port, and drive
 ⍎(D≡0)/'D←'''''
 M←1+0=⍴S                       ⍝Mode: 1 for remote, 2 for local
 :if ~A                         ⍝If add = false,
    CLEANUP                     ⍝   reset everything
 :end
 INITCONNECTIONS                ⍝create connection variables if they don't exist
 O←activeconnection             ⍝save activeconnection in case of errors
 ∆GRIDINIT S P serverlog        ⍝Initialize grid server
 :if M=1                        ⍝If remote,
    W←GETWINDOW                 ⍝   query server for current grid window
    W←W (0≠⍴W)                  ⍝   2nd element is 1 if window is set
 :else                          ⍝else, local,
    W←(⍳0) 0                    ⍝   window is not set
 :end
 C←(2⊃W),W[1],(M=2),(⊂S),P,serverlog,0,(⊂D),⊂R  ⍝New connection
 :if ~A                         ⍝If add is false,
    connections←(1,⍴C)⍴C        ⍝   add, replacing all connections with this one
    activeconnection[1]←1
 :else                          ⍝else, add is true,
    :if ~1⊃E←CHECKWINDOW W      ⍝   if the window is bad,
       SETCONNECTION O[1]       ⍝      set back to the old connection
       SETCACHE O[2]
       ACTIVATECONNECTION       ⍝      and reactivate it
       activeconnection←O[1]    ⍝      in case there is something pending
       ⎕ERROR 'Error: new connection can''t be added - ',2⊃E
    :end
    connections←connections⍪C   ⍝   add new connection
    activeconnection[1]←1↑⍴connections
 :end
 :if (0=⍴referencewindow)^0≠⍴1⊃W⍝If no reference window but this window is defined,
    referencewindow←1⊃W
    workingresolution←(1⊃W)[5]
 :end
 activeconnection[2]←0          ⍝Always turn caching off