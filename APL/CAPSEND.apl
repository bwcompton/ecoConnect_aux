CAPSEND
⍝Write end of run line to CAPSresults.log


 logfile←pathP PATH 'caps.log'
 LOG '+++++ CAPS run finished +++++'
 ('[',NOW,']  CAPS run finished') NAPPEND pathR PATH 'CAPSresults.log'