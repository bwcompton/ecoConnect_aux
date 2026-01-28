FRISK;I;Z;W;B;P;E;D;X;M;Q;R;Y;warn;T;G;V;fn;S;N;K;F;dot;O;futuregrids;futurepath
⍝Check parameters and inputs for current CAPS run to check for errors
⍝Logs warnings and errors, and stops execution on errors
⍝Also logs start and end of run, and creates .zip file of all parameters
⍝B. Compton, 22 Jan and 2-4 Feb 2009; parameter revolution 25-26 Feb 2009
⍝Changes for watershed metrics and other improvements Aug 2009
⍝7 Mar 2011: frisk for include grid
⍝16 Sep 2011: don't frisk for optional grids (those with * in name)
⍝3 Feb 2012: check settings variables against scalesettings.txt
⍝13 Apr 2012: report grid server extent
⍝28 Sep 2012: allow runs with no metrics (POST only, presumably)
⍝1 Aug 2013: if tilemapinclude = no and no mask, give error
⍝3 Jan 2014: new zippars and checkalign options
⍝13 Jan 2014: Make sure we're not trying to use landscapewide grids when landscapewide = no,
⍝   check for bad mosaics, use IFGRIDEXISTS for all grid checking, make sure no input mosaics if mosaics = no
⍝27 Jan 2014: use SETTILE instead of noread←1 nonsense
⍝6 Mar 2014: don't frisk include grid = '*' -- this means don't do TILEMAP
⍝6 Mar 2014: don't check all grids in inputs.par
⍝1 Jun 2014: give error if mask grid is named but doesn't exist
⍝26 Aug 2019: was doing grid name substitution in GETINFO call, and then again a few lines later. Broke names
⍝   that resolved to a tag in inputs.par
⍝19 Apr 2022: don't mess with ifchat (now chatter)
⍝10 Jun 2022: add task maxthreads and maxpernode from metrics.par/override_metrics
⍝17 Feb 2023: sometimes "missing" grids are really outdated mosaics. Punt and just change the message.



 ⍎(0=⎕NC'warnings')/'warnings←0 0⍴'''''
 W←E←0
 Z←''
 →(0∊⊃,/⎕NC¨↓MATRIFY 'cluster example blocks')/L2   ⍝Have to bail if any of these are missing
 Z←Z OVER warnings
 Z←((~0∊⍴example)/'~> > > Example facility is ON for ',(⍕.5×⍴,example),' cell',((2≠⍴,example)/'s'),' (or ',(⍕⍴,example),' item',((1≠⍴,example)/'s'),') < < <~') OVER Z
 Z←((~0∊⍴blocks)/'~> > > Running for ',(⍕.5×⍴,blocks),' selected block',((2≠⍴,blocks)/'s'),': ',(⍕(8⌊⍴,blocks)↑,blocks),((6<⍴,blocks)/'...'),' < < <~') OVER Z

⍝Make sure all paths exist
 X←MATRIFY 'pathI pathG pathA pathM pathP pathR pathE pathU pathN ',((⊂'scenarios')∊metrics[;1])/'pathD'
 Z←Z OVER (W←0∊B)/'~Warning | Paths not set:',,' ',P←(~B←2=⊃,/⎕NC¨↓X)⌿X


⍝Create result paths if necessary
 →(0∊⍴X←(0=P MATIOTA X)⌿X)/L1
 →(0∊⍴X←(~B←IFEXISTS¨⍎¨↓X)⌿X)/L1
 Z E ← Z MAKEPATHS (B←~IFEXISTS¨T)/T←⍎¨↓X       ⍝Create missing paths if necessary.  (Note: model and run paths will already exist anyway)
 Z←Z OVER (1∊B)/'~Note | paths created:' OVER ' ',' ',' ',(B⌿X),' ','=',' ',MIX⍎¨↓B⌿X


⍝Make sure all parameter files exist
L1:→(∨/0≠P MATIOTA MATRIFY 'pathI')/L30
 ⍎(0≠T←⎕NC'noland')/'T←noland'                  ⍝If noland=yes, don't check for landcover.par
 X←(T,0)↓MATRIFY landcoverpar,' metrics.par parameters.par'
 X←(0=IFEXISTS¨(⊂pathI) PATH¨↓X)⌿X
 →(0∊⍴X)/L2
 Z←Z OVER '~Error | Missing (or locked) parameter files: ' OVER ' ',' ',' ',(⎕PW-3) TELPRINT X
 →(E←R←1)/L30


⍝Check general options
L2:warnings←0 0⍴''
 →(~CHECKPARS ,⊂'CAPS')/L3
 E←R←1
 Z←Z OVER '~Missing or incorrect general options under [caps] in parameters.par:' OVER warnings
 warnings←0 0⍴''
 →L30


⍝Check for optional input tables
L3:X←MATRIFY synonymspar,' groups.par'
 X←(0=IFEXISTS¨(⊂pathI) PATH¨↓X)⌿X
 →(0∊⍴X)/L4
 Z←Z OVER '~Note | Optional parameter files not supplied: ' OVER ' ',' ',' ',(⎕PW-3) TELPRINT X


⍝See if mask grid exists
L4:B←~0∊⍴Q←1 GRIDNAME 'mask'
 :if B
    :if ~IFGRIDEXISTS Q
       Z←Z OVER '~Error | Mask grid ',Q,' does not exist'
       E←1
    :else
       Z←Z OVER '~Note | Mask grid = ',Q
    :end
 :else
    :if tilemapinclude
       Z←Z OVER '~Note | Mask grid not being used'
    :else
       Z←Z OVER '~Error | No mask grid specified when tilemapinclude = no'
       E←1
    :end
 :end

 →(0=⎕NC'exclude')/L5                    ⍝If any cover types are excluded,
 →(0∊⍴exclude)/L5
  Z←Z OVER '~Note | Excluded cover types: ',TOLOWER exclude

⍝Make sure all grids named in inputs.par exist

L5:V←0 2⍴''


→L9     ⍝We don't want to do this--there are a ton of grids in inputs.par, and this takes forever; also
        ⍝if a grid we aren't using is getting updated, we get errors of out of date mosaics               THIS CAUSES PROBLEMS WHEN LAUNCHING E.G. CONNECT ***


 →(~IFEXISTS pathI PATH inputspar)/L6
 G←1 0 TABLE inputspar
 →(~G≡1 1⍴⊂'')/L7                      ⍝If inputs.par exists,
L6:Z←Z OVER '~Note | Inputs.par doesn''t exist; default grid names will be used.'
 →L9
L7:→(0∊~B←⊃,/IFGRIDEXISTS¨Q←1 GRIDNAME G[;1])/L8
 Z←Z OVER '~Warning | Missing grids named in inputs.par (some may not be necessary for run):'
 Z←Z OVER ' ',' ',' ',(MIX (~B)/Q),' ',MIX '(',¨((~B)/G[;1]),¨')'
L8:V←(⊂inputspar),[1.5]B/Q           ⍝Later we'll make sure the grids that do exist align with the reference grid


⍝Make sure reference grid exists and read grid info
L9:Z←Z OVER (R←~IFGRIDEXISTS refgrid)/'~Error | Missing reference grid: ',refgrid←1 GRIDNAME 'reference'
 E←E∨R
 →R/L10


⍝Make sure all metrics exist
⍝Make sure all metric parameters exist
⍝Make sure all metric tables exist
⍝Make sure all input and settings grids exist and align
⍝Make sure all input table values exist in landcover.par
⍝Make sure all scenario result directories exist
L10:→(∨/0≠P MATIOTA MATRIFY 'pathI pathG')/L30
 fn←'settings'
 warn←1
 warnings←0 0⍴''
 I←0

 →(0∊⍴M←metrics)/L23                            ⍝If no metrics, skip all of this stuff
 Q←(T←⊃,/'@'=1↑¨LJUST¨M[;1])⌿M
 M←(~T)⌿M                                       ⍝Don't worry about @-directives now
 →(^/0=B←~(TOUPPER¨Q[;1])∊⊂'@WAIT')/L11
 Z←Z OVER '~Error | Illegal @-directive:',⍕B⌿Q[;1]
 →(E←1)/L30
L11:→(~(1<1↑⍴M)^1∊B←(⊂'exclusive')≡¨GETTYPE¨M[;1])/L12    ⍝If exclusive metric selected, it must be alone
 Z←Z OVER '~Error | Exclusive metric (',(⊃B/M[;1]),') run with other metrics selected (need to turn them off):'
 Z←Z OVER ' ',' ',' ',MIX (~B)/M[;1]
 →(E←1)/L30

L12:K←'~Note | Metrics called:'
 K←K OVER ' ',' ',' ',(⎕PW-3) TELPRINT MIX ((T⍳T)=⍳⍴T)/T←M[;1]
 F←1

 →(^/~T←3≠⊃,/⎕NC¨TOUPPER¨M[;1])/L13            ⍝If any non-existent metrics called,
 Z←Z OVER '~Error | Non-existent metric',((1≠+/T)/'s'),' called:'
 Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT MIX T/M[;1]
 E←1
 M←(~T)⌿M                                       ⍝   Drop bogus ones

L13:M←M⍪(∨/(⊂'watershed')≡¨GETTYPE¨TOUPPER M[;1])⌿(1,1↓⍴M)⍴'watershed' 'yes' '*' MV 0 0 '' 0   ⍝   If any watershed metrics called, frisk WATERSHED too
 Q←(⊂pathI) PATH¨(Q←(~0∊¨⍴¨M[;7])/M[;7]) EXT¨⊂'par'⍝Get scenario files
 Q←((Q⍳Q)=⍳⍴Q)/Q
 →(^/T←IFEXISTS¨Q)/L14                          ⍝and make sure they're all there
 Z←Z OVER '~Error | Missing scenario files:'
 Z←Z OVER ' ',' ',' ',MIX (~T)/Q
 →(E←1)/L30

L14:→((1↑⍴M)<I←I+1)/L19                         ⍝For each metric,
 →(CHECKPARS M[I;])/L18                         ⍝   Check metric-specific parameters.  Don't do more if any errors.
 →(~M[I;1]∊'connect' 'aqconnect' 'sim' 'linkages')/L15      ⍝   If connect, sim, etc.,
 →(0=⎕NC'resist')/L15
 →(M[I;8]←0∊⍴resist)/L15                        ⍝      and using resistance table,
 K←K OVER (F/'~'),'   Resistance table for ',(⊃M[I;1]),' in use (values take precedence over settings)'
 F←0
L15:G←1 2⍴⊂''
 →(0∊⍴⊃M[I;7])/L16                              ⍝   If using scenarios,
 G←1 TABLE pathI PATH (⊃M[I;7]) EXT 'par'       ⍝      Get scenario stuff
 →(~0∊⍴warnings)/L18                            ⍝      bail out if errors from TABLE
L16:→(R←E)/L30
 X←1 1 GETINFO ⊃M[I;1]                          ⍝   Get metric info; don't suppress * in optional grid names...and don't do grid name substitution yet
 →(0∊⍴X)/L14
 ⍎(2≤≡1⊃X)/'X[1]←⊂(⊃,/0≠⍴¨1⊃X)/1⊃X'             ⍝   Drop out empty input grids (happens in LINKAGES)
 X[1]←⊂(~'*'∊¨1⊃X)/1⊃X                          ⍝   Drop optional ('*') grids at this point--we don't frisk for them
 V←V⍪M[I;1],[1.5]⊃,/(GRIDNAME 1⊃X) MAKENAMES G[;1]  ⍝   Add list of input grids
 V←V⍪((~'*'∊5⊃X)^~0∊⍴5⊃X)⌿1 2⍴M[I;1],⊂GRIDNAME 5⊃X  ⍝   And add include grid--unless it has '*'
 T←(~T≡¨⊂'')/T←⊃,/(2⊃X) MAKENAMES G[;2]         ⍝   Settings table(s)
 →(0∊⍴T)/L17                                    ⍝   If any settings tables,
 T←(⊃,/IFEXISTS¨(⊂pathI) PATH¨T EXT¨⊂'par')/T   ⍝   Only care about tables that exist
 →(0∊⍴T)/L17                                    ⍝   If any settings tables,
 S←(1 TABLE¨(⊂pathI) PATH¨T EXT¨⊂'par')         ⍝      read grid names (missing ones get added to warnings)
 →(S≡,⊂1 1⍴⊂'')/L17                             ⍝      skip out if settings table is empty
 →(~0∊⍴warnings)/L18                            ⍝      bail out if errors from TABLE
⍝ T←(0=⊃,/⍴¨((⊃⍪/S),⊂'')[;2])/(⊃⍪/S)[;1]
 T←((~(⊂,1)≡¨⎕VI¨((⊃⍪/S),⊂'')[;3])∨0=⊃,/⍴¨((⊃⍪/S),⊂'')[;3])/(⊃⍪/S)[;1]
 Z←Z OVER (T←~0∊⍴T)/'~Error | Missing or non-numeric weight for settings grids:',⍕T
 E←E∨T
 S←(⊃⍪/S)[;1]
 T←(MATIN pathT PATH scales)[;1]
 T←((T⍳S)>⍴T)/S
 Z←Z OVER (T←~0∊⍴T)/'~Error | Settings grids and ranges missing from ',scales,':',⍕T
 E←E∨T
 S←GRIDNAME¨(⊂pathN),¨S
 V←V⍪M[I;1],[1.5]S                              ⍝      and add list of settings grids
 T←((F/'~'),'   Settings grids for ',(⊃M[I;1]),':') OVER ' ',' ',' ',' ',' ',' ',(⎕PW-6) TELPRINT MIX S
 K←K OVER (M[I;8])⌿T
L17:→(0∊⍴⊃M[I;7])/L14                           ⍝   If using scenarios,
 T←⊃,/(3⊃X) MAKENAMES G[;3]
 →(0∊⍴T)/L14
 T←(~0∊¨⍴¨T)/T←(-¯1+(⌽¨T)⍳¨'\')↓¨T              ⍝      Find result paths
 Z E ← Z MAKEPATHS (B←~IFEXISTS¨T)/T←(⊂pathR) PATH¨T       ⍝      and create them if they don't exist
 →L14

L18: Z←Z OVER '~Error | Problems with parameters for ',⊃M[I;1]
 Z←Z OVER ' ',' ',' ',warnings
 Z←Z OVER '   (skipping check of input and settings grids for ',(⊃M[I;1]),')'
 warnings←0 0⍴''
 W←E←1
 →L14

L23:Z←Z OVER '~Warning | No metrics called!'
 K←0 0⍴''
L19:Z←K OVER Z

⍝Now we have list of metrics and all input and settings grids used for each
 N←((N⍳N)=⍳⍴N)/N←V[;2]                  ⍝Unique grids with name replacement from inputs.par
 →(0∊⍴N)/L21
 →(0∊⍴Q←(~B←⊃,/IFGRIDEXISTS¨(⊂pathG) PATH¨N)/N)/L21
 N←B/N                                  ⍝Grids that exist
 E←1
 Z←Z OVER '~Error | Missing (or outdated) input, include, or settings grids (in ',pathG,'):'
 Z←Z OVER warnings
 warnings←0 0⍴''
 S←⊃,/⌈/⍴¨Q
 I←0
L20:→((⍴Q)<I←I+1)/L21                   ⍝For each missing grid,
 T←((T⍳T)=⍳⍴T)/T←(V[;2]≡¨Q[I])/V[;1]
 Z←Z OVER ' ',' ',' ',(S↑⊃Q[I]),' (',(1↓⊃,/' ',¨T),')'
 →L20


L21:⍝Make sure we're not trying to use landscapewide grids when landscapewide = no
 :if (~0∊⍴N)^~landscapewide
 :andif 1∊T←0=⊃,/⍴¨⊃¨MOSAICINFO¨D←(⊂pathG) PATH¨N
    E←1
    Z←Z OVER '~Error | landscapewide = no, but these grids are not mosaics:'
    Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT MIX T/D
 :end

⍝Check for mutilated grids
 :if 1∊T←MULTITILE¨N
    E←1
    Z←Z OVER '~Error | Multitiled ESRI grids:'
    Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT MIX T/N
 :end

⍝Check for out of date mosaics and those with missing source grids
 :if mosaics                                        ⍝If mosaics,
    O←FRDBL¨(⊂pathG) PATH¨(¯2×(⊂'_m')≡¨TOLOWER¨¯2↑¨N)↓¨N  ⍝   Originals of any auto-mosaics
    →(0∊⍴O)/L61
    :if substmosaics                                ⍝   if substituting mosaics,
       T←0=¨⊃,/⍴¨⊃¨MOSAICINFO¨O                     ⍝      those that are grids
       D←T^0≠¨⊃,/⍴¨⊃¨MOSAICINFO¨O,¨⊂'_m'            ⍝      and have sister _m mosaics
       O←((~T)/O),D/O,¨⊂'_m'                        ⍝      names of original mosaics and substituted mosaics
    :else                                           ⍝   else, no substitution
       O←(0≠¨⊃,/⍴¨⊃¨MOSAICINFO¨N)/N                 ⍝      inputs that are mosaics (they were supplied)
    :end                                            ⍝   Now we have a full list of mosaics

    :if ∨/T←2=D←FRISKMOSAICS O                      ⍝   If any mosaics are out-of-date,
       E←1
       Z←Z OVER '~Error | These mosaics are out-of-date with respect to source grid:'
       Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT MIX T/O
    :end
    :if ∨/T←D=3                                     ⍝   If any mosaics have missing source,
       Z←Z OVER '~Warning | The source grid is missing for these mosaics:'
       Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT MIX T/O
    :end
 :else
    :if ∨/T←9≠FRISKMOSAICS N                        ⍝Else, mosaics are turned off--make sure no inputs are mosaics
       E←1
       Z←Z OVER '~Error | mosaics = no, but input mosaics were supplied:'
       Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT MIX T/N
    :end
 :end


⍝Use GRIDDESCRIBE here to make sure grids align with reference grid
L61:→(R∨~checkalign)/L24
 D←5↑GRIDDESCRIBE refgrid
 T←5↑¨GRIDDESCRIBE¨(⊂pathG) PATH¨N
 Q←(~(⊂¯1↓D)≡¨¯1↓¨T)/N
 →(0∊⍴Q)/L24
 E←1
 Z←Z OVER '~Error | Misaligned input or settings grids (in ',pathG,'):'
 S←⊃,/⌈/⍴¨Q

 I←0
L22:→((⍴Q)<I←I+1)/L24                   ⍝For each misaligned grid,
 T←((T⍳T)=⍳⍴T)/T←(V[;2]≡¨Q[I])/V[;1]
 Z←Z OVER ' ',' ',' ',(S↑⊃Q[I]),' (',(1↓⊃,/' ',¨T),')'
 →L22


⍝Make sure all values in landcover grid exist in landcover table
L24:→(R∨~checkland)/L27                 ⍝This takes a while, so only do it if asked
 LOG 'Checking landcover values against landcover.par...'

 Q←landcover[;1]
 Y←⍳0
 I←0
 BLOCK 1000 1000 0
 SETTILE
 D←TILEMAP refgrid 1000 0

 I←0
L25:→(~D[I←I+1])/L26
 DOT
 BREAKCHECK
 X←,READ refgrid                ⍝While there are blocks to read,
 Y←Y,(~X∊Q,MV)/X                ⍝   Find bad values
 Y←((Y⍳Y)=⍳⍴Y)/Y
L26:→(NEXTBLOCK≠0)/L25
 ⍝∆CLEANUP   ⍝I don't this this is safe here...
 →(0∊⍴Y)/L27
 Y←Y[⍋Y]
 E←1
 Z←Z OVER '~Error | Unknown values in landcover grid ',refgrid,' (not in landcover.par):'
 Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT MATRIFY⍕Y


⍝Report all ⎕STOPs
L27:X←(⊃,/0≠⍴¨⎕STOP¨↓X)⌿X←((⌽RJUST ⎕NL 3)[;1]≠'c')⌿⎕NL 3
 →(0∊⍴X)/L28
 W←1
 Z←Z OVER '~Warning | ⎕STOP set in functions:'
 Z←Z OVER ' ',' ',' ',(⎕PW-3) TELPRINT X


⍝Zip up input parameters and save in results\
L28:→(E∨R)/L30
 :if zippars
    D←(((D≠' ')/D←(¯1+NOW⍳',')↑NOW)),'-',,'ZI2' ⎕FMT TIMESTAMP[4 5]
    (D←pathR PATH 'CAPSpars',D) ZIP (path PATH pathdir),' ',pathI
    Z←Z OVER (~Q←IFEXISTS D,'.zip')/'~Warning | Unable to create ',D,'.zip (bad path or 7z.exe unavailable?)'
 :else
    D←Q←0
 :end
⍝Write start of run, parameter zip file, and successful completion to results\CAPSresults.log
 X←'[',NOW,']  Starting CAPS run'
 X←X OVER Q/'[',NOW,']  ',T←'Parameters saved in ',D,'.zip'
 Z←Z OVER Q/'~Note | ',T
 →(IFEXISTS T←pathR PATH 'CAPSresults.log')/L29
 X NWRITE T
 →L30
L29:X NAPPEND T


⍝Report if unable to continue
L30:→(~R)/L31
 Z←Z OVER '~FRISK unable to finish because of',(W/' warnings'),((2=W+E)/' and'),(E/' errors'),'.'


⍝Report everything in log
L31:Z←Z OVER warnings
 Z←(∨/Z≠' ')⌿Z
 Z←(~0∊⍴Z)⌿T OVER (Z⍪' ') OVER T←(⎕PW⌊1↓⍴Z)⍴'-'
 Z←('.~.',⎕TCNL) TEXTREPL MTOV Z
 LOG Z


⍝Finish up
⍝ ∆CLEANUP                                ⍝Release local grid server - NO! this trashes current window!
 →(~E)/L32                              ⍝If any errors,
 LOG '*** CAPS run cannot continue because of errors.'
 →(~1∊(~1∊(⊂,⎕SI) ⎕SS¨'CSE[' 'POSTCALL['))/L33    ⍝If called by CSE or POSTCALL and found errors,
 ⎕ERROR 'Errors launching CAPS (See ',logfile,' for details)'
L33:→                                      ⍝   bail out completely
L32:→(~friskonly)/0                     ⍝If only frisking,
 LOG 'CAPS exiting.  (friskonly = yes)'
 →                                      ⍝   bail out completely