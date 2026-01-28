GETLAUNCHPROJECT;T;S;I;W;⎕ELX;N
⍝Copies everything needed to launch an project in Anthill into the workspace
⍝Requires globals:
⍝   aplworkspace        Full path to ANTHILL workspace
⍝                       Look around if this doesn't exist
⍝Only this function needs to be in calling workspace
⍝Calling sequence:
⍝   )COPY g:\aplws\anthill GETLAUNCHPROJECT
⍝   aplworkspace←'g:\aplws\anthill.w3'
⍝
⍝   GETLAUNCHPROJECT            ⍝Copy in Anthill workspace
⍝   ... LAUNCHPROJECT ...       ⍝Do what's needed to call LAUNCHPROJECT
⍝   CLEARNOKEEP                 ⍝Clean up afterwards
⍝Sets tokeep for CLEARNOKEEP, and toclear for CLEAR
⍝Collision philosophy: If there are collisions, report error messages.  Assume that I'm doing a good
⍝job of synchronizing among workspaces, so don't do any collision management beyond	giving warnings.
⍝Since I'm the only APL programmer, this is a pretty safe and workable approach.
⍝B. Compton, 16 May 2011




 ⍎(0=⎕NC'aplworkspace')/'aplworkspace←'''''
 S←aplworkspace 'g:\aplws\anthill.w3' 'x:\anthill\anthill.w3'  ⍝Places to look for Anthill workspace
 I←0
L1:⎕ERROR ((I←I+1)>⍴S)/'Error: Can''t find ANTHILL workspace!'
 ⎕ELX←'→L1'                                 ⍝Do IFEXISTS inline so I don't need the function
 (I⊃S) ⎕XNTIE (N←-1+0⌈⌈/∣⎕XNNUMS),64
 ⎕NUNTIE N
 ⎕ELX←'⎕DM'
 aplworkspace←I⊃S                           ⍝Found aplworkspace that exists

 →(0≠⎕NC 'tokeep')/L3                       ⍝If tokeep doesn't exist,
 tokeep←↓⎕NL 2 3                            ⍝   Create it
L3:W←(¯1+aplworkspace⍳'.')↑aplworkspace
 T←'CAREFULCOPY FRDBL FRDBL∆OBJ TELPRINT TELPRINT∆OBJ' ⎕COPY W
 toclear←CAREFULCOPY W                      ⍝Use CAREFULCOPY to report collisions
 tokeep←FRDBL¨tokeep                        ⍝Clean this up now that we have FRDBL