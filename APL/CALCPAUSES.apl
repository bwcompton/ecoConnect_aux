Z←CALCPAUSES N;P;S;D;L
⍝Calculate pause length for id, thread, keys, and spacing ⍵
⍝This function returns the series of pauses to be used by the thread with the given id
⍝ the sequence is guarenteed to be unqiue for each ID up to n.
⍝   ⍵[1] = id
⍝   ⍵[2] = number of threads
⍝   ⍵[3] = number of pauses between keys = (keys-1)
⍝   ⍵[4] = wait between pauses
⍝B. Compton, 8,15 Apr 2011, from E. Plunkett, calc.pauses()


 D N P S ← N
 →(D=0)/L1              ⍝If we have a thread number,
 D←D-1                  ⍝   Assuming id's start with 1 we still want to start with zero
 L←⌈N*÷P                ⍝   Number at each level
 Z←S×L∣⌊D÷L*(P-⍳P)      ⍝   Sequence of pauses
 →0                     ⍝Else,
L1:Z←(0,3×S) UNIFORM P  ⍝   Give random sequence, 3×spacing