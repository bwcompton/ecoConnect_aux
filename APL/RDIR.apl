RDIR P;T
⍝Delete path ⍵ and everything in it
⍝B. Compton, 1 Oct 2013.  Federal government is still shut down.
⍝27 Jun 2014: check for success; if folder is still there, wait a few seconds and try again
⍝24 Oct 2022: enclose name in quotes in case it has spaces or other bad stuff



 P←'"',P,'"'
 3 ⎕CMD 'rd ',P,' /S /Q'
 →(~IFEXISTS P,'\')/0               ⍝If folder still exists,
 T←⎕DL 5                            ⍝   wait a bit and try again, just once
 3 ⎕CMD 'rd ',P,' /S /Q'