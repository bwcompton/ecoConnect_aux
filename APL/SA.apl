P SA X;S;E;B;K;N;M;P;ftie;R;Z;T
⍝Simulated annealing of initial state ⍵
⍝⍵ is starting state, or x y prob
⍝Parameters ⍺:
⍝   ⍺[1] kmax - maximum number of iterations
⍝   ⍺[2] emax - maximum energy of solution
⍝   ⍺[3] annealing schedule (factor to reduce temperature)
⍝   ⍺[4] scoring parameter(s)
⍝   ⍺[5] number of cells to move when picking neighbors - I think this should be 1
⍝   ⍺[6] restart - number of iterations to allow before restarting
⍝Based on pseudocode on Wikipedia
⍝Run:
⍝   SA 40 100 10
⍝B. Compton, 31 Aug 2007


 ⍎(0=⎕NC'P')/'P←⍳0'
 P←6↑P,(⍴,P)↓100000 ¯1000 .95 2 1 100
 ⍎(2>⍴⍴X)/'X←1=?X[1 2]⍴(×/X[1 2])⍴X[3]'

 T←.01×?(⍴X)⍴100 ⋄ iei←(T+FOCALSUM T)÷1+FOCALSUM (⍴T)⍴1

⍝ (⍕iei) NWRITE PATH 'iei.txt'
⍝ ⎕NUNTIE ⎕NNUMS ⋄ '' NWRITE PATH 'sa.txt' ⋄ (PATH 'sa.txt') ⎕NTIE ftie←-1+0⌈⌈/∣⎕XNNUMS  ⍝Temp for display

 B←E←-+/,S←P[4] SA_SCORE Z←X          ⍝Energy of initial state
 SA_DISP X E 0
 R←K←0
L1:→(~(P[1]>K←K+1)^E>P[2])/L9  ⍝While time remains & not good enough,
 →(P[6]≥R-K)/L3                 ⍝   If restart counter is too high,
 X←Z ⋄ M←B                      ⍝      We've wandered too far from previous best...restart
L3:N←P[5] S SA_NEIGHBOR X       ⍝   Pick a neighbor  *** P[5] SHOULD START HIGH AND DECREASE WITH TEMPERATURE ***
 M←-+/,S←P[4] SA_SCORE N        ⍝   Score it
 →(M>B)/L2                      ⍝   Is this the new best state?
 Z←X ⋄ B←M                      ⍝      Save it
 R←K                            ⍝      Reset the restart counter
 SA_DISP Z B K
L2:⍝SA_DISP N M K
 →(~((÷1E6 1) UNIFORM 1)<SA_PROB E,M,P[3]*K)/L1   ⍝   Move to new state?
 X←N ⋄ E←M                      ⍝      Change state
 →L1
L9:⎕←'All done.'
 ASDF