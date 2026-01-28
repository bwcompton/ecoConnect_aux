CACHEWAIT A
⍝Set global cachewait
⍝B. Compton, 21 Nov 2014 (from GRIDWAIT)



 ⍎(0=⎕NC'cachewait')/'cachewait←0'
 cachewait←cachewait+⎕AI[2]-A