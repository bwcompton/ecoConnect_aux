Z←P TABLERUN M;Z;B;G;R;S;X;head;targets;Q;T;O;H;I;J;K;Y;E;F;W;U
⍝Sets up calls for CAPS table-based metric ⍵ running across cluster
⍝⍺ = [1] systems, [2] number of rows per call, [3] grid list for reps (multiple time steps or scenarios)
⍝Writes one call to TABLECALL for each starting ID, to call for ⍺[2] items in table
⍝B. Compton, 21 May 2010, from BLOCKRUN
⍝7 Jul 2010: move INITIALIZE to CAPSRUN so it happens afer grids are killed
⍝26 Aug 2010: Make sure table has id - add it if not there
⍝1 Sep 2010: use tables\ path
⍝23 May 2011: Set up calls for Anthill
⍝2 Jun 2011: Get the reps function to pass to TABLEREPS; 20 Jun 2011: make it optional
⍝22 Jun 2011: pass override_pars; 11 Aug put it in run\temp\
⍝27 Mar 2012: typo fixed
⍝18 Dec 2012: Allow targets to refer to a range
⍝5 Mar 2013: pretty severe rewrite to accomidate new reps facility
⍝14 Mar 2013: pull out REPSRUN subroutine to share with others
⍝8 Apr 2014: turn off subtask scrambling if scramble = no
⍝13 Jul 2022: don't call SUBNAME and GRIDNAME for settings.par - it is not a grid!



 S E R B Q ← 0 1 GETINFO M              ⍝Read source names, settings table, result names, buffer size, and include grid name from metric function
 O←''
 T←⎕EX 'allnames_',M
 →(0=⎕NC'override_pars')/L3             ⍝If override_pars exists,
 override_pars NWRITE O←pathP,'temp\temp',(FRDBL 15 0⍕?1E5),'.tmp'

L3:T←GETREPSFN M
 →(0∊⍴T)/L0                             ⍝If repsfn: supplied,
 T←(0≠⍴T)/' ''',(FRDBL ⍕⍎T),''''        ⍝   evaluate it to modify table
L0:→(~^/(⍕targets)∊'0123456789: ,')/L5  ⍝If targets consists of numbers, spaces, commas, and colon,
 Q←'range',((~scramble)/'!'),':',⍕targets  ⍝   it's a range
 →L4                                    ⍝Else, targets refers to a file
L5:Q←'function',((~scramble)/'!'),':(',(⍕P[2]),') (''',T,''') (''',O,''') TABLEREPS ''',(pathT PATH targets),''''


L4:→(~0∊⍴3⊃P)/L1                        ⍝If no reps,
 S←GRIDNAME pathG SUBNAME S             ⍝   Replace grid names where available
 E←pathI PATH E,(0∊⍴STRIPEXT E)/'.par'  ⍝   settings.par is not a grid!
 R←0 resultspar GRIDNAME pathR SUBNAMER R
 Z←,⊂(BUILDPAR S),(BUILDPAR E),(BUILDPAR R),(⍕B),' ',(BUILDPAR P[1]),BUILDPAR O    ⍝   build call parameters
 U←('!'≡1⊃1↑R)↓R
 ⍎(2>≡U)/'U←,⊂U'
 →L2

L1:Z U ← REPSRUN P M S E R B O 0        ⍝Else, fill out reps

L2:Z←(⊂'TABLECALL '),¨(⊂BUILDPAR M),¨Z
 Z←Z,[1.5]⊂Q
 Z←Z,⊂'metric: ',M
 resultgrids←resultgrids OVER MIX (~0∊⍴R)/(⊂pathR)PATH¨((U⍳U)=⍳⍴U)/U