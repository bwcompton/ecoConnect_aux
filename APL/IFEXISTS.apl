Z←IFEXISTS F;N;⎕ELX;⎕DM;E;D;S;A;Q
⍝Return 1 if file or path ⍵ exists
⍝29 Feb 2024: rewrite to use FILEINFO (old version is in OLD_IFEXISTS; if failed for directory without trailing \); drop pointless left argument



 :if 3≠⎕NC'FILEINFOc'                               ⍝If not loaded,
    Q←⎕EX 'FILEINFOc'
    ⎕ERROR REPORTC 'DLL I4←CAPS_LIB.fileinfo(*C1,*C1←,*F8←,*I4←)' ⎕NA 'FILEINFOc'
 :end

 D S A ← ((50⍴' '),⎕TCNUL) 123.456 123456
 E←1↑FILEINFOc ((FRDBL F),⎕TCNUL) D S A

 :if E=1                                            ⍝If no error,
    Z←1
 :elseif E∊¯861 ¯865 ¯866                           ⍝If file not found,
    Z←0
 :else                                              ⍝otherwise, throw an error
    ⎕ERROR F REPORTC E
 :end