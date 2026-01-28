A COPYDIR B
⍝Copy files (but not folders) from path ⍺ to ⍵
⍝B. Compton, 11 Aug 2011
⍝14 Mar 2012: use /y!
⍝5 Feb 2013: add quotes around the target so & doesn't mess it up!



 3 ⎕CMD 'xcopy ',A,'*.* "',B,'" /y'