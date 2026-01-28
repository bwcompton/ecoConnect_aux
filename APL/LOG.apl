I LOG N;M;T;L
⍝Write ⍵ to log file; initialize if ⍺ (but only if no current logfile or restarting with same one)
⍝If no logfile, defer logging to buffer & write when initialized later
⍝Global timestamp controls whether to log the timestamp
⍝6 Apr 2011: Work properly when logging matrices
⍝18 Jul 2011: don't replace existing log file
⍝31 Dec 2013: lock while writing log



 ⍎(0=⎕NC'logbuf')/'logbuf←0 0⍴'''''
 ⍎(0=⎕NC'logfile')/'logfile←0 0⍴'''''
 ⍎(0=⎕NC'timestamp')/'timestamp←1'
 ⍎(' '=1↑0⍴timestamp)/'timestamp←(TOUPPER timestamp)≡''YES'''
 →(1≥⍴⍴N)/L1                            ⍝If logging a matrix,
 M←1 0↓N
 N←N[1;]

L1:N←(0≠⍴N)/(T←timestamp/'[',NOW,']  '),⎕←'.⊢.   ' TEXTREPL N
 →(0=⎕NC'M')/L2                         ⍝If argument was a matrix, write subsequent lines
 N←N,MTOV (((1↑⍴M),⍴T)⍴' '),⎕←M
L2:FLUSH
 →(0=⎕NC'I')/L4                         ⍝If no left argument, continue with old logfile
 →((0≠⍴logfile)^~I≡logfile)/L4          ⍝If log file is specified, don't allow it to change

 L←LOCKFILE logfile←I                   ⍝Get a lock on log file
 :if ~IFEXISTS logfile                  ⍝If log file doesn't exist,
    '' NWRITE logfile                   ⍝   create it
 :else
    logbuf←' '⍪' '⍪' '⍪logbuf
 :end
 (logbuf OVER N) NAPPEND logfile
 UNLOCKFILE L
 logbuf←0 0⍴''
 →0

L4:→(0=⎕NC'logfile')/L5
 →(0∊⍴logfile)/L5           ⍝If writing,
 L←LOCKFILE logfile
 N NAPPEND logfile
 UNLOCKFILE L
 →0

L5:logbuf←logbuf OVER N     ⍝If deferred logging