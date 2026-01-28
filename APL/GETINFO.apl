Z←S GETINFO F;T;Q;A;B;Z;buffer
⍝Reads five-element vector from metric function ⍵; suppress '*' in input grid names unless ⍺[1]; defer name substitution if ⍺[2]
⍝1st element = name(s) of source grids(s)
⍝2nd element = name of settings table
⍝3rd element = name(s) of result grid(s)
⍝4th element = buffer size, in cells
⍝5th element = alternate include grid (usually empty)
⍝Each metric grid must have a label 'info' where this vector is created
⍝B. Compton, 16 Jan 2009
⍝3 Feb 2011: add 5th element
⍝27 Jul 2011: Look up grid name substitutions in inputs.par(!); 3 Aug: pass path so results path comes through
⍝16 Sep 2011: Suppress '*' in optional grid names if ⍺=0
⍝6 Jan 2012: Now use separate results.par
⍝5 Mar 2013: optionally defer name substitution



 ⍎(0=⎕NC'S')/'S←0 0'
 S←2↑S
 READPARS F                             ⍝Read metric-specific parameters
 T←(Q←(∨\T ⎕SS 'info',':')/T←⎕VR TOUPPER F)⍳⎕TCNL
 →(0∊⍴Z←Q)/0
 Q←5↓T↑Q
 ⍎'Z←',Q
 Z←5↑Z,⊂''                              ⍝Add optional 5th element (1st 4 are required)
 →(0∊⍴1⊃Z)/L1
 →(1<≡1⊃Z)/L2                           ⍝If singleton,
 Z[1]←⊂('*'≠1⊃Z)/1⊃Z
 →L1                                    ⍝Else, list
L2:Z[1]←⊂(S[1]∨(1⊃Z)≠¨'*') SLASHEACH 1⊃Z⍝   Suppress * in input grid names

L1:→S[2]/0                              ⍝If we're not deferring name substitution,
 Z[1 5]←pathG pathG SUBNAME¨Z[1 5]      ⍝   Substituite names
 Z[3]←⊂pathR SUBNAMER 3⊃Z