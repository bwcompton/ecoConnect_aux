A COPYDIRSUB B
⍝Copy files (and subdirectories) from path ⍺ to ⍵
⍝B. Compton, 2 Jul 2012 (from COPYDIR)
⍝5 Feb 2013: add quotes around the target so & doesn't mess it up!



 3 ⎕CMD 'xcopy ',A,'*.* "',B,'" /y /e'