Z←CHECKPARS M;T;Q;A;B;buffer;fn;X;I;V;warn;W;call
⍝Checks the parameters of metric call ⍵, and return 1 if any errors
⍝Each metric function may a label 'check:' where parameters are checked
⍝Common constructs for check:
⍝   CHECKVAR 'vars'                 Gives warning if vars don't exist
⍝   CHECKVALUES 'key one two ...'   Makes sure that key is one of the named choices
⍝   CHECKFILE 'file'                Gives warning if file doesn't exist
⍝   CHECKCOVER 'table'              Gives warning for bogus cover types
⍝   'Message:' WARN test            Gives warning if test is nonzero
⍝Note that FRISK looks for input and settings grids separately, so no need for metrics to deal with this
⍝B. Compton, 28 Jan 2009


⍝ ⍎(0≠⎕NC'set')/'Z←⎕EX set'                  ⍝Clear parameters set by other metrics!
⍝ ↑ This isn't okay, because it nails checkland parameter in FRISK when calling MIXMETRICS from POST.
 warn←1
 W←warnings
 READPARS fn←1⊃call←M                       ⍝Read metric-specific parameters
 X←(1=V ⎕SS 'check:')/⍳⍴V←⎕VR TOUPPER 1⊃M   ⍝Zero or more check: lines
 I←0
L1:→((⍴X)<I←I+1)/L2                         ⍝For each check line,
 T←(¯1+T⍳⎕TCNL)↑T←(X[I]+5)↓V
⍝ ⎕ERROR (0∊⎕NC T)/'Undefined value: ',' 'MTOV (0=⎕NC T)⌿MATRIFY T      *** interferes with CHECKVALUE
 ⍎T
 →(warnings≡W)/L1                           ⍝If no errors, keep checking

L2:Z←~warnings≡W                            ⍝Return 1 if any errors