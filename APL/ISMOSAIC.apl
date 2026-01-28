Z←ISMOSAIC X;Q;Q_
⍝Return 1 if ⍵ is a mosaic under our current tiff setting
⍝B. Compton, 18 Nov 2021
⍝30 Mar 2022: self-defense FRDBL



:if IFEXISTS (FRDBL X),'\mosaicdescrip.txt'         ⍝If mosaic description exists,
   Q Q_ ← MOSAICINFO X
   Z←tiff='_tif'≡TOLOWER ¯4↑FRDBL ⊃Q[Q_ COL 'type']
:else
   Z←0
:end