Z←LOCKFILE X;E;T
⍝Get a lock on ⍵ and return data for UNLOCKFILE, but only if running on cluster
⍝Returns (lock name) (⎕ELX)
⍝Just a simplified cover for GETLOCK; deals with ⎕ELX
⍝WARNING: if nesting locks, errors when debugging can leave you without 1st lock!!
⍝B. Compton, 31 Dec 2013
⍝9 Jan 2014: reasonable ⎕ELX if not doing a cluster run
⍝31 May 2016: do errors right for nested locks



 Z←(⍳0) ⎕ELX
 →(0=⎕NC'cluster')/0
 →(~cluster)/0
 T←X GETLOCK 0
 :if 1∊(E←⎕ELX) ⎕SS '⎕ELX'                  ⍝If nested locks,
    ⎕ELX←'RETURNLOCK ''',X,''' ⋄ ',E
 :else                                      ⍝Else,
    ⎕ELX←'RETURNLOCK ''',X,''' ⋄ ⎕ELX←''',E,''' ⋄ ',E
 :end
 Z ← X E                                    ⍝Return lock name and original ⎕ELX