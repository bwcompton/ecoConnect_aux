Z←GETMETRICS
⍝Read metrics.par and set global metrics to those we'll run
⍝Use override_metrics instead if it exists
⍝metrics.par/override_metrics contain 1:metric 2:run 3:groups 4:block 5:maxthreads 6:maxpernode 7:scenarios
⍝1st 4 columns are required
⍝B. Compton, 10 Sep 2010
⍝4 Dec 2014: behave nicely if no metrics.par
⍝10 Jun 2022: add task maxthreads and maxpernode



 →(0=⎕NC'override_metrics')/L1      ⍝If override_metrics,
 →(0∊⍴override_metrics)/L1
 Z←override_metrics                 ⍝   use it
 →L2
L1:Z←TABLE 'metrics'                ⍝Else, read metrics file
L2:
 :if Z≡1 1⍴MV
    Z←0 7⍴'' '' '' 0 '' 0 0
 :else
    Z←Z,(0,0⌈¯4+1↓⍴Z)↓((1↑⍴Z),3)⍴0 0 '' ⍝4 columns are required; pad to 7
    Z[;1 2 3 7]←FRDBL¨Z[;1 2 3 7]
    Z[;4 5 6]←0 MVREP Z[;4 5 6]
    Z←((⊃,/'@'=1↑¨LJUST¨Z[;1])∨(TOLOWER¨Z[;2])≡¨⊂'yes')⌿Z      ⍝Metrics to run
    Z←Z,0                               ⍝1 if resistance table (used in FRISK)
    Z[;3]←(⊂'.*.#') TEXTREPL¨Z[;3]      ⍝Use # for all systems so CLUSTER doesn't snag it and change it
 :end