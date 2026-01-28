Z←P BLOCKRUN M;N;C;Q;block;noread;Z;I;B;L;G;V;R;S;E;T;Y;O;U
⍝Sets up calls for CAPS metric ⍵ running in blocks across cluster
⍝⍺ = [1] systems, [2] block size, [3] grid list (for multiple time steps or scenarios)
⍝B. Compton, 28 Nov 2007
⍝29 Apr 2008: allow multiple grids; 29 Sep 2008 and 3 Oct 2008: improve multiple grids
⍝16-21 Jan 2009: work better with scenarios, grid names, buffer, and gridio DLL
⍝24 Aug 2009: Allow passing through result grids (to kill them) without assembling for call if 1st element is '!'
⍝17 Feb 2010: Call initialize to all metrics to set up results before run
⍝1 Jun 2010: if blocks = list of r,c, r,c, run only for these blocks
⍝7 Jul 2010: move INITIALIZE to CAPSRUN so it happens afer grids are killed
⍝16 Nov 2010: now uses TILEMAP and block[12]
⍝3 Feb 2011: 5th element from GETINFO is name of include grid (default = include)
⍝7 Mar 2011: Use toomanyblocks as error threshold
⍝23 May 2011: Set up calls for Anthill
⍝22 Jun 2011: pass override_pars; 11 Aug put it in run\temp\
⍝19 Sep 2011: bug in scenarios: missing include grid
⍝16 Jan 2012: pass override pars to BLOCKREPS to support temporary directory
⍝21 Aug 2012: include maskgroup in BLOCKREPS call
⍝14 Mar 2013: new reps facility
⍝8 Apr 2014: turn off subtask scrambling if scramble = no
⍝10 Apr 2014: don't call GRIDNAME up front--it screws up reps calls!
⍝13 Jul 2022: don't call SUBNAME and GRIDNAME for settings.par - it is not a grid!



 S E R B Y ← 0 1 GETINFO M              ⍝Read source names, settings table, result names, buffer size, and name of include grid from metric function

 O←''
 T←⎕EX 'allnames_',M
 →(0=⎕NC'override_pars')/L0             ⍝If override_pars exists,
 override_pars NWRITE O←pathP,'temp\temp',(FRDBL 15 0⍕?1E5),'.tmp'

L0:Q←Q+(0=Q←2⊃P)×⌈/WINDOW[1 2]          ⍝If block = 0, run in 1
 Q←'function',((~scramble)/'!'),':''',O,''' BLOCKREPS ''',Y,''' ',⍕Q,B,MASKGROUP M

 →(~0∊⍴3⊃P)/L1                          ⍝If no reps,
 S←GRIDNAME pathG SUBNAME S             ⍝   Replace grid names where available
 E←pathI PATH E,(0∊⍴STRIPEXT E)/'.par'  ⍝   settings.par is not a grid!
 R ← 0 resultspar GRIDNAME pathR SUBNAMER R
 Z←,⊂(BUILDPAR S),(BUILDPAR E),(BUILDPAR R),(⍕B),' ',(BUILDPAR Y),(BUILDPAR P[1]),BUILDPAR O   ⍝   build call parameters
 U←('!'≡1⊃1↑R)↓R
 ⍎(2>≡U)/'U←,⊂U'
 →L2

L1:Z U ← REPSRUN P M S E R B O Y        ⍝Else, fill out reps

L2:Z←(⊂'BLOCKCALL '),¨(⊂BUILDPAR M),¨Z
 Z←Z,[1.5]⊂Q
 Z←Z,⊂'metric: ',M
 resultgrids←resultgrids OVER MIX (~0∊⍴R)/(⊂pathR)PATH¨((U⍳U)=⍳⍴U)/U