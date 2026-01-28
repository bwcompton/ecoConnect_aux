CAPSRUN;M;G;C;Z;I;U;T;resultgrids;caps1nt;end;W;P;B;A;blocksize;pathZ;post;finish;backup;head;Q;F
⍝Generate CAPS run on cluster or local machine
⍝B. Compton, 21-27 Nov 2007
⍝15 Jan 2009: Play nicely with gridio DLL
⍝26 Feb 2009: Change from CAPS; new parameter regime
⍝12 Aug 2009: Work with new watershed metrics
⍝21 May 2010: Also allow table-based (as opposed to block-based) metrics
⍝7 Jul 2010: move INITIALIZE here so it happens afer grids are killed
⍝10 Sep 2010: Add @wait and @continue directives.  These can be included in metrics file to control cluster runs.
⍝23 May 2011: Revise to use Anthill for cluster runs
⍝24 May 2011: change @wait directive to work as in Anthill
⍝28 Jun 2011: Add finish parameter
⍝11-12 Aug 2011: when doing a cluster run, copy parameter files to a temporary directory and point to them
⍝23 Sep 2011: backup result grids if backup\ exists in result folder; 13 Oct 2011: allow 1 result from multiple metrics
⍝23 Jan 2012: localize path.par as well as model parameter files
⍝9 Jul 2012: a couple of changes for CSE
⍝19-20 Sep 2012: don't infinitely regress if post = yes!
⍝28 Sep 2012: allow runs with no metrics (POST only, presumably)
⍝5 Mar 2013: create result directories if they don't already exist
⍝11 and 14 Apr 2014: save referencewindow and refgrid in override_pars so each subtask doesn't have to get it
⍝28-29 Apr 2014: write gridinfo cache
⍝6 Oct 2014: backup & kill results in subroutine
⍝26 Apr 2022: set empty finish if it doesn't exist, allowing it to be left out of [caps] and set in metric
⍝10 Jun 2022: add task maxthreads and maxpernode - these come from metrics.par



 fileptr←test←loop←block←0
 resultgrids←0 0⍴''

 FRISK                                  ⍝Check all parameters to make sure we're good to go
 SETBREAK

 M←metrics
 G←0 4⍴''                               ⍝Empty metrics template in case there are no metrics
 NEWRESULTS                             ⍝Clear out results and working directories & create AMLs
 mask←(IFEXISTS mask,'\')/mask←1 GRIDNAME 'mask'                ⍝Mask grid, if it exists

 Z←0 5⍴'' '' '' 0 0 ⋄ A←0⍴''
 →((VALUE 'notemp')∨~cluster)/L1        ⍝If doing a cluster run (unless notemp=1), make temporary copies of parameter files and redirect to them
 →(IFEXISTS pathP,'temp\')/L0           ⍝   If run\temp\ doesn't exist
 MAKEDIR pathP,'temp\'                  ⍝      create it
L0:MAKEDIR pathZ←pathP,'temp\zzpars',(FRDBL 15 0⍕?1E15),'\'
 pathI COPYDIR pathZ,'model\'
 pathM COPYDIR pathZ,'metrics\'
 PATHSDOTPAR NWRITE pathZ,'paths.par'

 Q[;2]←TEXTIFYGI¨(Q←gridinfo)[;2]       ⍝   format grid info
 Q[;3]←TEXTIFYMI¨Q[;3]                  ⍝   textify mosiac info
 head←1↓⎕TCHT MTOV MATRIFY 'gridname griddescribe mosaicinfo'
 Q TMATOUT F←pathZ,'gridinfo.txt'       ⍝   write gridinfo cache so threads can use it

 ⍎(0=⎕NC'override_pars')/'override_pars←'''''
 override_pars←override_pars,('.∣.',⎕TCNL) TEXTREPL '∣[caps]∣',('pathI = ''',(pathI←pathZ,'model\'),''''),'∣pathM = ''',(pathM←pathZ,'metrics\'),'''∣pathdir = ''',(pathZ,'paths.par'),'''∣refgrid = ''',refgrid,'''∣referencewindow = ',(FRDBL⍕FMTALL referencewindow),'∣gridinfofile = ''',F,''''

L1:→(0∊⍴M)/L9
 →('@'≠⊃⊃M[1;1])/L2                     ⍝   Loop for metric groups.  If @ directive,
 Z←Z⍪(TOLOWER 1↓⊃M[1;1]) '' '' 0 0      ⍝      Add to script
 M←1 0↓M                                ⍝      and drop it from metrics

L2:G←M[⍳¯1+('@'=⊃¨M[;1])⍳1;]            ⍝   Metrics in next group--up to @ directive
 M←((1↑⍴G),0)↓M                         ⍝   Remaining metrics

 I←0
 A←A,G[;1]←TOUPPER¨G[;1]
 W←(B←(⊂'watershed')≡¨GETTYPE¨G[;1])⌿G  ⍝   Pick out watershed metrics from type: descriptor
 G←(~B)⌿G                               ⍝   Pull out watershed metrics and group under WATERSHED
 →(0∊⍴W)/L5                             ⍝   If any watershed metrics,
 P←WSCENARIOS W                         ⍝      Disentangle scenarios & metrics
 READPARS 'WATERSHEDB'
 G←G⍪'WATERSHEDB' 'yes' '#' blocksize 0 0 '' 0 ⍝      Set up block calls for tiny watersheds (*** Doesn't account for scenerios)

 I←0
L4:→((1↑⍴P)<I←I+1)/L5                   ⍝   For each watershed scenario,
 T←(1E6∣⌊/1E6,(W[;5]≠0)/W[;5]),1E6∣⌊/1E6,(W[;6]≠0)/W[;6]  ⍝   Minimum task maxthreads and maxpernode
 Z←Z⍪(((⊃P[I;1]) WATERSHEDRUN ⊃P[I;2]),T[1]),T[2] ⍝      write watershed calls (use min values for maxthreads and maxpernode across metrics)
 →L4

L5:W←(B←(⊂'table')≡¨GETTYPE¨G[;1])⌿G    ⍝   Now pick out table metrics from type: descriptor
 G←(~B)⌿G                               ⍝   Pull out table metrics
 I←0
L6:→((1↑⍴W)<I←I+1)/L7                   ⍝   For each table metric
 Z←Z⍪((W[I;3 4 7] TABLERUN ⊃W[I;1]),W[I;5]),W[I;6]  ⍝      write table calls
 →L6

L7:I←0
L8:→((1↑⍴G)<I←I+1)/L9                   ⍝   For each block metric,
 Z←Z⍪((G[I;3 4 7] BLOCKRUN ⊃G[I;1]),G[I;5]),G[I;6]  ⍝      write block calls
 →L8

L9:→(~0∊⍴M)/L1                          ⍝Next group of metrics

 BACKKILL FRDBL¨↓resultgrids            ⍝Back up result grids and kill them
 (G[;4],0)[G[;1]⍳A] INITIALIZE¨A        ⍝Do any metric-specific initialization, passing tile size
 P←pathdir                              ⍝Protect paths.par
 1 READPARS 'caps'
 pathdir←P
 →((~post)∨∨/⊃,/(⊂,⎕SI) ⎕SS¨(FRDBL¨↓MATRIFY 'POST SCENARIOS MIXMETRICS MAKESETTINGS MAKEMANYSETTINGS ALLPOST CLUSTERS'),¨'[')/L12    ⍝If post = yes and this is a primary call,
 Z←Z⍪POSTRUN                            ⍝Run post after a wait

L12:⍎(0=⎕NC'finish')/'finish←'''''
 →(0∊⍴finish)/L10
 Z←Z⍪'wait' finish,(2 2⍴⊂''),2 2⍴0      ⍝Run finish after a wait
 
L10:→cluster/L11                        ⍝If just doing local run,
 LOCALRUN Z                             ⍝   Just run it
 →0
L11:CAPSLAUNCH Z                        ⍝   Launch CAPS project in Anthill
 T←⎕EX 'override_pars'