Z←W TILEMAP G;X;F;Q;B;REST;I;J;noread;Y;V;T;dot;L;M;A;U;C;H;E;S;N;O;K;QQQ;t
⍝Tracks empty tiles (size, buffer, maskgroup in 2 3 4⊃⍵) in for include grid 1⊃⍵ and current mask grid to save runtime; ignore mask if ⍺ or if 1⊃⍵ = '*'
⍝Globals:
⍝   tilemap         Filename to use; if '' turn off this facility
⍝   tilemapinclude  If yes, use the include grid, if no, assume it's all 1s
⍝   altmask         If not empty, this is the alternative mask name (used for jointmask from CSE_SCENARIOS)
⍝   block           Assumes BLOCK/READ have already been called for current situation
⍝   skiptilemap     If true, just return 1 (for DEBUG)
⍝On first call for a particular grid/tile/buffer, the grid will be scanned
⍝to look for empty blocks; results are saved in tilemap database.  On subsequent
⍝runs, database is used.  Delete tilemap.txt to reset database (duh).
⍝Returns binary vector corresponding to blocks in landscape.
⍝maskgroup (⍵[4]) is interpreted as follows:
⍝  > 0      indicates which bit of the mask grid is used for the mask.
⍝  = 0      all positive cells in the grid are considered unmasked
⍝  = ¯1     all cells > ¯1 are considered unmasked (zero + positive integers)
⍝  = MV     only MV cells are considered masked (in all of the above MV cells are also masked)

⍝B. Compton, 16-19 Nov 2010
⍝7 Dec 2010: Screen out blocks that are all missing, but include zeros--need this for BARRIERS.  Sigh.
⍝3 Feb 2011: Allow alternate grid names, with default of include.  Back to excluding zeros, because BARRIERS can use land.
⍝4 Apr 2011: Strip path from grid name
⍝16 Jun 2011: bug - restart blocks at 0,0
⍝21 Jun 2011: don't read if only 1 block
⍝22 Jun 2011: use local grid server to prevent bogging down
⍝27 Oct 2011: don't replace include grid with stripped version--then it can't find it if it's somewhere funny
⍝19 Jan 2012: keep full path of reference grid, in case of differing extents
⍝8 Feb 2012: oops--match case when looking up grid name!; restore block (I wish APL had leaky localization!)
⍝10 Jul 2012: respect the mask!  *** Note: if you change the mask, you'll have to delete tilemap.txt!
⍝20 Aug 2012: attempt to read the whole grid at once with FASTBLOCKMAP.  4x+ speedups.
⍝21 Aug 2012: include bitmask group in tilemap file (* all old blockmap files are obsolete!)
⍝24 Aug 2012: rename from BLOCKMAP; add tilemapinclude; store mask grid too; exclude negative mask elements; lock directory; new maskgroup interpretations
⍝4 Sep 2012: ignore mask if ⍺
⍝5 Sep 2012: Aaargh! Was exiting before releasing lock.
⍝27 Sep 2012: unlock tilemap directory if there's an error
⍝14 Jan 2013: a couple of minor bugs involving tilemapinclude and mask
⍝18 Feb 2013: I had mask grid condition switched(?!)
⍝28 Feb 2013: when setting ⎕ELX, clear RETURNLOCK so it only gets called once
⍝14 Jun 2013: call CONFIG before getting a lock
⍝26 Jul 2013: add altmask; 12 Aug 2013: don't fail if it doesn't exist
⍝1 Aug 2013: don't try to use mask grid if mask = ''
⍝20 Aug 2013: If using altmask, it gets full status as mask grid
⍝21 Nov 2013: completely revise locking scheme to keep from piling up TILEMAPs
⍝3 Jan 2014: use LOCKFILE/UNLOCKFILE
⍝9 Jan 2014: add recovery from crashes so tilemap.txt isn't screwed up
⍝28 Jan 2014: recover properly when calling TILEMAPRECOVER
⍝5 Feb 2014: read multiple tiles in each pass for a significant speed-up (2.4x for tiles of 1000, to 18.9x for tiles of 200); 20 Feb: I forgot the buffer!
⍝6 Mar 2014: include grid of '*' also turns off TILEMAP (needed for MAKEMASK)
⍝10 Jul 2014: add skiptilemap for DEBUG
⍝26 Sep 2014: altmask of '*' is treated as nomask
⍝19 Apr 2022: don't mess with ifchat (now chatter)
⍝5-7 Jul 2022: call GRIDNAME for grids (~~~)



 ⍎(0=⎕NC'W')/'W←0'
 Z←1
 :if 0≠⎕NC 'skiptilemap'
    →skiptilemap/0
 :end
 U←0
 →(0=⎕NC'tilemap')/0
 →(('*'≡1⊃G)∨(~0∊⍴blocks)∨0∊⍴tilemap)/0             ⍝If tilemap facility is turned off (or selected blocks turned on), just exit

 ⍎(0∊⍴⊃G[1])/'G[1]←⊂1 GRIDNAME ''include'''         ⍝Default grid is include
 G←4↑G,0
 G[1]←'' (1⊃G)[tilemapinclude+1]                    ⍝If tilemapinclude = no, include grid is blank
 T←'mask' ⋄ ⍎(0≠⎕NC'altmask')/'T←(1+0≠⍴altmask)⊃''mask'' altmask'
 M←(~T≡,'*')/(~W)/1 GRIDNAME T                      ⍝Mask grid (if used; set it to nothing in inputs.par to not use it ... or use ⍺=1)
 X←''

 F←pathP PATH tilemap
 A←(~cluster)∨≡/FRDBL¨TOLOWER¨pathA F               ⍝If doing a cluster run and writing to a path other than Anthill, we'll have to lock
L10:
 :if ~A
⍝    (⎕←'Locking ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread
    H←LOCKFILE (1+-(⌽F)⍳'\')↓F                      ⍝   get a lock
 :end
 →(~IFEXISTS F)/L1                                  ⍝If tilemap exists,
 X←NREAD F                                          ⍝   Read it
 Q←FRDBL¨↓VTOM TOLOWER ⎕TCHT FIRSTCOL X             ⍝   grid names
 B←Q≡¨⊂TOLOWER FRDBL 1⊃G                            ⍝   matches
 B←B^(⊂TOLOWER M)≡¨TOLOWER¨FRDBL¨↓VTOM ⎕TCHT FIRSTCOL REST    ⍝   mask grid
 B←B^G[2]=⎕FI ' ' MTOV VTOM ⎕TCHT FIRSTCOL REST     ⍝   block size matches
 B←B^G[3]=⎕FI ' ' MTOV VTOM ⎕TCHT FIRSTCOL REST     ⍝   buffer size
 B←B^G[4]=⎕FI ' ' MTOV VTOM ⎕TCHT FIRSTCOL REST     ⍝   maskgroup (0 means no mask or not in a group)
 →(~1∊B)/L1                                         ⍝   If found,
 Z←(B⌿VTOM REST)[1;]                                ⍝      get binary vector (take 1st occurence by some error there are multiples)
 :if (10↑Z)≡'working...'                            ⍝      If tilemap is being built by another task,
    :if ~A                                          ⍝         if not writing to Anthill path,
⍝        (⎕←'Unlocking (1) ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread

       UNLOCKFILE H                                 ⍝            return the lock
    :end
    ⍞←(~U)/'Waiting for another thread to build tilemap for',(⍕G),'(',NOW,')...',⎕TCNL ⋄ FLUSH

⍝
⍝    QQQ←NOW,': ',name,'.',(⍕thread),' running ',project
⍝    QQQ←QQQ OVER '   waiting for another thread to build tilemap for ',⍕⊃G
⍝    t←¯5 120↑VTOM ⎕TCNL,X ⋄ QQQ←⍕QQQ OVER ⍕' ',' ',' ',(¯5↑B),t
⍝    ⎕←QQQ ⋄ FLUSH ⋄ QQQ LOCKNWRITE pathA,'tilemap\tilemaplog.txt'
⍝

    U←1
    T←⎕DL 60                                        ⍝         sleep for a minute
    →L10                                            ⍝         and try again
 :end
 Z←⎕FI((2×⍴Z)⍴1 0)\Z                                ⍝      decode it & return
 →L9

L1:X←X,⎕TCNL,(C←⊃,/((⊂M),⍕¨G)[2 1 3 4 5],¨⎕TCHT),'working...' ⍝Else, we'll have to build tilemap. Write 'working...' to tilemap.txt

⍝ (⎕←'Writing ',C,' to ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread

 X NWRITE F
 :if ~A                                             ⍝   and return the lock
⍝        (⎕←'Unlocking (2) ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread

    UNLOCKFILE H
 :end

⍝
⍝
⍝    QQQ←NOW,': ',name,'.',(⍕thread),' running ',project
⍝    QQQ←QQQ OVER '   building tilemap for ',⍕⊃G
⍝    t←¯5 120↑VTOM ⎕TCNL,X ⋄ QQQ←⍕QQQ OVER ⍕t
⍝    ⎕←QQQ ⋄ FLUSH ⋄ QQQ LOCKNWRITE pathA,'tilemap\tilemaplog.txt'
⍝
⍝


 tilemaprecover ← A F C ⎕ELX
 ⎕ELX←'TILEMAPRECOVER ⋄ ⎕ERROR ⎕DM'                 ⍝   Set error trapping to recover if we crash while building the tile map

 L←block                                            ⍝   If only 1 block
 →(∨/block[6 7]≠1)/L5
 V←1 1⍴1
 →L4

L5:noread←0
 block[4 5]←0                                       ⍝      Reset to start of blocks
⍝ ⎕←'Building tilemap library for',(tilemapinclude)/' grid ',(1⊃G),','),' tile size ',(⍕2⊃G),', buffer ',(⍕3⊃G),', and mask group ',(⍕4⊃G),' (',(⍕block[6]),' x ',(⍕block[7]),' tiles)' ⋄ FLUSH
 Q←('grid ',1⊃G) ('mask ',M) ('tile size ',⍕2⊃G) ('buffer ',⍕3⊃G) ('mask group ',⍕4⊃G)
 Q←(tilemapinclude,(~0∊⍴M),1 1,0≠4⊃G)/Q
 ⎕←'Building tilemap library for ',(ONETWOMANY Q),' (',(⍕block[6]),' x ',(⍕block[7]),' tiles)' ⋄ FLUSH

 →(~0∊⍴V←M FASTTILEMAP G)/L4                        ⍝   If fast version fails (because grid is too big), resort to old block-by-block version,
 V←block[6 7]⍴0

⍝Now figure out how many tiles we can read at once. I think we don't care how many panes read read across--we have to do it some time.
 N←⌊(⌊16E6÷block[1]+2×block[3])÷block[2]+2×block[3] ⍝   Shoot for 16M cells (our max size).  This is how many tiles we can read.
 ⎕ERROR (N=0)/'Error: tile + buffer is too damn big!'
 ⎕←'Reading ',(⍕N⌊(⍴V)[2]),' tiles at a time (',(⍕(⍴V)[1]×⌈(⍴V)[2]÷N),' passes)...' ⋄ FLUSH

 I←0
L2:→(block[6]<I←I+1)/L4                             ⍝      For each row of tiles,
 J←0
L3:→(0∊⍴O←J+⍳N⌊block[7]-J)/L6                       ⍝         For each set of column tiles,
 block[5]←J+1                                       ⍝            starting column tile
 J←J+⍴O
 BREAKCHECK
 DOT
 S←THISBLOCK[1 2],(block[1 2]×1,⍴O),block[3]        ⍝            Starting row, col, size of block, buffer (THISBLOCK results)
 :if tilemapinclude                                 ⍝            If tilemapinclude = yes,
    Y←READBLOCK (⊂1 GRIDNAME pathG PATH 1⊃G),S      ⍝               read wide block of include grid
    Y←~Y∊0,MV                                       ⍝               included cells
 :else
    Y←1
 :end

 :if ~W∨0∊⍴M                                        ⍝               If using mask grid,
    Q←READBLOCK (⊂1 GRIDNAME pathG PATH M),S        ⍝                  read wide block of mask grid
    ⍎(G[4]=MV)/'Q←Q≠MV'                             ⍝            if G[4]=MV, everything but MV is in
    Y←Y^Q>0-G[4]=¯1                                 ⍝            mask is true if positive; include 0 G[4]=¯1
    Q←0⌈0 MVREP Q
    :if ~(G[4]∊0 ¯1 MV)∨~∨/,Y                       ⍝            If using maskbits and there's anything in mask,
       Y←Y^(⊖((G[4]⍴2)⊤Q))[G[4];;]                  ⍝               apply them
    :end
 :end

 Y←∨⌿Y                                              ⍝            Collapse out rows
 K←0
L7:→((⍴O)<K←K+1)/L3                                 ⍝            For each tile (have to loop b/c of buffers),
 V[I;O[K]]←∨/Y[((K-1)×block[2])+⍳block[2]+2×S[5]]   ⍝               This tile is in if any data in it
 →L7

L6:block[4]←block[4]+1                              ⍝   Increment tile row
 →L2


L4:⎕←⎕TCNL,'Tile map:'
 ⎕←' ',' ',' ',1 0⍕V
 ⎕←'' ⋄ FLUSH
 G[1]←⊂1⊃G                                          ⍝Strip path from grid name (a little dangerous?)
 block←L                                            ⍝Restore block to its original value

 ⎕ELX←4⊃tilemaprecover                              ⍝We're good--turn off error trapping
 :if ~A
⍝    ('Locking (F) ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread

    H←LOCKFILE (1+-(⌽F)⍳'\')↓F                      ⍝Get the lock again
 :end
 X←VTOM ⎕TCNL,NREAD F                               ⍝Read the file again

⍝
⍝    QQQ←NOW,': ',name,'.',(⍕thread),' running ',project
⍝    QQQ←QQQ OVER '   finished building tilemap for ',⍕⊃G
⍝    t←¯5 120↑X ⋄ QQQ←⍕QQQ OVER ⍕t
⍝    ⎕←QQQ ⋄ FLUSH ⋄ QQQ LOCKNWRITE pathA,'tilemap\tilemaplog.txt'
⍝


⍝ (⎕←'Finished with ',C,' to ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread


 I←((⊂C)≡¨↓X[;⍳⍴C])⍳1                               ⍝Find our line

 :if I>1↑⍴X
⍝     (⎕←'Error in ',C,' to ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread
 :end

 Q←C,1 0⍕Z←,V
 X←((1↑⍴X),(1↓⍴X)⌈⍴Q)↑X                             ⍝Replace it
 X[I;]←(1↓⍴X)↑Q
 X←1↓MTOV X
 X NWRITE F                                         ⍝And write it

⍝
⍝    QQQ←NOW,': ',name,'.',(⍕thread),' running ',project
⍝    QQQ←QQQ OVER '   written tilemap for ',⍕⊃G
⍝    t←¯5 120↑VTOM ⎕TCNL,X ⋄ QQQ←⍕QQQ OVER ⍕t
⍝    ⎕←QQQ ⋄ FLUSH ⋄ QQQ LOCKNWRITE pathA,'tilemap\tilemaplog.txt'
⍝
⍝

L9:→A/0                                             ⍝If writing to a path other than Anthill,
⍝        (⎕←'Unlocking (3) ',F,' (',(⍕3↓⎕TS),')') GETLOCK thread

 UNLOCKFILE H                                       ⍝   unlock directory