Z←REPSRUN X;P;M;S;R;O;U;G;H;head;I;J;F;T;W;K;Y;E;B;N;futuregrids;futurepath
⍝Fill out calls with reps for BLOCKRUN, TABLERUN, and WATERSHEDRUN
⍝Arguments ⍵:
⍝   P   systems, (block size or table rows), reps file
⍝   M   metric name
⍝   S   source grids
⍝   E   settings table name
⍝   R   result grids
⍝   B   buffer size
⍝   O   override pars
⍝   N   include grid
⍝Results:
⍝   Z   call
⍝   U   result grids
⍝B. Compton, 5 and 14 Mar 2013
⍝Note: not sure if this will take care of settings variables, though I think so
⍝16 May 2013: work if there are no variables set; I forgot include grid before
⍝10 Apr 2014: make sure _m substitution happens in the end



 P M S E R B O N ← X
 G←(⊂,''),1 TABLE 3⊃P                                       ⍝Read reps file
 H←',' MATRIFY head
 I←1+H MATIOTA MATRIFY 'input settings results'
 J←(⍳1↑⍴H)~H MATIOTA MATRIFY 'input settings results'       ⍝Variables to set from reps file
 F←T,¨G,¨T←FRDBL¨' '''''[1+(⍴G)⍴~^⌿⊃¨⎕VI¨G]                 ⍝quote strings in reps file
 ⍎'allnames_',M,'←G[;1+H MATIOTA ''repname'']'              ⍝Special case: set allnames_METRIC to list of all repnames (if they exist) for use in init: in FINDPATHS
 Z←W←0 0⍴'' ⋄ U←''
 K←0
L1:→((1↑⍴G)<K←K+1)/L2                                       ⍝For each row in reps file,
 →(0∊⍴J)/L3                                                 ⍝   If any variables set,
 X←1↓⊃,/'⋄',¨(FRDBL¨↓H[J;]),¨'←',¨F[K;J+1]                  ⍝      Variables from reps file
 ⍎X
L3:Y←' ',⊃BUILDPAR¨GRIDNAME¨(pathG SUBNAME S) MAKENAMES G[K;I[1]]    ⍝   source grids
 Y←Y,' ',⊃BUILDPAR¨E MAKENAMES G[K;I[2]]                    ⍝   settings file
 Y←Y,' ',⊃BUILDPAR¨T←(⊂0 resultspar) GRIDNAME¨(pathR SUBNAMER R) MAKENAMES G[K;I[3]] ⍝   result grids
 U←U,⊃,/T
 Z←Z OVER Y
 →(0∊⍴J)/L1                                                 ⍝   If any variables set,
 W←W OVER '.⋄. & .←.=' TEXTREPL X                           ⍝      set variables
 →L1

L2:Z←(FRDBL¨↓Z),¨(⊂' ',⍕B),¨(⊂(~N≡0)/' ''',N,''' '),¨⊂' ',BUILDPAR P[1]  ⍝Build call
 Z←Z,¨⊂BUILDPAR O
 →(0∊⍴J)/L4                                                 ⍝   If any variables set,
 Z←Z,¨'''',¨((⊂'.''.''''') TEXTREPL¨FRDBL¨↓W),¨''''
L4:Z←Z U