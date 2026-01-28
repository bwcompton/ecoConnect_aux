Z←K WATERSHEDRUN W;N;C;Q;block;noread;Z;I;B;L;G;V;R;S;E;J;T;U;M;O;head;futuregrids;futurepath
⍝Sets up calls for CAPS watershed metrics for scenario name ⍺ and matrix of metrics and systems ⍵
⍝Call consists of (1) Watershed #, (2) full or subwatershed, (3) scenario name, (4) common input grids, (5) settings grids,
⍝   (6) repeating 4-element list of metric, system, result grids and metric-specific input grids
⍝B. Compton, 12-13 Aug 2009
⍝24 Feb 2011: skip subwatersheds; set up to call tiny watersheds in WATERSHEDB (up in the air, on the way to San Diego)
⍝24 May 2011: Set up calls for Anthill
⍝22 Jun 2011: pass override_pars; 24 Jun: use override_pars to pass watershedcall; 11 Aug put it in run\temp\
⍝27 Mar 2012: typo fixed
⍝17 May 2012: create subwatersheds file
⍝23 May 2012: use bigwatersheds table; don't have to deal with tiny watersheds any more
⍝7 Apr 2014: never scramble subtasks!  Ordering is important!
⍝12 Nov 2014: If no big watersheds, don't call WATERSHED! (This can happen in CSB)
⍝8 Jun 2015: allow multiple results
⍝13 Jul 2022: don't call SUBNAME and GRIDNAME for settings.par - it is not a grid!



 S E R B Q ← GETINFO 'WATERSHED'        ⍝Read source names, settings table, result names, buffer size, and include grid name from WATERSHED function
 V←GETINFO¨W[;1]                        ⍝Read the same from watershed metric functions
 S←GRIDNAME S                           ⍝Replace source grids names where available
 E←pathI PATH E,(0∊⍴STRIPEXT E)/'.par'  ⍝   settings.par is not a grid!
 R ← 0 resultspar GRIDNAME R

 ⍎(0=⎕NC'override_pars')/'override_pars←'''''
 V←(W[;1 2]),(R←3⊃¨V),[1.5]1⊃¨V                         ⍝Metric, system, result grid, and specific input grids
 override_pars←override_pars,⎕TCNL,'[watershedb]',⎕TCNL,'watershedcall←',(⍕⍴V),'⍴',⊃,/,BUILDPAR¨V   ⍝Save call for the sake of WATERSHEDB
 MAKEDIR pathP,'temp\'
 override_pars NWRITE O←pathP,'temp\temp',(FRDBL 15 0⍕?1E5),'.tmp'    ⍝Write override_pars

 :if (1 1⍴MV)≡TABLE pathT PATH bigwatersheds            ⍝If no big watersheds, don't call WATERSHED
    Z←0 3⍴0
    →0
 :end

 Q←'function!:''',O,''' WATERSHEDREPS ''',(pathT PATH bigwatersheds),''''

L0:→(~0∊⍴K)/L1                                          ⍝If no scenarios,
 Z←,¨,⊂LJUST MIX (⊂'WATERSHEDCALL '),¨⊂' ',DEB⍕(''''''),⊂(BUILDPAR S),(BUILDPAR E),(,BUILDPAR¨V),BUILDPAR O
 ⍎(2≤≡R)/'R←⊃OVER/MIX¨R'                                ⍝Flatten result list (allow multiple results, as from NPK)
 →L2

L1:G←1 TABLE K                                          ⍝Else, read scenario names
 Z←(⊂BUILDPAR K),MIX BUILDPAR¨S MAKENAMES G[;1]         ⍝   Scenario, common input grid names
 Z←(RJUST ⍕Z),' ',MIX BUILDPAR¨E MAKENAMES G[;2]        ⍝   Settings grids (not currently used for watershed metrics)
 R←M←0 0⍴''
 J←0
L3:→((1↑⍴G)<J←J+1)/L4                                   ⍝   For each scenario,
 T←⊃V[;3] MAKENAMES G[J;3]                              ⍝      Result grids for this scenario
 R←R OVER MIX T
 U←⊃¨(V[;4]) MAKENAMES¨ ⊂G[J;1]                         ⍝      Metric-specific input grids for this scenario
 M←M OVER DEB,⍕BUILDPAR¨V[;⍳2],T,[1.5]U
 →L3
L4:Z←DEB LJUST Z,M
 Z←(⊂'WATERSHEDCALL '),¨FRDBL¨↓Z
 Z←Z,¨⊂' ',BUILDPAR O

L2:Z←Z,[1.5]⊂Q
 Z←Z,⊂(⍕1↑⍴W),' watershed metric',(1≠1↑⍴W)/'s'
 resultgrids←resultgrids OVER (pathR,'progress') OVER MIX (~0∊⍴R)/(⊂pathR)PATH¨↓R

 head←0 0⍴'' ⋄ (0 0⍴'') TMATOUT pathI PATH 'subwatersheds.txt'   ⍝Create new, empty subwatersheds file