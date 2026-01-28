Z←∆∆F∆ CAREFULCOPY ∆∆W∆;∆∆X∆;∆∆E∆;∆∆T∆;∆∆B∆;∆∆V∆;∆∆A∆;∆∆C∆;∆∆O∆;∆∆N∆;∆∆Q∆;∆∆I∆
⍝Copy objects ⍺ (default: everything) from workspace ⍵, checking for function and variable collisions
⍝When functions or variables differ, the original versions are kept (like )PCOPY), and
⍝a warning is given.  You can use this function to synchronize two workspaces.
⍝Return a list of new functions and variables that didn't already exist in workspace.
⍝∆∆B∆. Compton, 10-17-19-20 May 2011
⍝7 Jun 2011: Excluded variables too
⍝8 Sep 2020: make robust to network errors: try 5 times if error with increasing delays



 ∆∆O∆←⎕VR¨∆∆N∆←FRDBL¨↓MATRIFY 'CAREFULCOPY BEGIN CLEAR DO TEST'   ⍝Don't copy excluded functions
 ∆∆Q∆←FRDBL¨↓MATRIFY 'version path anthilldir framework gridinitcount'         ⍝or variables


 ∆∆X∆←⎕VR¨∆∆E∆←FRDBL¨↓⎕NL 3                 ⍝Get current functions
 ∆∆A∆←⍎¨∆∆V∆←FRDBL¨↓⎕NL 2                   ⍝and variables
 ∆∆I∆←0
 ∆∆T∆←2 10 30 60 300                        ⍝Sequence of seconds to wait on error

L0:
:Try
 →(0=⎕NC'∆∆F∆')/L1                          ⍝If ⍺ supplied,
 ∆∆T∆←∆∆F∆ ⎕COPY ∆∆W∆                       ⍝   Copy specified variables and functions
 →L2
L1:∆∆T∆←⎕COPY ∆∆W∆                          ⍝Else, copy everything
L2:∆∆T∆←⎕DEF¨∆∆O∆
:CatchIf 'WS NOT FOUND'≡12↑⎕DM
 ⎕ERROR 'Error: workspace ',∆∆W∆,' not found'

:CatchAll
 ⎕ERROR (5<∆∆I∆←∆∆I∆+1)/'Error: can''t copy workspace ',∆∆W∆
 ⍞←(∆∆I∆=1)/⎕DM,⎕TCNL
 ⎕←'⎕COPY failure #',(⍕∆∆I∆),'--waiting ',(⍕∆∆T∆[∆∆I∆]),' seconds and trying again...' ⋄ FLUSH
 SINK ⎕DL ∆∆T∆[∆∆I∆]
 →L0

:EndTry
 ∆∆B∆←~(DEB¨⎕VR¨∆∆E∆)≡¨DEB¨∆∆X∆             ⍝Function collisions
 ∆∆B∆←∆∆B∆^~∆∆E∆∊∆∆N∆                       ⍝Don't report excluded functions
 ∆∆C∆←~(⍎¨∆∆V∆)≡¨∆∆A∆                       ⍝Variable collisions

 Z←FRDBL¨((FRDBL¨↓⎕NL 3)~∆∆E∆),(FRDBL¨↓⎕NL 2)~∆∆V∆    ⍝Stuff copied in

 →(~1∊∆∆B∆)/L3                              ⍝If any function collisions,
 ⎕←'Warning (CAREFULCOPY): function collisions in copy from ',∆∆W∆,':'
 ⎕←' ',' ',' ',(100⌊⎕PW-3) TELPRINT FRDBL ∆∆B∆⌿MIX ∆∆E∆
 ∆∆T∆←⎕DEF¨∆∆B∆⌿∆∆X∆                        ⍝Go back to original functions

L3:→(~1∊∆∆Q∆←∆∆C∆^~∆∆V∆∊∆∆Q∆)/L4             ⍝If any variable collisions
 ⎕←'Warning (CAREFULCOPY): variable collisions in copy from ',∆∆W∆,':'
 ⎕←' ',' ',' ',(100⌊⎕PW-3) TELPRINT FRDBL ∆∆Q∆⌿MIX ∆∆V∆
L4:⍎(⍕'∆∆T∆',∆∆C∆/∆∆V∆),'←1,∆∆C∆/∆∆A∆'        ⍝Go back to orginal variables