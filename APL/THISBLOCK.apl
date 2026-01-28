Z←THISBLOCK;B;E;I;J;K;L
⍝Return READBLOCK/WRITEBLOCK parameters for current block
⍝Also chatters if appropriate
⍝Global: block
⍝From READ 15 Jan 09
⍝26 Apr 2022: ifchat → chatter



 Z←⍳0
 →(0=1↑block)/0                     ⍝If doing a block read,
 →(block[4]≠0)/L1                   ⍝   If this is first block,
 block[4 5]←1                       ⍝      Set I,J for first block
 block[6 7]←⌈WINDOW[2 1]÷block[1 2]      ⍝      Number of blocks in grid
 block[8 9]←1+block[1 2]∣¯1+WINDOW[2 1]  ⍝      Size of last block

L1:B←block[1 2]                     ⍝   block size
 E I J←block[3 4 5]                 ⍝   buffer, I, J
 K←block[6 7]                       ⍝   number of rows, cols
 L←block[8 9]                       ⍝   size of last block
 Z←(1+B×¯1+I,J),(B[1],L[1])[1+I=K[1]],(B[2],L[2])[1+J=K[2]],E

 →(noread∨~chatter^firstblock)/0
 LOG (MODEL,YEAR),': Block ',(⍕I),',',(⍕J),' of ',(⍕K[1]),',',⍕K[2]