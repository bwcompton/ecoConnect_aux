SETCACHE N
⍝Turn grid server caching on (⍵=1) or off (⍵=0)
⍝But stay in localmode if cluster=0!
⍝B. Compton, 10 Sep 2013
⍝20 Mar 2014: don't turn off caching when running in local mode



 activeconnection[4]←N∨~cluster