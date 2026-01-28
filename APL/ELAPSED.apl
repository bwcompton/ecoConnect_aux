Z←A ELAPSED B;D
⍝Give elapsed seconds between ⎕TS-formatted dates ⍵ and ⍺ in seconds
⍝Leap days may not work if elapsed time spans years
⍝B. Compton, 14 Apr 2011
⍝1 Sep 2011: work properly for end of month
⍝26 Jan 2012: return 0 if either ⍺ or ⍵ is 0
⍝10 Sep 2014: was wrong for years! Still misses leap days over many years, but so what.



 →(∨/A B≡¨Z←0)/0
 D←31 28 31 30 31 30 31 31 30 31 30 31      ⍝Days in month
 D[2]←D[2]+(A[1]÷4)=⌊A[1]÷4                 ⍝If end date is a leap year, February is longer
 A[2 3]←0,A[3]++/(A[2]-1)↑D                 ⍝Sum of days in previous months
 B[2 3]←0,B[3]++/(B[2]-1)↑D
 Z←.001×0 365 24 60 60 1000⊥1 0 1 1 1 1 1/A-B