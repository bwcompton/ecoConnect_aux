A LOCKWRITE F;P;T;L
⍝Append vector or matrix ⍺ to text file ⍵ (optional delimiter 2⊃⍵); lock file if running on cluster
⍝B. Compton, 21 May 2010, pulled from MOVEPOOLS
⍝24 May 2011: use Anthill lock mechanism
⍝19 Apr 2012: use 5 minute timeout in case a writing thread gets KILLed; 9 Jan 2014: drop timeout
⍝5 Jun 2012: don't bother if empty input
⍝27 Sep 2012: unlock directory if there's an error
⍝28 Feb 2013: when setting ⎕ELX, clear RETURNLOCK so it only gets called once
⍝28 Feb 2013: don't confuzzle delimiter with key
⍝3 Mar 2013: wait 1/10 sec after writing to give OS time to release the file (experimental)
⍝31 Dec 2013: don't need to set thread; this now happens in GETLOCK
⍝3 Jan 2014: use LOCKFILE/UNLOCKFILE



 →(0∊⍴A)/0
 →cluster/L1                                ⍝Write new to result table (single machine version)
 A TMATAPPEND F
 →0

L1:P←F ⋄ ⍎(2≤≡F)/'P←1⊃F'
 L←LOCKFILE (1+-(⌽P)⍳'\')↓P                 ⍝Cluster version - lock file while writing
 A TMATAPPEND F
 T←⎕DL .1                                   ⍝Give OS a little time to release file
 UNLOCKFILE L