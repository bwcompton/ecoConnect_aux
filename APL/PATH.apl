Z←P PATH F
⍝Return filename ⍵ with default path if none supplied
⍝8 Feb 2011: allow network paths
⍝12 Jan 2012: allow no drive letter if path is empty
⍝10 Dec 2012: format filename in case it's numeric



 ⍎(0=⎕NC'P')/'P←path'
 Z←((~('\'=1↑F)∨':'∊F)/P),F←FRDBL⍕F             ⍝Add path if no path or relative path
 Z←(((~^/'\\'=2↑Z)^~':'∊Z)/FRDBL 2↑path),Z      ⍝Make sure there's a drive letter if it's still not there (but not if \\computer\path)