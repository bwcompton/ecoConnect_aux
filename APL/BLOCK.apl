BLOCK N;I
⍝Initialize block reading and writing for READ and WRITE
⍝Called by script within RUN
⍝⍵ = block size (rows and cols, in cells), edge buffer
⍝Sets global block
⍝   block[1]  block size in rows
⍝   block[2]  block size in cols
⍝   block[3]  edge buffer (in cells)
⍝   block[4]  I (0 before 1st block read)
⍝   block[5]  J
⍝   block[6]  number of row blocks
⍝   block[7]  number of column blocks
⍝   block[8]  rows in last block
⍝   block[9]  cols in last block
⍝   block[10] line number of BLOCK statement in RUN (used by Habit@ for looping over years)
⍝   block[11] block number, set by HABGEN, NEXTBLOCK, and BLOCKREPS
⍝   block[12] total number of blocks, set by BLOCKRUN and BLOCKREPS
⍝All grids must be exactly the same size or very bad things will happen
⍝Coordinated block stuff happens in RUN, READ, SAVE, WRITE, and END
⍝Most of the action happens in READ (which must be done before first SAVE)
⍝From BIG (B. W. Compton, 13 Nov 2003), 2 Mar 2004
⍝23 May 2011: make ii optional



 ⍎((I←0)≠⎕NC'I')/'I←ii'             ⍝Get ii parameter if called from Habit@
 block←(3↑N),(6⍴0),I,1,0
 firstblock←1
 blockid←'aaa'
 →(~1∊(,⎕SI)⎕SS'TIMETEST')/L1       ⍝If called from TIMETEST,
 block[1 2]←testblock
 test←1
L1:time←⎕AI[2]