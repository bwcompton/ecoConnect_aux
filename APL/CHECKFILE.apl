P CHECKFILE F;T
⍝Look for file ⍵ (default is .par); warn if missing.  Use model path unless path is supplied in ⍺
⍝31 Mar 2022



 ⍎(0=⎕NC'P')/'P←pathI'
 →(0∊⍴FRDBL F)/0        ⍝No warning if empty string
 'Missing (or locked) parameter table:' WARN (~IFEXISTS T)/T←P PATH F EXT 'par'