Z←G REPORTC N
⍝Report error code from one of Edi's C functions; optional grid name ⍺
⍝Relies on global errorcodes, edited from caps_lib.hpp--this must be updated when new errors are added
⍝B. Compton, 16 Jan 2008, 23 Mar 2010
⍝22 Feb 2010: Skip out quick if no error


 Z←'' ⋄ →(N=1)/0        ⍝Don't waste time when there's not an error!

⍝Z←(N≠1)/⍕N ⋄ →0 ⍝Uncomment this line to get error code; use when errorcodes is desynchronized on update

 Z←⊃(errorcodes[;2],⊂'Unknown error from C subroutine:',⍕N)[errorcodes[;1]⍳N]
 Z←((0≠⍴Z)/'DLL ERROR: '),Z
 Z←(1+1∊Z ⎕SS 'gridcannotfind') ⊃ Z 'DLL ERROR: Cannot find grid (grid is missing or damaged)' ⍝Special treatment for this one

 Z←'[',(HITOLOW ⍕N),'] ',Z  ⍝**** FOR TESTING ****
⍝ Z←'' ⋄ →0 ⍝*** TEMP, FOR USE WITH FINDGRIDERRORS



 →((0∊⍴Z)∨0=⎕NC'G')/0      ⍝If error and grid name supplied,
 Z←Z,' while accessing grid ',G