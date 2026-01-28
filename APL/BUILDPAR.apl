Z←BUILDPAR M
⍝Build parameters from ⍵ for BLOCKRUN and BLOCKCALL
⍝Gives quoted vector of names in ⍵, with parentheses if more than one element
⍝24 Aug 2009: if 1st element is '!', return empty string


 Z←''''' ' ⋄ →('!'≡1⊃1↑M)/0
 Z←'''',M,''' '
 →(2>≡M)/0
 Z←'''',(⊃M),''' '
 →(1=⍴,M)/0             ⍝Skip parens if 1 element
 Z←'(',(FRDBL⍕'''',¨M,¨''''),') '