P LOCKINIT S;Q;err
⍝Initialize Edi's gridio functions for server ⍵ and port ⍺ (default = 3340)
⍝B. Compton, 11 Jan 2013; E. Ene, 9 Jan 2013
⍝9 Dec 2013: exit if ~cluster



 :if (0≠⎕NC 'cluster')              ⍝If cluster exists, exit if ~cluster
    →(~cluster)/0
 :end

 ⍎(0=⎕NC'P')/'P←3340'
 →(aplc=1)/0                        ⍝If C version,
 →(3=⎕NC'LOCKINITc')/L1             ⍝   If not loaded,
 Q←⎕EX 'LOCKINITc'
 ⎕ERROR REPORTC 'DLL I4←LOCK_LIB.init_lock(*C1,I4)' ⎕NA 'LOCKINITc'


L1:⍝⍞←'---> Initializing lock server...' ⋄ FLUSH
 err←LOCKINITc ((FRDBL S),⎕TCNUL) P
⍝ ⎕←'done.'
 ⎕ERROR REPORTC err