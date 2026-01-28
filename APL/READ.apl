Z←C READ F;H;T;REST;S;K;B;E;I;J;G
⍝Read grid from grid ⍵; suppress caching if ⍺
⍝Block reading version (see BLOCK for details)
⍝If block[1] > 0, read in a block from the input file
⍝If block[1] = ¯1, read arbitrary block specified by 1↓block
⍝If block[1] = 0, read entire grid
⍝If noread, don't actually read anything, just initialize block
⍝Replaces FROMARC, 2 Mar 2004.  Modified 15 Feb 2006.
⍝15 Jan 2009: modify to work with C gridio functions.  Drop zip files.
⍝21 May 2010: Read abitrary block if block[1] = ¯1
⍝9-11 Apr 2012: If running Habit@, use GRIDNAME to substitute grid names from inputs.par
⍝12 Dec 2013: drop RUNLOOP and year stuff, and add caching suppression
⍝13 Feb 2014: when called with gridname, tell GRIDNAME to throw error for out-of-date _m mosaics



 ⍎(0=⎕NC'C')/'C←0'
 ⍎(0=⎕NC'gridname')/'gridname←0'                    ⍝Default is don't call GRIDNAME
 →(~gridname)/L0                                    ⍝If running Habit@,
 F←¯2 GRIDNAME F                                    ⍝Substute names from inputs.par here
L0:→(¯1 0=1↑block)/L2,L3                            ⍝If doing a block read,
L1:Z←READBLOCK (⊂pathG PATH FRDBL F),THISBLOCK,C    ⍝   Read block
 firstblock←0
 →0

L2:Z←READBLOCK (⊂pathG PATH FRDBL F),(1↓block),C    ⍝Else, if arbitrary block read, do it
 →0

L3:Z←C READGRID pathG PATH FRDBL F                  ⍝Else, read the whole dang thing
 ⍎(0=⎕NC'buffer')/'buffer←0'                        ⍝still honor buffer
 →(buffer=0)/0
 Z←B⍪Z⍪B←(buffer,1↓⍴Z)⍴MV
 Z←B,Z,B←((1↑⍴Z),buffer)⍴MV