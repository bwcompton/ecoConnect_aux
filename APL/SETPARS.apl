∆M SETPARS ∆X;∆I;∆T;∆E;null;∆N;NO;No;no;YES;Yes;yes
⍝Read & set parameters from character vector ⍵; use ⍺ in error message
⍝Sets global variable ∆set with all newly set variables
⍝B. Compton, 5 May 2011, from READPARS (13 Nov 2007)
⍝23 Jan 2012: strip [metric]
⍝6 Sep 2013: create ∆set
⍝13 Mar 2014: treat ; but not # as comments



 NO←No←no←~YES←Yes←yes←1
 ⍎(0=⎕NC'∆M')/'∆M←''Error in parameter: '''
 null←⍳0
 ∆X←VTOM ('.',⎕TCHT,'.') TEXTREPL ⎕TCNL,∆X
 ∆X←VTOM REPLACESYM MTOV ∆X
 ∆E←0 0⍴''
 ∆I←0
 ∆N←∆T←⍳0
 ∆N←FRDBL¨↓⎕NL 2
L1:→((1↑⍴∆X)<∆I←∆I+1)/L2            ⍝For each parameter,
 ∆T←∆X[∆I;]
 ∆T←FRDBL (^\~∆T=';')/∆T           ⍝   Strip comments (;)
 ∆T←(~^/'[]'=(1↑∆T),¯1↑∆T)/∆T       ⍝   and strip [metric]
 →(^/∆T=' ')/L1                     ⍝   If anything left
:Try
 ⍎∆T                                ⍝      Execute it
:CatchAll
 ∆E←∆E OVER ∆M,∆T
:EndTry
 →L1

L2:∆set←MIX (FRDBL¨↓⎕NL 2)~∆N       ⍝List of variables we've just set
 →(0∊⍴∆E)/0
 ⎕←∆E
 FLUSH