MAKEWINDOW X;Q;T
⍝Sets grid access window to values ⍵ and set gridwindow
⍝⍵ = cols, rows, xll, yll, cellsize
⍝Returns blockonly (1 if no caching)
⍝B. Compton, 10-12 Sep 2013 (from SETWINDOW)


10 NOV 2021: THIS FUNCTION IS OBSOLETE, AS IT DOES NOT WORK IN THE NEW GEOTIFF GRID SERVER.


 ⎕ERROR (0=⎕NC 'connections')/'No connections have been set'
 ⎕ERROR (activeconnection[1]∊0,MV)/'There is no active connection'
 ⎕ERROR (connections[activeconnection[1];connections_ COL 'set'])/'The access window for the active connection is already set'
 T←∆MAKEWINDOW X            ⍝Make new window
 Q←CHECKWINDOW gridwindow 1 ⍝Check it
 :if 0=1⊃Q                  ⍝If window does't check out,
    ∆CLEANUP
    ∆GRIDINIT connections[activeconnection[1];connections_ COL 'server port log']
    ⎕ERROR 'New window doesn''t align with prior windows'
 :end
 connections[activeconnection[1];connections_ COL 'window']←⊂gridwindow
 :if 0∊⍴referencewindow
    referencewindow←5↑gridwindow
    workingcellsize←CELLSIZE
 :end