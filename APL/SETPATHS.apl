SETPATHS;P;I;X;L;K;Q;T
⍝Read ⍵\paths.par and set paths accordingly
⍝3 Sep 2010: Set default paths for those not in paths.par
⍝8 Feb 2011: Get root directory from pathdir if supplied
⍝23 Jan 2012: change the way pathdir works--it only affects paths.par, not the root path (use 'path' for that)



 ⍎(0=⎕NC'pathdir')/'pathdir←''paths.par'''
 P←path PATH pathdir
 K←MATRIFY 'model metrics run grids results working software post deltas source tables rawsettings mixedsettings CLII FTP hydro'
 L←MATRIFY 'pathI pathM pathP pathG pathR pathW pathA pathE pathD pathS pathT pathU pathN pathQ pathF pathH'
 →(IFEXISTS P)/L0
 ⎕ERROR '*** Error: CAPS path',((IFEXISTS ((1+-(⌽P)⍳'\')↓P))/'s file'),' ',P,' does not exist.'
L0:X←(0,',',1) MATIN P
 X←(0≠⊃,/(⍴¨X)[;1])⌿X
 ⎕ERROR (~0∊⍴Q)/'*** Error: Unknown paths in ',P,':',⍕Q←(0=(TOUPPER K) MATIOTA MIX TOUPPER X[;1])⌿X[;1]

 T←⍎¨(↓L),¨'←',¨'''',¨((⊂path),¨FRDBL¨↓K),¨⊂'\'''     ⍝Set default paths

 I←0
L1:→((1↑⍴X)<I←I+1)/0        ⍝For each path,
 ⍎L[(TOUPPER K) MATIOTA TOUPPER⊃X[I;1];],'←''',(path PATH ⊃X[I;2]),''''
 →L1