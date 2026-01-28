NEWRESULTS;T
⍝Clear and (re)create results directory and CAPS 1.0 working directory
⍝Also creates AMLs to put together results from CAPS 1.0 and APL metrics
⍝B. Compton, 21 Nov 2007, 8 Jan 2008, and 15 Jan 2009


 →(~clear_results)/L1               ⍝If clear_results, clear result path
 RDIR pathR
 3 ⎕CMD 'md ',pathR

L1:⍝3 ⎕CMD 'rd ',pathW,' /S /Q'      ⍝Delete old working path

 →(aplc=2)/0                        ⍝If using ascii grids, create two amls

 NDROP pathR PATH 'makegrids.aml'
 NDROP pathR PATH 'assemble.aml'
 T←'/* assemble.aml'
 T←T OVER '/* Assemble results from CAPS metrics run in APL'
 T←T OVER '/* Generated automatically by NEWRESULTS/BLOCKRUN/WRITE, ',NOW
 T←T OVER '' OVER '&echo &brief'
 T NWRITE pathR PATH 'assemble.aml'