Z←N MAKENAMES S;A;I;G;T;M;J;C
⍝Create file names from existing result, settings, or source names ⍺ and scenario names ⍵
⍝If scenario ends in '\', prepend it to ⍺
⍝If scenario begins in '-', postpend it to ⍺
⍝Otherwise, replace ⍺ with scenario
⍝If one or more grid names (space-separated) are included in brackets, scenario only applies to these grids,
⍝e.g., [d8accum flow]-_s1t10 would do this to grids d8accum, flow, and slope: d8accum_s1t10, flow_s1t10, slope.
⍝If futuregrids exists, grids with that name go into futurepath (modified for SCENARIODELTAS with searise and climate for DSL)
⍝   future grids don't get prefix/postfix
⍝B. Compton, 20 Jan 2009 [Obama inaugurated as president!]
⍝14 Sep 2011: Add grid names in brackets
⍝21 Apr 2017: futuregrids are in futurepath



 Z←(⍴S)⍴⊂''
 →(0∊⍴N)/0                          ⍝Bail if no grid names

 Z←N
 ⍎(2>≡N)/'N←,⊂N'                    ⍝Enclose ⍺ if necessary
 →(0∊⍴S)/0                          ⍝If there are scenario names,
 G←TOLOWER¨FRDBL¨¨↓¨MATRIFY¨1↓¨¯1↓¨(T←(⊃,/'['=1↑¨S)×S⍳¨']')↑¨S  ⍝   Pull out bracketed names
 S←T↓¨S
 A←⊃,/(0=⍴¨S)+('\'=¯1↑¨S)+2×'-'=1↑¨S⍝   1 if prepend, 2 if postpend, 0 if replace
 S←(A=2)↓¨S                         ⍝Drop leading dash (use two if you want one)
 Z←(1↑⍴S)⍴0
 I←0
L1:→((1↑⍴S)<I←I+1)/0                ⍝For each scenario,
 Z[I]←⊂M←N
 J←(((TOLOWER¨STRIP¨N)∊I⊃G)∨0∊⍴I⊃G)/⍳⍴M     ⍝   Grids subject to change
 →(0∊⍴J)/L1

 :if 0≠⎕NC 'futuregrids'            ⍝   if there are any futuregrids, they go into futurepath
    C←(TOUPPER STRIP¨N[J])∊FRDBL¨↓MATRIFY TOUPPER futuregrids
    M[C/J]←(⊂futurepath) PATH¨C/N[J]
 :else
    C←(⍴N[J])⍴0
 :end

 M[(~C)/J]←((A[I]=1)/¨S[I]),¨((A[I]≠0)/¨N[(~C)/J]),¨(A[I]≠1)/¨S[I]
 Z[I]←⊂M
 →L1