INIT_CAPS;X
⍝Do application-specific initialization for CAPS
⍝B. Compton, 13-27 Dec 2013 (from INIT_S and CAPS)
⍝13 Jan 2014: pull calls to GRIDNAME to 2nd round, because they require CONFIG, which requires INIT_CAPS
⍝9 Sep 2014: cache synonyms.par, inputs.par, and results.par
⍝13 Jul 2015: allow setting inputs, results, landcover, and synonyms.par in parameters.par
⍝20 Aug 2020: clear redirectreadpars
⍝19 Apr 2022: don't mess with ifchat (now chatter)



⍝Set hard-wired parameters
 warn←1
 warnings←0 0⍴''
 fn←'caps'
 noread←fileptr←test←loop←block←0
 firstblock←1
 redirectreadpars←''

 inputspar←'inputs.par'                     ⍝Default paths for these, if not set in parameters.par
 resultspar←'results.par'
 synonymspar←'synonyms.par'
 landcoverpar←'landcover.par'

⍝Read options from override_pars, if present (e.g., set pathI here)
 pars←''                                    ⍝Clear pars so parameters are read only from override_pars
 1 READPARS fn←'caps'

⍝Now read parameters from paramters.par
 pathI CHECKFILE 'parameters.par'
 ⍞←warnings ⋄ ⍞←(~0∊⍴warnings)/⎕TCNL
 pars←NREAD pathI PATH 'parameters.par'

 READPARS fn←'caps'                         ⍝Read CAPS options
 synonyms←1 0 TABLE pathI PATH synonymspar  ⍝Cache synonyms.par, inputs.par, and results.par
 inputsP←1 0 TABLE pathI PATH inputspar
 resultsP←1 0 TABLE pathI PATH resultspar

 SETBREAK

 X←1↓MTOV (∨/X≠' ')⌿X←LJUST(⍴X)↑(+/^\';'≠X)⌽((⍴X)⍴' '),X←VTOM ⎕TCNL,NREAD pathI PATH landcoverpar  ⍝   Semicolons mark comments
 ⎕ERROR (','∊X)/'Commas found in landcover.par - reformatting hard drive'
 landcover←¯1 TABLE landcoverpar

 metrics←GETMETRICS
 logfile←pathP PATH 'caps.log'

 :if ~IFEXISTS pathP            ⍝If run path doesn't exist yet,
    ⎕MKDIR ¯1↓pathP             ⍝   create it
 :end