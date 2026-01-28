 Z←B TEXTREPL A;T;R;S
 ⍝Replaces strings in text ⍵ as directed by ⍺
 ⍝ The right argument is a character vector, the text to change.
 ⍝ The left argument is a segmented string containing the old phrases
 ⍝    to search for and the new phrases to replace them with.  E.g.,
 ⍝    '/OLD1/NEW1/OLD2/NEW2/OLD3/NEW3'
 ⍝9 Feb 2024: APL+Win/APL64 version


 :if APL64
    Z←B TEXTREPLa A
 :else
    S←⎕STPTR'Z A B T R R'
    R←(S,2×1↑⍴A)⎕CALL TEXTREPL∆OBJ ⍝ start with a buffer 2× the arg size
    →(0=1↑R)/0                     ⍝ usually that will do it
    →(~(1↑R)∊1 3)/L1               ⍝ If buffer overflowed or WS FULL,
    R←(S,1↑1↓R)⎕CALL TEXTREPL∆OBJ  ⍝    try again with exact size buffer
    →(0=1↑R)/0                     ⍝ If that didn't do it, signal error
L1: ⎕ERROR(2 3 4 5 7⍳''⍴R)⊃'SYNTAX ERROR' 'WS FULL' 'RANK ERROR' 'LENGTH ERROR' 'VALUE ERROR' 'DOMAIN ERROR'
 :end
 
 
 ⍝ Copyright (c) 1988, 1994 by Jim Weigang