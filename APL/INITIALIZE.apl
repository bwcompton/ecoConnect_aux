A INITIALIZE F;X;V;I;T;tilesize
⍝Reads init: label from metrics ⍵ and executes code
⍝B. Compton, 17 Feb 2010
⍝3 Feb 2011: rewritten to allow multiple init: lines
⍝14 Mar 2014: passed tile size, which we pass on to initializing line so it's available



 READPARS F         ⍝Read metric-specific parameters
 X←(1=V ⎕SS 'init:')/⍳⍴V←⎕VR TOUPPER F      ⍝Zero or more init: lines
 tilesize←A
 I←0
L1:→((⍴X)<I←I+1)/0                          ⍝For each init line,
 T←(¯1+T⍳⎕TCNL)↑T←(X[I]+4)↓V
 ⍎T
 →L1