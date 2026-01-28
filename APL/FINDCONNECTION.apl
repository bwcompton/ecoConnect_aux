Z←C FINDCONNECTION W;D;E;I;P;Q
⍝Find the connection (in ⍺, default is global connections) matching window or pane 1⊃⍵ on optional path 2⊃⍵; return multiple connections if 2⊃⍵ is 1
⍝⍵ is either a window: ncol, nrow, xll, yll, cellsize
⍝         or a pane: -paneno
⍝If passing in connections, global header connections_ is still used
⍝Result is matched connection number or MV if no matches.
⍝Multiple matches are resolved by checking to see if the drive
⍝associated with one of the connections matches the path or,
⍝failing that, by returning the first matching connection.
⍝B. Compton, 4 and 7 Oct 2013. The government is still shut down.
⍝14-18 Nov 2014: Add pane argument to look for a particular pane; strip just the drive letter from path; return MV, not 0 if no matches
⍝3 Feb 2015: allow passing in connection list
⍝4 Aug 2017: if 2⊃⍵ is 1, return multiple connections per pane (used when called from MOSAICINIT when a run uses mosaics on multiple computers) + wrong if no matching drive



 ⍎(0=⎕NC'C')/'C←connections'
 ⍎(1≥≡W)/'W←W '''''
 W P ← W

 D←E←(1↑⍴C)⍴0                                           ⍝Bit vectors for drive matches and extent matches
 :if 0>1↑W                                              ⍝If looking for a pane,
    ⎕ERROR (~(∣W)∊C[;connections_ COL 'pane'])/'Error: pane ',(⍕∣W),' isn''t in connections!'
    E←(∣W)=C[;connections_ COL 'pane']                  ⍝   Find pane(s)
 :else                                                  ⍝Else, looking for a window
    E←(⊂5↑W)≡¨5↑¨C[;connections_ COL 'window']          ⍝   Matching extents
 :end
 Z←MV ⋄ →(~∨/E)/0                                       ⍝If no matching extents, return MV
 :if P≡1                                                ⍝If asking for multiple connections,
   Z←E/⍳⍴E                                              ⍝   don't look for best match; return them all
   →0
 :end
 Z←''⍴E/⍳⍴E ⋄ →((1=+/E)∨P≡'')/0                         ⍝If only 1 match or no path specified, return 1st connection
 D←C[;connections_ COL 'drive'] FIND STRIPDRIVE P       ⍝More than one extent matches, so do best match based on drive
 →((⍴D)≥Z←(D^E)⍳1)/0                                    ⍝If one or more matches for extent and drive, return the first
⍝  Q←E∨D∨0∊¨⍴¨C[;connections_ COL 'drive']    OLD AND WRONG            ⍝If no matches with drive, accept one undefined drive
 Q←E^0∊¨⍴¨C[;connections_ COL 'drive']                  ⍝If no matches with drive, accept one undefined drive
 →((⍴Q)≥Z←Q⍳1)/0
 Z←E⍳1                                                  ⍝Final fallback is to take first extent that matches





 →0
⍝Test code:

⍝ CLEANUP
⍝ GRIDINIT 'glyptemys' 3339 'C:'
⍝ MAKEWINDOW 15 12 0 0 10
⍝ 1 GRIDINIT 'glyptemys' 3338 'D:'
⍝ MAKEWINDOW 8 6 0 0 20
⍝ 1 GRIDINIT 'glyptemys' 3337 'D:'
⍝ MAKEWINDOW 15 12 0 0 10
⍝ 1 GRIDINIT 'glyptemys' 3336
⍝ FINDCONNECTION 15 12 0 0 30
⍝
⍝
⍝ CLEANUP ⋄ GRIDINIT 'glyptemys' 3339 'C:' ⋄ MAKEWINDOW 15 12 0 0 10 ⋄ 1 GRIDINIT 'glyptemys' 3338 'D:' ⋄ MAKEWINDOW 8 6 0 0 20 ⋄ 1 GRIDINIT 'glyptemys' 3337 'D:' ⋄ MAKEWINDOW 15 12 0 0 10 ⋄ 1 GRIDINIT 'glyptemys' 3336 ⋄ FINDCONNECTION 15 12 0 0 30