UPDATE_GRIDSTATS G;Z
⍝Update statistics for TIFF ⍵
⍝This needs to be called before calling 1 GRIDDESCRIBE for any TIFF created in gridio
⍝It takes 2-3 sec for 10k cell tiles used in DSL. I'm calling it directly from GRIDDESCRIBE, 
⍝as this is the safest, though not fastest, option. It is called from 9 functions, never
⍝unnecessarily from inside of a loop.
⍝B. Compton, 29 Sep 2021



 Z←1 0 ∆GRIDDESCRIBE G