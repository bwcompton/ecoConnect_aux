BREAKCHECK;T
⍝Check for break under RUN
⍝8 Oct 2008: Give it a couple of minutes to recover before breaking to deal with flaky Windows file server
⍝23 May 2011: Revised version breaks if break file exists
⍝4 Oct 2011: Avoid error trapping if running from Anthill (I'm going fishing with Lloyd tomorrow!)
⍝8 Feb 2012: Flush buffer to avoid endlessly blank windows


 FLUSH
 →(0=⎕NC'break')/0
 →(~IFEXISTS break)/0
 ⎕ELX←'⎕DM'
 ⎕ERROR 'BREAK: run halted because ',break,' was created.'