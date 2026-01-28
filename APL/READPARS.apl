∆F READPARS ∆M;∆X;∆I;∆T;∆Q;fn;⎕ELX;∆J;null;tablepath;∆S;no;yes;Yes;YES;No;NO
⍝Read & set parameters for metric ⍵ (or from redirectreadpars) from current CAPS parameter file; fail silently if ⍺
⍝Sets variables and returns global set with list
⍝Parameters are in global pars
⍝Adds new parameters to global set to make them easy to get rid of
⍝If override_pars is present, use its values to replace those in parameters.par (can use EXTRACTPARS to get pars for a metric)
⍝B. Compton, 13 Nov 2007
⍝10 Sep 2010: override_pars are set on top of those in parameters.par
⍝28 Jun 2011: Add silent fail
⍝11-12 Aug 2011: don't localize pathI; use tablepath instead
⍝11 Apr 2012: use PULLPARS to capture disjunct occurances of [metric]
⍝24 Aug 2012: Use variables, not literals for yes and no
⍝13 Dec 2019: add use of brace-cases to allow selecting blocks of parameters
⍝20 Aug 2020: add redirectreadpars for Refugia project



 ⍎(0=⎕NC'∆F')/'∆F←0'
 BREAKCHECK
 ∆M←(1+0∊⍴redirectreadpars) ⊃ redirectreadpars ∆M   ⍝If redirectreadpars is set, read parameters from it
 null←⍳0
 NO←No←no←~YES←Yes←yes←1
 tablepath←pathM                        ⍝Default for TABLE is metric parameters path
 ∆J←0
 ∆X←VTOM ('.',⎕TCHT,'.') TEXTREPL ⎕TCNL,pars
 →(0=⎕NC'override_pars')/L1             ⍝If override_pars,
 ∆X←∆X OVER VTOM ⎕TCNL,override_pars    ⍝   Allow function to not exist in parameters.par
L1:∆S ∆X←∆M PULLPARS ∆X
 →(∆J^~∆S)/0                            ⍝Don't need to find this metric in override_pars...just exit if it isn't there
 →(~0∊⍴∆Q←(~∆S)/'Metric [',(fn←∆M),'] not in parameters file')/L7
 ⍎(0=⎕NC'set')/'set←0 0⍴'''''

 ∆X←BRACECASE ∆X                        ⍝Allow case-blocks using brackets {use name} and {name ...}; can use workspace variables
                                        ⍝with {use $variable}

 →('caps'≡TOLOWER fn)/L2                                                ⍝If we're in a metric and not setting general options,
 set←set OVER FRDBL LJUST (⍴∆X)↑(+/^\∆X≠'=')⌽((⍴∆X)⍴' '),∆X             ⍝   Global 'set' gets names of variables set
L2:∆X←VTOM REPLACESYM MTOV ∆X
 ⎕ELX←'∆Q←''Error in parameter: "'',∆T,''" (Syntax error or bad values?)'' ⋄ →L5'
 ∆I←0
L3:→((1↑⍴∆X)<∆I←∆I+1)/L4            ⍝For each parameter,
 ∆T←∆X[∆I;]
 ∆T←FRDBL (^\∆T≠';')/∆T             ⍝   Strip comments
 →(^/∆T=' ')/L3                     ⍝   Comment
 ⍎∆T
 →L3

L4:→(∆J∨0=⎕NC'override_pars')/0     ⍝If override_pars is set,
 →(0∊⍴override_pars)/0
 ∆X←VTOM ⎕TCNL,override_pars
 ∆J←1
 →L1

L5:→warn/L6                         ⍝If hard error,
L7:→∆F/0                            ⍝If silent fail, just return
 ⎕ERROR ∆Q
L6:∆Q WARN ' '                      ⍝Else, warn and continue
 →L3