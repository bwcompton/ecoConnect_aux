P ZIP F;Z;X;W
⍝Use 7-zip to zip files ⍵ into path and file ⍺; wait for finish; display window if ⍺[2]
⍝31 Jul 2012: write temporary .bat file to get around 123 character limit to ⎕CMD arguments
⍝21 Aug 2012: optionally display window
⍝26 Apr 2013: make it actually work properly



 ⍎(0=⎕NC'P')/'P←path'
 P W ← (1+1=≡P)⊃P (P 0)

 X←'7z a -r -y -tzip ',P,'.zip ',DEB,' ',F
 X NWRITE F←pathP,'zztemp',(FRDBL 15 0⍕?1E15),'.bat'
 Z←3 1[W+1] ⎕CMD F
 NDROP F