Z←A MATtoSSa B;C
⍝∇segstr←{delim} MATtoSSa charmat -- Convert char mat to segmented string
⍝If the left arg omitted, ⎕TCNL is used as the delimiter
⍎(0=⎕NC 'A')/'A←⎕TCNL'
C←,1,~⌽^\⌽B=' ' ⍝ Mark the trailing blanks of each row
Z←C/,A,B