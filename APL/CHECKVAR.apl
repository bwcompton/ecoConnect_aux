Z←CHECKVAR V
⍝Warn if variables ⍵ are missing

 →(0∊⍴V)/0
 'Missing parameters:' WARN (2≠⊃,/⎕NC¨↓V)⌿V←MATRIFY V