Z←M FASTTILEMAP G;R;I;J;K;L;Y;N;T;Q
⍝Fast version of TILEMAP (info ⍵, mask ⍺) for landscapes that fit into memory (like Massachusetts)
⍝Return tile map, or ⍳0 if grid is too big
⍝B. Compton, 20-21 Aug 2012
⍝24 Aug 2012: rename from FASTBLOCKMAP; add tilemapinclude; negative mask elements are excluded; new maskgroup interpretations


Z←⍳0 ⋄ →0   ⍝ 10 Mar 2021: DISABLED THANKS TO BUG IN GRID SERVERS


 Z←⍳0
 Y←1 ⋄ →(~tilemapinclude)/L5                        ⍝If tilemapinclude = yes,
 →(TRY 'Y←READGRID pathG PATH 1⊃G')/0               ⍝   Read whole dang include grid, if possible
 Y←~Y∊0,MV

L5:→(0∊⍴M)/L1                                       ⍝If using mask grid,
 →(TRY 'N←0 MVREP READGRID pathG PATH M')/0         ⍝   read it
 ⍎(G[4]=MV)/'Q←Q≠MV'                                ⍝   if G[4]=MV, everything but MV is in
 Y←Y^N>0-G[4]=¯1                                    ⍝   mask is true if positive; include 0 G[4]=¯1

L1:⎕←'Using FASTTILEMAP!'

 Z←block[6 7]⍴0=⍴⍴Y
 →(0=⍴⍴Y)/0                                         ⍝If neither include grid nor mask, we're done
 I←0
L2:→(block[6]<I←I+1)/0                              ⍝For each row of blocks,
 BREAKCHECK
 J←0
L3:→(block[7]<J←J+1)/L2                             ⍝   For each column,
 DOT
 R←THISBLOCK
 K←((K≥1)^K≤1↑⍴Y)/K←(R[1]-1+R[5])+⍳R[3]+2×R[5]
 L←((L≥1)^L≤1↓⍴Y)/L←(R[2]-1+R[5])+⍳R[4]+2×R[5]
 Q←,Y[K;L]
 →((G[4]∊0 ¯1 MV)∨~∨/,Y)/L4                         ⍝      If using maskbits and there's anything in mask,
 Q←Q^,(⊖((G[4]⍴2)⊤N[K;L]))[G[4];;]                  ⍝         apply them (have to do it here so we don't blow out memory)
L4:Z[I;J]←∨/Q
 T←NEXTBLOCK
 →L3