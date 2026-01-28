Z←RECOVERY E;T
⍝Wait for crashed grid servers to be recovered; return 1 if need to try again
⍝Note: must localize firstfail in calling function
⍝Call like this: →(RECOVERY err)/L3, where label is gridio function
⍝B. Compton, 13 Nov 2013
⍝19 Nov 2013: units, units, units!



 Z←0
 :if E∊¯625 ¯631                            ⍝If grid server isn't responding,
    →(0=⎕NC 'maxrecovery')/0                   ⍝   and maxrecovery exists,
    →(maxrecovery=0)/0                         ⍝   and isn't 0,
    :if 0=⎕NC 'firstfail'                      ⍝   if this is first failure,
       firstfail←⎕AI[2]                        ⍝      start timer
       ⎕←'Grid server unavailable...waiting for recovery (',NOW,')...' ⋄ FLUSH
    :end
    →(⎕AI[2]≥firstfail+maxrecovery×60)/0       ⍝   if we've waited too long, throw error
    T←⎕DL 60                                   ⍝   wait 1 minute
    DOT
    Z←1
    →0                                         ⍝   and try again
 :else
    :if 0≠⎕NC 'firstfail'                      ⍝If there was a previous failure,
        ⎕←'Grid server recovered (',NOW,')' ⋄ FLUSH
    :end
 :end