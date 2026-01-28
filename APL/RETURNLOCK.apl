RETURNLOCK X;T;R;M;A;Q;err
⍝Return lock for key, thread/requestor, message ⍵
⍝Arguments:
⍝   ⍵[1] = key          directory or key (default = pathA)
⍝   ⍵[2] = thread       id of the current thread / requestor name (default = name.thread)
⍝   ⍵[3] = message      message for lock server & log
⍝Globals:
⍝   pathA               default cluster path; used if not passed in ⍺
⍝   name                computer name
⍝B. Compton, 12 Feb 2013, from UNLOCKDIR and previous version of RETURNLOCK (11-16 Jan 2013)
⍝11 Oct 2013: make sure thread is text!
⍝9 Dec 2013: exit if ~cluster



 :if (0≠⎕NC 'cluster')              ⍝If cluster exists, exit if ~cluster
    →(~cluster)/0
 :end

 ⍎(1≥≡X)/'X←,⊂X'
 T←'0' ⋄ ⍎(0≠⎕NC'thread')/'T←thread'
 A R M ← 3↑X,(⍴,X←((X≡,⊂,0)∨X≡,0)↓X)↓pathA T ''

 →uselockserver/L1                          ⍝If uselockserver = 0,
 A UNLOCKDIR 0
 →0                                         ⍝Else,

L1:⍎((0≠⎕NC'computername')^0=1↑0⍴R)/'R←computername,''.'',⍕R'⍝   default requestor
 R←⍕R
 ⍎(0∊⍴M)/'M←1↓FIRSTCOL STRIP ⎕WSID'         ⍝   default message
 M←M,' (APL)'                               ⍝   append (APL) to message

 →(3=⎕NC'RETURNLOCKc')/L2                   ⍝   If not loaded,
 Q←⎕EX 'RETURNLOCKc'
 ⎕ERROR REPORTC 'DLL I4←LOCK_LIB.release_lock(*C1,*C1,*C1)' ⎕NA 'RETURNLOCKc'

L2:⍝⎕←'   [Returning lock]' ⋄ FLUSH
 err←RETURNLOCKc (FRDBL A) R M,¨⎕TCNUL
 ⎕ERROR REPORTC err