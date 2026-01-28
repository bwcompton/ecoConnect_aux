Z←D FMT N
⍝Format ⍵ with ⍺ digits after the decimal place, using commas
⍝B. Compton, 7 Oct 2012



 ⍎(0=⎕NC'D')/'D←2'
 :if D=0
    Z←FRDBL,'CI25' ⎕FMT N
 :else
    Z←FRDBL,('CF25.',⍕D) ⎕FMT N
 :endif