Z←H MATIN F;X;REST;S;T;C;Q;B
⍝Read mixed matrix from file ⍵.
⍝  ⍺[1] 0: No header, 1: file has header, 2: figure it out [default]
⍝  ⍺[2] Optional delimiter, otherwise commas, tabs, or spaces are used; tab is always a delimiter
⍝  ⍺[3] 1: Force all-text, ¯1: and assume missing is text
⍝  ⍺[4] 1: Don't strip comments if ⍺[4] - use this for huge files with no comments or if you want to keep semicolons in place
⍝  ⍺[5] 1: Round all numeric columns to integer
⍝Columns may be numeric or text (no internal spaces or commas allowed; don't use quotes)
⍝Anything after a semicolon is a comment (added 30 Dec 2003)
⍝Allow lower-case 'e' in exponential for compatibility with R (4 Mar 2006)
⍝If numeric cells are empty, fill in with MV (9 Mar 2006)
⍝No quotes (5 May 2006)
⍝21 Jan 09: tab is always a delimiter; ⍺[3]
⍝31 Mar 2011: Oops...delimiter & missing header troubles.
⍝14 Apr 2011: also drop double quotes (removed 11 May 2011)
⍝19 Apr 2011: allow ⍺[3]=¯1 to assume text for missing; 22 Apr 2011: make it work right
⍝20 Jan 2014: add rounding option and convert to if-else structure
⍝10 Mar 2014: missed a place for lowercase exponents, and allow 1E+1 (from R) - now use FIXEXP
⍝24 Nov 2015: when dropping trailing newlines, also drop trailing white space (eliminate spurious tabs on last line)
⍝2 Mar 2022: throw an error if any duplicated column names



 ⍎(0=⎕NC'H')/'H←2'
 C←1↑1↓(H←,H),' '                                                   ⍝Delimiter

 X←NREAD F

 :if ~(4↑H)[4]                                                      ⍝If stripping comments,
    X←1↓MTOV (∨/X≠' ')⌿X←LJUST(⍴X)↑(+/^\';'≠X)⌽((⍴X)⍴' '),X←VTOM ⎕TCNL,X  ⍝   Semicolons mark comments
 :end
 X←(-+/^\⌽X∊⎕TCNL,⎕TCHT,' ')↓X                                      ⍝Drop trailing newlines and white space
 :if ~2≤⍴H                                                          ⍝If delimiter not supplied,
    X←('/,/ /',⎕TCHT,'/ ') TEXTREPL X                               ⍝   use tab, comma, or space
 :end
 X←('/',⎕TCHT,'/',C) TEXTREPL X                                     ⍝In any case, tab is always a delimiter
⍝⍝ ⎕ERROR ((C≠' ')^∨/T[1]≠T←+/C=VTOM ⎕TCNL,X)/'Error: ragged delimiters when reading ',F  THIS DOESN'T WORK BECAUSE OF TABS BEFORE COMMENTS
 head←(H[1]>0)/(¯1+S←X⍳⎕TCNL)↑X
 X←(T←((H[1]=1)∨(H[1]=2)^(~0∊⍴X)^0∊⎕VI,' ',C MATRIFY FIXEXP head)×S)↓X     ⍝1st line is header...if any non-numeric
 head←(T≠0)/head
 ⎕ERROR ((⍴T)≠⍴UNIQUE T←↓MATRIFY head)/'MATIN: duplicated names in table header'
 X←VTOM C FIRSTCOL X
 X←((0,Q←⍴⍕MV)⌈⍴X)↑X
 X[T;⍳Q]←((⍴T←(^/X=' ')/⍳1↑⍴X),Q)⍴(Q←⍴⍕MV)↑(0≥(3↑H)[3])/⍕MV         ⍝Fill in missing values
 Z←(⎕FI FIXEXP T←' ',X)∘.+,0
 :if ~(1≠(3↑H)[3])^^/⎕VI FIXEXP T                                   ⍝If character,
    Z←((⍴T)[1],1)⍴FRDBL¨↓LJUST T
 :elseif (5↑H)[5]                                                   ⍝else if rounding numberic,
    Z←⌊.5+Z
 :end

L1:→((^/REST=⎕TCNL)^0∊⍴X←VTOM C FIRSTCOL REST)/L9
 :if ~(~0∊⍴X)^(1≠(3↑H)[3])^^/⎕VI FIXEXP ,' ',X                      ⍝If non-numeric,
    Z←Z,FRDBL¨↓LJUST X
 :else                                                              ⍝else, numeric
    X←((0,Q←⍴⍕MV)⌈⍴X)↑X
    X[T;⍳Q]←((⍴T←(^/X=' ')/⍳1↑⍴X),Q)⍴Q↑(0≥(3↑H)[3])/⍕MV             ⍝   Fill in missing values
    Z←Z,⎕FI FIXEXP ,' ',X
    :if (5↑H)[5]                                                    ⍝else if rounding numberic,
       Z[;1↓⍴Z]←⌊.5+Z[;1↓⍴Z]
    :end
 :end
 →L1

L9:→((3↑H)[3]≠¯1)/0     ⍝If all missing values are character,
 :if Z≡1 1⍴MV           ⍝   If file is empty,
    Z←0 0⍴''
 :else
   B←MV≡¨T←,Z           ⍝Else, missing to blanks
    T[B/⍳⍴B]←⊂''
    Z←(⍴Z)⍴T
 :end