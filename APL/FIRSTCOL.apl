 Z←D FIRSTCOL A;T
 ⍝Returns each row of delimited vector ⍵ up to the first ⍺ character
 ⍝ Global result REST is the remainder of each row
 ⍝12 Feb 2024: APL+Win/APL64 version
 
 
 
 ⍎(0=⎕NC'D')/'D←'' '''
 :if APL64
    Z←D FIRSTCOLa A
 :else
    A←VTOM ⎕TCNL,(⎕TCNL=1↑A)↓A
    →(⊃T←(⎕STPTR'Z A REST D')⎕CALL FIRSTCOL∆OBJ)/L1
    Z←DTB Z
    REST←LJUST 0 1↓REST
    REST←MTOV DTB REST
    Z←MTOV Z
    →0
L1: Z←'RANK ERROR' 'LENGTH ERROR' 'WS FULL' 'VALUE ERROR' 'DOMAIN ERROR'
    ⎕ERROR(1 2 3 4⍳⊃T)⊃Z
 :end
 
    
 ⍝∇ Copyright (c) 1994 Jim Weigang