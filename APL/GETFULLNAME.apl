Z←GETFULLNAME;T;F;⎕ELX;N;Q;X;err
⍝Return full computer name, with no name stripping
⍝B. Compton, 12 Sep 2013, from GETNAME
⍝2 Sep 2020: wait 1/2 sec like GETNAME; 3 Sep 2020: use local drive
⍝23 Mar 2021: pull guts from GETNAME




 →(aplc=1)/L1                                ⍝If C version,
 →(3=⎕NC'GETNAMEc')/L0                       ⍝   If not loaded,
 Q←⎕EX 'GETNAMEc'
 ⎕ERROR REPORTC 'DLL I4←CAPS_LIB.computername(*C1←)' ⎕NA 'GETNAMEc'

L0:X←(31⍴' '),⎕TCNUL
 err Z ← GETNAMEc ⊂X
 Z←FRDBL (Z≠⎕TCNUL)/Z
 ⎕ERROR REPORTC err
 →0

 ⍝APL version:
L1:Z←3 ⎕CMD 'ipconfig /all > ',F←'c:\temp\zzname',(FRDBL 15 0⍕?1E15),'.tmp'
 T←⎕DL 0.5
 Z←NREAD F
 NDROP F
 Z←(+/^\~Z ⎕SS 'Host Name')↓Z
 Z←FRDBL (¯1+Z⍳⎕TCNL)↑Z←(Z⍳':')↓Z
 →(~0∊⍴Z)/0
 ⎕←'*** Failure in GETNAME! Trying again...',⎕TCBEL
 →L1