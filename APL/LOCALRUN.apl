LOCALRUN X;T;J;Y;⎕ALX;⎕SA;Q;warn;warnings;fn;null;I
⍝Run CAPS commands (and reps) ⍵ locally
⍝B. Compton, 23 May 2011, from RUN



 ⎕SA←''
 ⎕ALX←'STOP'
 null←⍳0
 SETPATHS
 →(IFEXISTS pathP)/L1           ⍝If parameter path doesn't exist yet,
 ⎕MKDIR ¯1↓pathP
L1:(pathP PATH 'caps.log') LOG '--- Starting CAPS run, ',NOW,' ---'
 SETBREAK
 warn←1
 warnings←0 0⍴''
 fn←'LOCALRUN'

 X←(~(⊂'wait')≡¨TOLOWER¨X[;1])⌿X⍝No need to mess with WAITs in local runs

 I←0
L2:→((1↑⍴X)<I←I+1)/L5           ⍝For each metric,
 Y←⊃X[I;1]                      ⍝   Command
 J←0
 →(0∊⍴X[I;2])/L3                ⍝   If need to expand reps,
 Y←PARSESUBTASK ⊃X[I;2]         ⍝      Expand them
 Y←MIX (⍕¨↓Y),¨' ',¨X[I;1]      ⍝      and make calls

L3:→((1↑⍴Y)<J←J+1)/L2           ⍝   For each metric or rep,
 BREAKCHECK
 T←Y[J;]
 →(Q←'.'=1⍴T)/L4                ⍝If first character of line is ., run silently
L4:⍎Q↓T
 →L3

L5:CAPSEND
 ∆CLEANUP