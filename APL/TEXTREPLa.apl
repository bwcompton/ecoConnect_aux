Z←L TEXTREPLa R;⎕IO;A;B;C;D;E;F;G;H;I;J
⍝∇res←'/old1/new1/old2/new2/...' TEXTREPLa text -- Replace characters in text
⍝∇Copyright 2004 Sykes Systems, Inc. 23Aug2004 ⊂MACFNS⊃
⍝12 Feb 2024: revisions (**) by B. Compton to work with EVLEVEL=1



 ⎕IO←0 ⋄ F←(Z←R←1/R)⍳L⍳⍬      ⍝ implicit valence and rank error checking
:if 82≡⎕DR R                  ⍝ ok if R chr
:else
    A←÷82≡⎕DR Z←R←R,''        ⍝ coerce empty R to chr, else domain error
:endif
:if 82≡⎕DR L                  ⍝ of if L chr
:else
    A←÷82≡⎕DR L,''            ⍝ domain error if L neither chr nor empty
   :return                    ⍝ else done (no strings)
:endif
 (B A)←0 2⊤''⍴⍴L←(L=D←''⍴1↑L) ⎕PENCLOSE L   ⍝ B=number of pairs and D=delimiter  ** REVISED
:if A
    ⎕ERROR'LENGTH ERROR (unpaired strings)'
:endif
 I←⍴⍴J←⍳⍴R                    ⍝ (I≡,3-2 and J≡⍳⍴R are a bit of tweaking)
 C←⍳B ⋄ A←L[E←C+C] ⋄ L←L[I+E] ⍝ A=search strings, L=replacement strings
⍝---------------------------------------------------------LOCATE MATCHES:
:for C :in C
   :if I≡G←⍴B←I↓C⊃A           ⍝ singleton B=search string special case:
       F←F,H←(R ⎕SS B)/J      ⍝ Collect indices of matches.
       E[C]←⍴H                ⍝ Collect number of matches.
       R[H]←D                 ⍝ Preclude further hits using delimiter.
   :elseif ''≡B
       ⎕ERROR'LENGTH ERROR (odd string empty)'
   :else
      :if 2≤⍴H←(R ⎕SS B)/J    ⍝ H=indices of matches (hits)
         :while 1∊B←G>(I↓H)-¯1↓H   ⍝ only if overlapping matches (rare):
             H←(1,B≤¯1↓0,B)/H ⍝ Delete overlaps preceded by non-overlaps.
         :endwhile
      :endif
       F←F,H                  ⍝ F=first index of all matches ((⍴F)=+/E)
       E[C]←⍴H                ⍝ E=number of matches each search string
       R[H∘.+⍳G]←D            ⍝ Mark matches in R with D=delimiter to ...
   :endif                     ⍝ ... preclude further matches (because ...
:endfor                       ⍝ ... D cannot be part of a search string).
⍝---------------------------------------------------------CHANGE MATCHES:
:if F≡A←B←C←G←H←J←⍬           ⍝ done if no matches (and free storage)
:else
    Z[F]←D       ⍝ Z simple   ⍝ mark first character of all matches in Z
    R←(Z ⎕SS D)≥R ⎕SS D       ⍝ flag nonmatches and first chr of matches
    Z[F]←E/I↓¨L  ⍝ Z nested   ⍝ insert replicated replacements at indices
    D←E←F←I←L←⍬               ⍝ free storage (we're in WS FULL territory)
    Z←R/Z                     ⍝ delete 2nd and subsequent chrs of matches
    Z←⊃,/Z                    ⍝ flatten to chrvec   ** REVISED
:endif