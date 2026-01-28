Z←C DLB A
⍝∇txt2←{chars} DLB txt1 -- Delete leading blanks {chars} from vec or mat
 ⍎(0=⎕NC 'C')/'C←'' '''
 Z←~A∊C ⋄ ⍎(2=⍴⍴A)/'Z←∨⌿Z' ⋄ Z←(∨\Z)/A