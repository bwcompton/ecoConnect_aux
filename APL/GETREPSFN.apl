Z←GETREPSFN F;T;Q
⍝Reads repsfn: function from metric ⍵ to be used in xREPS function
⍝Currently only implemented for TABLEREPS; will add to others as needed
⍝B. Compton, 2 Jun 2011


 T←(Q←(∨\T ⎕SS 'repsfn:')/T←⎕VR TOUPPER F)⍳⎕TCNL
 →(0∊⍴Z←Q)/0
 Z←¯1↓7↓T↑Q
 Z←FRDBL (+/^\Z≠'⍝')↑Z