INIT_CAPS2
⍝Do 2nd round of application-specific initialization for CAPS
⍝Any calls to GRIDNAME may check for mosaics, which requires locking, which requires CONFIG
⍝B. Compton, 13 Jan 2014 (from INIT_CAPS)
⍝10 Apr 2014: rearranged to access grid fewer times
⍝14 Apr 2014: don't bother with refgrid if referencewindow is already set



 mask←(10 WAITUNTILEXISTS mask,'\')/mask←1 GRIDNAME 'mask'      ⍝Mask grid, if it exists
 mosaicref←1 GRIDNAME 'mosaicref'
 :if 0∊⍴referencewindow                                          ⍝If referencewindow hasn't been set,
    :if 0∊⍴refgrid←1 GRIDNAME 'reference'                       ⍝   If refgrid isn't set, use mosaicref
       refgrid←mosaicref
    :end
 :end