ACTIVATECONNECTION;T;A;L;W;Q
⍝Makes the pending grid server connection the active connection
⍝B. Compton, 10-30 Sep 2013
⍝8 Oct 2013: revisions to local/server stuff
⍝16 Oct 2013: major revisions. Boehner finally surrenders on the eve of the debt ceiling. Vote tonight.
⍝21 Oct 2013: no need to call ∆CLEANUP, as ∆GRIDINIT always calls it
⍝4 Nov 2013: I had window checking clauses wrong
⍝10 Nov 2021: use ∆SETWINDOW (to active connection) instead of ∆MAKEWINDOW (part of TIFF revolution)



 A←activeconnection
 :if ~MV∊A[1 2]                                                 ⍝If have active connection & cache, do checks
    →(^/A[1 2]=A[3 4])/0                                        ⍝   If active = pending, exit
    :if A[3]=MV
       A[3]←A[1]
    :end
    :if A[4]=MV
       A[4]←A[2]
    :end

 ⍝Special case: connection not changing, cache is, and connection is local
    :if (=/A[1 3])^(≠/A[2 4])^connections[A[1];connections_ COL 'local']
       A[2]←A[4]
       →0
    :end
 :end

 L←A[4]∨connections[A[3];connections_ COL 'local']              ⍝Local mode flag
 W←⊃connections[A[3];connections_ COL 'window']                 ⍝Window in connections
 :if L                                                          ⍝If local
    ∆GRIDINIT ''                                                ⍝   use local grid server
    :if 0≠⍴W                                                    ⍝   if window isn't null,
       ∆SETWINDOW ⊃connections[A[3];connections_ COL 'refgrid']⍝      set it
    :end
 :else                                                          ⍝Else, a server connection,
    ∆GRIDINIT connections[A[3];connections_ COL 'server port log']
    :if ~connections[A[3];connections_ COL 'set']               ⍝   if not set,
       :if ~0∊⍴Q←GETWINDOW                                      ⍝      If window is set on server,
          :if ~0∊⍴W                                             ⍝         If window is set in connections
             ⎕ERROR (~(5↑Q)≡5↑W)/'Error: Window on server is different from window in connections'  ⍝            it must conform
          :else                                                 ⍝         Else,
             T←CHECKWINDOW (5↑Q) 1                              ⍝            make sure window set on server is okay
             ⎕ERROR (0=1↑T)/2⊃T
             connections[A[3];connections_ COL 'window']←⊂Q     ⍝            set window in connections
          :end
          connections[A[3];connections_ COL 'set']←1            ⍝         and set 'set'
       :else                                                    ⍝      else, not set on server,
          :if 0≠⍴W                                              ⍝         if we have a window,
             ∆SETWINDOW ⊃connections[A[3];connections_ COL 'refgrid'] ⍝            set it on the server
             connections[A[3];connections_ COL 'set']←1         ⍝            and set 'set'
          :end
       :end
    :end
 :end

 activeconnection←A[3 4],2⍴MV