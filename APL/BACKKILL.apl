BACKKILL X;T;B
⍝Backup grids in vector ⍵ and then kill them, if global backup=1
⍝B. Compton, 6 Oct 2014 (pulled from CAPSRUN)
⍝22 Jun 2016: I broke grid killing when backup was off!  Dummy!



 :if backup
    X←((T⍳T)=⍳⍴T)/T←TOLOWER¨X                                              ⍝Remove duplicates (multiple metrics can have same result)
    MAKEDIR¨¯1↓¨(~IFEXISTS¨T)/T←(((T⍳T)=⍳⍴T)/T←STRIPPATH¨X),¨⊂'backup\'    ⍝Create backup directories that don't exist yet
    B←(IFEXISTS¨(FRDBL¨X),¨'\')^IFEXISTS¨(STRIPPATH¨X),¨⊂'backup\'         ⍝Grids that exist in folders with backup\
    GRIDKILL¨T←((STRIPPATH¨B/X),¨⊂'backup\'),¨STRIP¨B/X                    ⍝Kill backup grids that already exist
    (B/X) GRIDCOPY¨T                                                       ⍝and copy grids to backup\
 :end

 MAKEDIR¨((T⍳T)=⍳⍴T)/T←STRIPPATH¨X                                         ⍝Make (possibly nested) result directories if they don't exist
 GRIDKILL MIX X