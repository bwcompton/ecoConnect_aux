Z←GETNAME;T;F;⎕ELX;N;Q;X;err
⍝Return computer name
⍝B. Compton, 23 Mar 2011
⍝25 Apr 2011: will have collisions on name file!  Give it a random name.
⍝27 Apr 2011: try again if GETNAME fails
⍝14 Feb 2013: add name stripping; 22 Apr 2013: add a default for it
⍝1 Oct 2013: use global name if it's set to prevent multiple calls; 20 Nov: no, use 'computername'
⍝20 Nov 2013: Wait a half-second after ⎕CMD to allow file system to catch up
⍝19 Dec 2013: add Edi's new C version
⍝23 Feb 2021: new cluster is dsl-, not umanrc
⍝23 Mar 2021: move guts into GETFULLNAME
⍝23 Feb 2024: change computer name to lowercase, to match our new standard



 :if 0≠⎕NC 'computername'   ⍝If we already have global 'computername', use it
    Z←computername
    →0
 :end

 Z←GETFULLNAME

L2:N←'nrc-' ⋄ ⍎(0≠⎕NC 'namestrip')/'N←namestrip'
 Z←TOLOWER ((⍴N)×^/(TOUPPER N)=TOUPPER(⍴N)↑Z)↓Z
 computername←Z