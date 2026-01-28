Z←LOWTOHIX A;T;D
⍝Converts low minus signs to high minuses in ⍵
⍝9 May 2011: deal with real low - properly
⍝10 Mar 2014: but deal with 1E-1 properly!



 Z←(⍴A)⍴'/-0/¯0/-1/¯1/-2/¯2/-3/¯3/-4/¯4/-5/¯5/-6/¯6/-7/¯7/-8/¯8/-9/¯9/-./¯.'TEXTREPL,A
 D←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_∆⍙0123456789.'
 Z←(⍴A)⍴(⊃,/'/',¨D,¨'¯',¨'/',¨D,¨'-') TEXTREPL,Z       ⍝Undo real low -
 D←'0123456789.'
 Z←(⍴A)⍴(⊃,/'/',¨D,¨(⊂'E-'),¨'/',¨D,¨⊂'E¯') TEXTREPL,Z  ⍝But don't fail for exponents!