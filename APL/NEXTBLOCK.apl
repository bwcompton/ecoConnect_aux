Z←NEXTBLOCK
⍝Finish with block and on to next, returning block number or 0 if done
⍝Simple non-cluster version, not called from within RUN
⍝B. Compton, 1 Oct 2008 (from END)
⍝28 Apr 2010: Call THISBLOCK just in case (4th day of June)


 Z←THISBLOCK                        ⍝Make sure blocks are initialized if 1st READ is bypassed

 firstblock←1                       ⍝For chatter message in READ
 blockid←BLOCKIDS Z←block[11]←block[11]+1
 →(block[7]≥block[5]←block[5]+1)/0  ⍝   Increment J and quit if not at end of row
 block[5]←1
 →(block[6]≥block[4]←block[4]+1)/0  ⍝   At end of row.  Increment I and quit if not done
 block[11]←block[11]-1 ⋄ Z←0        ⍝   That was last block, so we're finally done