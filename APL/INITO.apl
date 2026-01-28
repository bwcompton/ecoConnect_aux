P INITO O;F;T
⍝Initialize CAPS or Habit@ with override parameters ⍵; don't set paths if ⍺
⍝B. Compton, 13-27 Dec 2013, from INIT_S
⍝Use GRIDNAME for mosaicref
⍝13 Jan 2014: do 2nd round of application initialization after CONFIG so we can do locking if need be
⍝27 Jan 2014: SETPATHS is only from CAPS
⍝31 Jan 2014: need 2nd round for Habit@ too
⍝11 Apr 2014: changes to get fewer (or no!) locks on reference grid on CAPS subtask initialization; 14 Apr 2014: revisions
⍝28 Apr 2014: clear local gridinfo cache, and read it if name was set by override_pars
⍝27 Jun 2014: make gridinfo work properly when mosaics = no
⍝13 Jul 2015: don't reset paths.par when run locally
⍝9 Nov 2021: pass refgrid to GRIDINIT/use REFGRIDINIT for TIFF revolution; 5 Jul 2022: but do it right!



 ⍎(0=⎕NC'P')/'P←0'
 :if ~(⊂STRIP ⎕WSID)∊'CAPS' 'HABITAT'   ⍝If not called within base workspace (implying this is an Anthill call),
    pathdir←'paths.par'         ⍝   Reset paths.par in case a previous task changed it
 :end
 ⎕SA←''
 ⎕ALX←'STOP'

 CLEANUP                        ⍝Initialize grid server(s)
 referencewindow←⍳0             ⍝Force setting reference window (in a CAPS run, it'll come from override_pars)
 gridinfo←0 3⍴''                ⍝Clear local cache of gridinfo
 :if ~0∊⍴O                      ⍝If override_pars is non-empty,
    gridinfofile←''
    override_pars←NREAD O       ⍝   read and set it
    SETPARS override_pars       ⍝   set override_pars in case it sets pathdir
    :if 0≠⍴gridinfofile         ⍝   If gridinfo is supplied, read it
       gridinfo←1 ⎕TCHT 1 MATIN gridinfofile
       gridinfo[;2]←⍎¨LOWTOHIX¨gridinfo[;2]
       gridinfo←((1↑⍴gridinfo),3)↑gridinfo,⊂''  ⍝      create empty mosaics column if it's not there
       T←⊃,/0≠⍴¨gridinfo[;3]
       :if ∨/T
          gridinfo[T/⍳1↑⍴gridinfo;3]←⍎¨LOWTOHIX¨⍕¨T/gridinfo[;3]
       :end
       gridinfo[(~T)/⍳1↑⍴gridinfo;3]←⊂⍳0
    :end
 :end

 :if framework≡'caps'           ⍝Now do application-specific initialization
    :if ~P
       SETPATHS                 ⍝   set paths, unless we're not to
    :end
    INIT_CAPS
 :elseif framework≡'habit@'
    INIT_HABITAT
 :end

 :if cluster                    ⍝If running on the cluster,
    CONFIG                      ⍝   do Anthill configuration and initialize the lock server
 :end

 :if framework≡'caps'           ⍝Do 2nd round application-specific initialization
    INIT_CAPS2
 :elseif framework≡'habit@'
    INIT_HABITAT2
 :end

 ⎕ERROR ((~landscapewide)^~mosaics)/'Paramter error: Must have at least one of landscapewide = yes or mosaics = yes'

⍝ ⍞←cluster/'---> Connecting to grid server(s)...' ⋄ FLUSH

 :if landscapewide                                  ⍝If landscapewide, set up full landscape grid server
    :if cluster^0∊⍴gridserver                       ⍝   if cluster run and no gridserver supplied,
       1 GRIDINIT refgrid ''                        ⍝   initialize local grid server
       :if 0∊⍴referencewindow                       ⍝   If we weren't passed referencewindow,
          referencewindow←5↑GRIDDESCRIBE refgrid    ⍝   Get the window for the reference grid--we need it here
       :end
       gridserver←FINDSERVER referencewindow refgrid⍝      find a grid server that matches this window
       ⎕ERROR (0∊⍴gridserver)/⎕TCNL,'No grid server in ',pathA,'gridservers.txt for reference grid ',refgrid,', window = (',(1↓⊃,/',',¨⍕¨5↑referencewindow),')'
    :end
    :if ~cluster                                    ⍝   if local,
       gridserver←''                                ⍝      use local grid server no matter what
    :end
    1 1 REFGRIDINIT (⊂refgrid),gridserver           ⍝      initialize grid server & set window
 :end

 :if mosaics                                        ⍝If we're using mosaics,
    ⎕ERROR (0∊⍴mosaicref)/'Error: mosaics = yes but no mosaicref was supplied.'
    MOSAICINIT (GRIDNAME mosaicref) 'gridservers.txt' ⍝   initialize
 :end

 ⍝⍞←cluster/'done.',⎕TCNL ⋄ FLUSH