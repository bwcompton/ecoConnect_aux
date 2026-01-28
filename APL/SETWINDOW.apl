S SETWINDOW G;Q;T
⍝Sets grid access window to grid ⍵; ignore window already set if ⍺
⍝Sets gridwindow to cols, rows, xll, yll, cellsize
⍝B. Compton, 10-12 Sep 2013
⍝5 Nov 2013: also work with grids
⍝3 Jan 2014: use MOSAICINFO instead of GRIDDESCRIBE to test for mosaics; 6 Jan: do it right
⍝10 Nov 2021: use ∆SETWINDOW (to active connection) instead of ∆MAKEWINDOW; ∆SETWINDOW no longer returns MV and blockonly, so no need to 
⍝             truncate gridwindow (part of TIFF revolution)



 ⍎(0=⎕NC'S')/'S←0'
 ⎕ERROR (0=⎕NC 'connections')/'No connections have been set'
 ⎕ERROR (activeconnection[1]∊0,MV)/'There is no active connection'
 ⎕ERROR (connections[activeconnection[1];connections_ COL 'set']^~S)/'The access window for the active connection is already set'
 :if ~(2⍴⊂⍳0)≡Q←MOSAICINFO G                    ⍝If grid is a mosaic,
    S ∆SETWINDOW ⊃connections[activeconnection[1];connections_ COL 'refgrid']    
 :else                                          ⍝else, it's a grid,
    S ∆SETWINDOW G                              ⍝   Set new window
 :end
 Q←CHECKWINDOW gridwindow 1                     ⍝Check it
 :if 0=1⊃Q                                      ⍝If window does't check out,
    ∆CLEANUP
    ∆GRIDINIT connections[activeconnection[1];connections_ COL 'server port log']
    ⎕ERROR 'New window doesn''t align with prior windows: ',2⊃Q
 :end
 connections[activeconnection[1];connections_ COL 'window']←⊂gridwindow
 :if 0∊⍴referencewindow
    referencewindow←gridwindow
    workingcellsize←CELLSIZE
 :end