CONFIG;F;Q;D;T
⍝Set parameters from config.txt or use defaults if it doesn't exist
⍝B. Compton, 5 May 2011
⍝22 Aug 2011: sleep interval now floats with the number of threads; sleep is mean return interval for threads checking in
⍝16 May 2012: add rworkspace
⍝25 Jan 2013: add lockserver
⍝12 Feb 2013: only config if new directory; 14 Feb 2013: add namestrip
⍝23 Jul 2013: add lockpause (was lockwait until 17 Apr 2014)
⍝23 Oct and 4 Nov 2013: don't trap errors if under DEBUG
⍝14 Nov 2013: add scramblesubtasks
⍝27 Jan 2014: don't create missing config.txt; that happens in ANTINIT; 31 Jan: yeah, but don't fucking localize it!
⍝31 Jan 2014: add maxlocalgridinit; 5 Feb 2014: add webpath
⍝27 Mar 2014: add rflags
⍝9 Apr 2014: add maxsubtasks
⍝31 Jan 2017: add cachetimeout
⍝18 Mar 2021: add gridserverpostfix
⍝21 Apr 2021: add gridserverlogdir
⍝29 Nov 2021: add proj4library
⍝27 Feb 2024: add default_target and apl64_dev



 →(pathA≡anthilldir)/0

⍝Set default parameters
 defaults←'sleep tries iftrap rpath aplpath aplworkspace rpath rflags rworkspace uselockserver lockserver lockport namestrip gridserverpostfix recoverservers maxrecovery scramblesubtasks maxlocalgridinit webpath maxsubtasks'

 ⍎(0=⎕NC'iftrap')/'iftrap←1'
 sleep←3                                        ⍝Mean response time for system
 tries←5                                        ⍝Retry file operations 5 times to catch transient file system errors
 default_target←25                              ⍝target number of threads for each machine
 apl64_dev←'dsl01'                              ⍝development machine for APL64 - do normal error trapping behavior in TRY
 aplpath←'c:\APLWIN10\aplw.exe'
 aplworkspace←'x:\anthill\anthill.w3'           ⍝Path to APL cluster workspace
 rpath←'"c:\Program Files\R\R-2.12.0\bin\i386\Rgui.exe"'
 rworkspace←'x:\anthill\anthill.RData'          ⍝Path to R cluster workspace
 rflags←'--sdi --no-restore --max-mem-size=1610612736  --no-save'
 webpath←'x:\FTP\web\Anthill\'
 uselockserver←1
 lockserver←'umanrcl10'
 lockport←3340
 locktimeout←1800
 lockpause←0.1
 threadlimit←0
 namestrip←gridserverpostfix←gridserverlogdir←proj4library←''
 recoverservers←15
 maxrecovery←240
 scramblesubtasks←1
 maxlocalgridinit←500
 maxsubtasks←1000
 cachetimeout←60

:try
 tries←5
 ('Error in ',F,': ') SETPARS NREAD F←pathA,'config.txt'    ⍝Set parameters from config file

:catchall
  ⎕←'Anthill config file ',F,' doesn''t exist; using defaults.'
  Q←⍎¨D←FRDBL¨↓MATRIFY defaults                 ⍝   if config.txt doesn't exist, use defaults

:endtry

 name←GETNAME
 lockport LOCKINIT lockserver
 anthilldir←pathA

 iftrap←iftrap^~1∊(,⎕SI)⎕SS 'DEBUG'             ⍝Don't trap errors in tasks if called by DEBUG