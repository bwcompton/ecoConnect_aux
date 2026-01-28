GRIDWAIT A
⍝Set global gridwait for task manager when gridio started at ⍵ and has just finished
⍝B. Compton, 2 May 2011


 ⍎(0=⎕NC'gridwait')/'gridwait←0'
 gridwait←gridwait+⎕AI[2]-A