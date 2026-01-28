CAPSLAUNCH X;A;B;T;P;D;Q;C;I;Y;R
⍝Launch an Antill run of CAPS for ⍵[;1] commands, ⍵[;2] reps, ⍵[;3] metric name, ⍵[;4] task maxthreads, and ⍵[;5] maxpernode
⍝Globals:
⍝   path            Base path for the project
⍝   project         Project name
⍝   priority        Cluster priority
⍝   maxthreads      Maximum number of threads for project
⍝   owner           Project owner
⍝   comment         Project comment
⍝   timelimit       Time limit (seconds)
⍝   capsworkspace   location of CAPS workspace
⍝B. Compton, 23 May 2011 (from HABLAUNCH)
⍝27 May 2011: New parameters: basepath
⍝12 Apr 2012: add onerror
⍝19 Jul 2012: allow passing in workspace
⍝18 Sep 2012: use variable for CAPS workspace location
⍝28 Sep 2012: all no metrics
⍝11 Mar 2013: add maxthreads for projects (haven't done it for tasks yet...)
⍝23 Aug 2013: call TILEMAP with dependencies
⍝4 Nov 2013: don't ping grid server any more - there may be many
⍝2 Jan 2014: set taskcost
⍝5 Sep 2014: split tasks that have more than splitsubtasks subtasks if splittasks is true
⍝15 Sep 2014: fix a bug that caused non-block metrics to be dropped when splittasks = yes
⍝28 Oct 2014: split tasks was screwed up - now fixed
⍝12 Nov 2014: was splitting tasks for non-tile metrics
⍝8 Feb 2016: add host
⍝25 May 2016: if scrambling subtasks, scramble split tasks too
⍝20-22 Jun 2016: add splittasks to table metrics (full moon solstice)
⍝28 Jul 2017: fix a couple of bugs with subtask splitting + post = yes, and subtask scrambling with splitting (Trumpcare is dead forever?)
⍝23 Jan 2020: see *** below, where there's some work to maybe do
⍝21 Apr 2021: give a reasonable error if launching nothing
⍝3 Jun 2022: add maxpernode
⍝10 Jun 2022: task maxthreads and maxpernode are passed by CAPSRUN



:if 0∊⍴X
   ⎕←'Nothing to launch!'
   →0
:end

 ⍎(0=⎕NC'project')/'project←⍳0'
 ⍎(0=⎕NC'priority')/'priority←0'            ⍝Use Anthill defaults for these if not defined
 ⍎(0=⎕NC'maxthreads')/'maxthreads←0'
 ⍎(0=⎕NC'owner')/'owner←0'
 ⍎(0=⎕NC'comment')/'comment←0'
 ⍎(0=⎕NC'timelimit')/'timelimit←0'
 ⍎(0=⎕NC'onerror')/'onerror←''kill'''
 ⍎(0=⎕NC'workspace')/'workspace←''',capsworkspace,''''
 ⍎(0=⎕NC'host')/'host←'''''


 GETLAUNCHPROJECT                           ⍝Copy in Anthill workspace

 ⍎(0∊⍴metrics)/'metrics←1 1⍴⊂''no metrics called'''
 P←'CAPS-',((1+3<1↑⍴metrics)⊃(1↓⊃,/' ',¨metrics[;1]) (⍕1↑⍴metrics),' metrics')    ⍝Default project name
 A←⊂(1+0∊⍴project) ⊃ project P              ⍝Project name
 A←A,priority                               ⍝Priority
 A←A,⊂path                                  ⍝Base path
 A←A,⊂owner                                 ⍝Owner
 A←A,⊂pathP                                 ⍝Project path
 A←A,⊂pathA                                 ⍝Anthill path
 A←A,⊂comment                               ⍝Project comment
 A←A,⊂onerror                               ⍝Onerror action
 A←A,⊂maxthreads                            ⍝Maximum number of threads in project
 A←A,⊂host                                  ⍝Project host

⍝ X←X⍪('wait' 'CAPSEND'),2 2⍴⊂''             ⍝Append command to write end of run to log file

⍝If calling TILEMAP, create new tasks and set dependency / split subtasks
 Q←(⍳2)+.×('BLOCKCALL' 'TABLECALL')∘.≡9↑¨X[;1]   ⍝tasks using (1) BLOCKCALL or (2) TABLECALL
 :if splittasks                             ⍝If splitting tasks, we'll do TILEMAPs now,
    :if 1∊Q                                 ⍝   If any are BLOCKCALL,
       ⎕←'→→→ Calling TILEMAP because splittasks = yes.  This may take quite a while...' ⋄ FLUSH
    :end
    Y←(⍴Q)⍴1
    I←0
L1: →((⍴Q)<I←I+1)/L2                        ⍝   For each task,
    :if Q[I]=1                              ⍝      If tile metric,
       ⎕←'   → Building tile map for ',⊃X[I;3] ⋄ FLUSH
       ⍎'R←',(∨\T ⎕SS 'BLOCKREPS')/T←⊃X[I;2]⍝         call TILEMAP
       Y[I]←⌈(1↑⍴R)÷splitsubtasks           ⍝         number of subtasks to split into
    :elseif Q[I]=2                          ⍝      else, if table metric,
⍝*** At this point, should peel 1st left argument from TABLEREPS from X[I;2] (assuming function:) and divide splitsubtasks
⍝    by it so we don't make more subtasks than necessary.  Only matters if we split on table metrics that have a block > 1
⍝    in metrics.par, which I think I'm not doing now anyway.
       R←1↑⍴1 PARSESUBTASK ⊃X[I;2]
       Y[I]←⌈R÷splitsubtasks                ⍝         number of subtasks to split into
    :end
    →L1
L2: X←Y⌿X                                   ⍝      split tasks
    Q←Y/Q
    X[;2]←X[;2],¨(Q≠0)\(Q≠0)/' ',¨DEB¨↓⍕splitsubtasks×(⊃,/¯1+⍳¨Y),[1.5]1  ⍝      add start and n subtasks to each
    :if scramblesubtasks                    ⍝      If we're scrambling subtasks,
       X←X[⊃,/(0,¯1↓+\Y)+¨Y?¨Y;]            ⍝         scramble within each group of split tasks too
    :end
    D←(1↑⍴X)⍴0                              ⍝   no dependencies
    C←ROUND Y/÷Y                            ⍝   task costs sum to 1 for each task
 :else                                      ⍝Else, set tasks to do TILEMAPs
    X←((((((⊂'SINK '),¨(Q←Q=1)/(X[;2]⍳¨':')↓¨X[;2]),[1.5]⊂''),⊂'Build tile map'),0),0)⍪X
    C←~(1↑⍴X)↑((+/Q)⍴1)                     ⍝   Set taskcost to exclude TILEMAP calls from project progress
    D←((+/Q)⍴0),Q\⍳+/Q                      ⍝   Set dependencies
    D[(D=0)/⍳⍴D]←⊂''
 :end

 B←X[;1 2]                                  ⍝Command and reps
 B←B,⊂'left'                                ⍝Subtask argument
 B←B,⊂'apl'                                 ⍝System
 B←B,⊂workspace                             ⍝Workspace (this one)
 B←B,timelimit                              ⍝Timelimit
 B←B,X[;3]                                  ⍝Comment is metric name
 B←B,D                                      ⍝Dependency
 B←B,X[;4]                                  ⍝Set task maxthreads, from CAPSRUN
 B←B,X[;5]                                  ⍝Set maxpernode, from CAPSRUN
 B←B,C                                      ⍝Task cost, from TILEMAP calls above


 A LAUNCHPROJECT B                          ⍝Launch the project
 ⎕←''