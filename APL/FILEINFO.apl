Z←FILEINFO F;Q;D;S;E;err;A
⍝Return size (in MB) and modification date (in NOW format) of file ⍵, and free space on disk (in MB)
⍝If ⍵ is a directory (or file containing wildcards), give total size and most recent date
⍝If ⍵ doesn't exist, returns ⍳0
⍝Result:
⍝   [1] size of grid/directory (MB)
⍝   [2] modification date
⍝   [3] free space on drive (MB)
⍝WARNING WARNING WARNING!!!! This gives 'system' time, not 'local' time, so it'll disagree with the date you get from
⍝Explorer or ⎕TS if you change time zones or daylight savings time!
⍝NOTE NOTE NOTE: directory sizes are NOT recursive
⍝Stopgap APL version - we'll get C version from Edi soon
⍝B. Compton, 3 Sep 2013
⍝5 Sep 2013: give free space too
⍝6 Sep 2013: return ⍳0 if it doesn't exist
⍝16 Sep 2013: add Edi's C++ version. It doesn't work.
⍝1 Oct 2013: new vesion from Edi works
⍝1 Nov 2013: drop milliseconds
⍝23 Jan 2014: Oops: Edi's version gives 24-hour time. Push it into am/pm format.
⍝27 Nov 2017: was returning '', not ⍳0 if file wasn't found



 →(aplc=1)/L2                                       ⍝If C++ version,
 →(3=⎕NC'FILEINFOc')/L1                             ⍝   If not loaded,
 Q←⎕EX 'FILEINFOc'
 ⎕ERROR REPORTC 'DLL I4←CAPS_LIB.fileinfo(*C1,*C1←,*F8←,*I4←)' ⎕NA 'FILEINFOc'

L1:D S A ← ((50⍴' '),⎕TCNUL) 123.456 123456
 err←1↑Z←FILEINFOc ((FRDBL F),⎕TCNUL) D S A
 :if err∊¯861 ¯865 ¯866                             ⍝If file not found,
    Z←⍳0
    →0
 :end
 ⎕ERROR F REPORTC err
 Z←Z[3 2 4]
 Z[2]←⊂¯4↓FRDBL (⎕TCNUL≠2⊃Z)/2⊃Z
 Z[2]←⊂UNPARSEDATE PARSEDATE 2⊃Z                    ⍝Push dates into am/pm format
 →0


L2:Z←⍳0 ⋄ →(~IFEXISTS F)/0                          ⍝Else, APL version
 Z←3 ⎕CMD 'dir ',F,' /-c /t:W /4 > ',Q←'zzname',(FRDBL 15 0⍕?1E15),'.tmp'
 Z←NREAD Q
 NDROP Q
 Z←VTOM ⎕TCNL,Z
 E←Z[''⍴1↑⍴Z;]
 E←1E¯6×''⍴⎕FI E[23↓⍳39]
 Z←5 0↓¯2 0↓Z
 Z←(~(⊂'<DIR>')≡¨↓(LJUST Z[;21↓⍳39])[;⍳5])⌿Z        ⍝Drop directory rows - this sometimes gives date it was copied, not actual modification date
 D←↑PARSEDATE¨↓Z[;⍳21]
 D←UNPARSEDATE D[(⍒D)[1];]                          ⍝Take most recent modification date
 S←1E¯6×+/⎕FI,' ',Z[;21↓⍳39]                        ⍝Give sum of size
 Z←S D E