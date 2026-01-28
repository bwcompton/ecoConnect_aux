Z←FIXEXP X
⍝Fix goofy exponents in string ⍵, including those from R
⍝B. Compton, 10 Mar 2014



 Z←LOWTOHIX '.e+.E.E+.E.e.E' TEXTREPL ,X