Z←E PARSESUBTASK S;Q;scram
⍝Expand subtasks ⍵, suppress too many subtasks error if ⍺
⍝   Subtask list begins with one of:
⍝   range:      range of numbers, including commas and colons to indicate ranges
⍝   file:       path to text file with subtask data, one per line
⍝   function:   function that evaluates to a matrix of subtasks
⍝Global: scramblesubtasks - if 1, scramble 'em
⍝Unless '!' is included in keyword, e.g., range!:1:10 doesn't scramble subtasks no matter what
⍝B. Compton, 14 Apr 2011
⍝18-20 Dec 2012: range returns start and count
⍝14 Nov 2013: add scramblesubtasks
⍝7 Apr 2014: add ! option to prevent subtasks from being scrambled (it's okay to have 2 !!s)
⍝19 May 2014: don't look at cluster stuff (maxsubtasks, scramblesubtasks) if running in local mode; 27 May: but don't count on cluster existing!
⍝10 Jul 2014: suppress the maxsubtasks error if skiptilemap (meaning we're called from DEBUG or FINDTILE)
⍝5 Sep 2014: pass local scramble subtasks flag to BLOCKREPS via global variable scram
⍝22 Jun 2016: suppress too many subtasks error if ⍺ - needed for splitsubtasks; don't blow up when using range



 ⍎(0=⎕NC'E')/'E←0'
 →(S≡Z←'')/0
 scram←∨/S ⎕SS '!:'                     ⍝! present?
 S←'.!:.:.!!:.:' TEXTREPL S
 →(L1,L2,L3,L4)['range:' 'file:' 'function:'⍳⊂TOLOWER (Q←S⍳':')↑S]

L1:Z←(⍎'.:. COLON ' TEXTREPL Q↓(MATRIFY S)[1;]),[1.5]1
 →L5

L2:Z←NREAD Q↓S
 Z←(∨/Z≠' ')⌿Z←LJUST(⍴Z)↑(+/^\';'≠Z)⌽((⍴Z)⍴' '),Z←VTOM ⎕TCNL,('.',⎕TCHT,'. ') TEXTREPL Z      ⍝Semicolons mark comments
 →L5

L3:Z←⍎Q↓S
 Z←⍕(2↑(⍴Z),1)⍴Z
 →L5

L4:⎕ERROR 'Unrecognized tag in subtask: ',S

L5:→(0=⎕NC'maxsubtasks')/L6         ⍝If running in cluster mode,
 :if 0≠⎕NC'skiptilemap'
    →skiptilemap/L6                 ⍝   if skipping tile map, ignore maxsubtasks
 :end
 ⎕ERROR ((~E)^maxsubtasks<1↑⍴Z)/'More than ',(⍕maxsubtasks),' subtasks (n = ',(⍕1↑⍴Z),') in task'
L6:→(scram∨0=⎕NC'scramblesubtasks')/0⍝If scrambling subtasks,
 →(~scramblesubtasks)/0
 Z←Z[(1↑⍴Z)?1↑⍴Z;]                  ⍝   then do it!