∆GRIDINIT S;Q;Z;err;A;P;M;L;firstfail;G
⍝Initialize Edi's gridio functions server and port ⍵
⍝   ⍵[1]    server ('' for local grid server)
⍝   ⍵[2]    port (not needed for local server)
⍝   ⍵[3]    server log (optional; if excluded, use global serverlog)
⍝B. Compton, 14 Jan 2009; E. Ene, 3 Jan 2009
⍝30 Apr 2009: allow reinitializing (won't work when in server mode!)
⍝12 Aug 2010: port is a variable in parameter file now (probably need to open firewall to new ports!)
⍝2 May 2011: set global gridwait for task manager
⍝5 Sep 2013: change to ∆GRIDINIT from GRIDINIT; port is now a required parameter with no default; always call CLEANUP first
⍝10 Sep 2013: change arguments to conform to new GRIDINIT
⍝13 Nov 2013: add grid server recovery
⍝31 Jan 2014: increment gridinitcount so we can refresh if it exceeds maxlocalgridinit so we don't run out of memory
⍝25 May 2017: somehow I added a line to set E←0 without localizing it or doing anything with it...must have been a ghost-paste
⍝23 Mar 2021: deal with gridserverpostfix so -f is removed when working from dsl00
⍝1 Feb 2024: now use gridio_lib



 ⍎(0=⎕NC'S')/'S←'''''
 ⍎(S≡'')/'S←'''' 0'
 S P L ← 3↑S,0,(3<⍴,S)/serverlog    ⍝Server and port

⍝Strip -f from server name if we're on the same machine as servers
 G←'-f' ⋄ ⍎(0≠⎕NC'gridserverpostfix')/'G←gridserverpostfix'
 Q←((-⍴G)×(TOLOWER G)≡(-⍴G)↑FRDBL TOLOWER S)↓S
 S←(1+(TOLOWER Q)≡TOLOWER GETFULLNAME) ⊃ S Q

 M←1+0∊⍴S                           ⍝Mode: 1 = remote, 2 = local
 :if M=2                            ⍝If in local mode, increment gridinitcount
    ⍎(0=⎕NC'gridinitcount')/'gridinitcount←0'
    gridinitcount←gridinitcount+1
⍝    ⎕←⎕TCNL,'→→→ gridinitcount = ',⍕gridinitcount ⋄ FLUSH
 :end

 →(aplc=1)/0                        ⍝If C version,
 →(3=⎕NC'GRIDINITc')/L1             ⍝   If not loaded,
 Q←⎕EX 'GRIDINITc'
 ⎕ERROR REPORTC 'DLL I4←GRIDIO_LIB.gridinit(I4,*C1,I4,I4)' ⎕NA 'GRIDINITc'
⍝⎕←'GRIDIO_LIB.gridinit loaded.'

L1:A←⎕AI[2]
 ∆CLEANUP
L3:err Z←GRIDINITc M (S,⎕TCNUL) P L
 →(RECOVERY err)/L3                 ⍝Wait for crashed grid servers to recover
 →(err≠¯623)/L2                     ⍝If grid server already initialized,
 ∆CLEANUP                           ⍝  clean up and try again
⍝ ⎕←'---> reinitializing grid server'
 err Z←GRIDINITc M (S,⎕TCNUL) P L
L2:GRIDWAIT A
 ⎕ERROR REPORTC err