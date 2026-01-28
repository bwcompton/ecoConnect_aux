CAPSx;⎕ALX;⎕SA;warn;warnings;fn;null;framework
⍝Do a CAPS run, called by code. Don't set paths.
⍝B. Compton, 23 Jul 2015 (from CAPS)



 framework←'caps'
 1 INITO ''            ⍝Initialize, but don't set paths
 (pathP PATH 'caps.log') LOG '--- Starting run of CAPS, ',NOW,' ---'
 CAPSRUN
 →0


check:CHECKVAR 'example blocks friskonly checkland timestamp cluster clear_results threshold gridserver landscapewide mosaics writemosaics caching zippars checkalign substmosaics'