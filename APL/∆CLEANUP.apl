∆CLEANUP;Q
⍝Clean up from spread and gridio functions
⍝B. Compton, 5 Jan 2009; E. Ene, 3 Jan 2009
⍝5 Sep 2013: renamed from CLEANUP
⍝5 Feb 2024: now use gridio_lib
⍝15 Feb 2024: combined version uses both caps_lib and gridio_lib versions
⍝22 Mar 2024: if gridio/capslib aren't available, fail silently
  
  

 :if aplc=2                         ⍝If C version,
    :if 3≠⎕NC 'CLEANUP_GRIDIOc'     ⍝   If gridio version not loaded,
       Q←⎕EX 'CLEANUP_GRIDIOc'
       ⎕ERROR REPORTC 'DLL GRIDIO_LIB.clean_up()' ⎕NA 'CLEANUP_GRIDIOc'
       ⍝⎕←'GRIDIO_LIB.clean_up loaded.'
    :end

    :if 3≠⎕NC 'CLEANUP_CAPSLIBc'    ⍝   If capslib version not loaded,
       Q←⎕EX 'CLEANUP_CAPSLIBc'
       ⎕ERROR REPORTC 'DLL CAPS_LIB.clean_up()' ⎕NA 'CLEANUP_CAPSLIBc'
       ⍝⎕←'CAPS_LIB.clean_up loaded.'
    :end


    :try
       CLEANUP_GRIDIOc ''
       CLEANUP_CAPSLIBc ''
    :catchall
    :endtry
    
 :end