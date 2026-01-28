INITCONNECTIONS
⍝Create connection variables if they don't exist
⍝B. Compton, 12 Sep 2013
⍝11 Apr 2014: don't clear good referencewindow
⍝9 Nov 2021: include column for refgrid (part of TIFF revolution)



 :if 0=⎕NC'connections'         ⍝If connection variables don't yet exist, create them
    connections_←FRDBL¨↓MATRIFY 'set window local server port log pane drive refgrid'
    connections←(0,⍴connections_)⍴0
    activeconnection←4⍴MV
    workingresolution←0
    :if 0=⎕NC'referencewindow'
       referencewindow←⍳0
    :end
 :end