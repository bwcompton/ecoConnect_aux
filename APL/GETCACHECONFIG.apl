Z←GETCACHECONFIG;T;∆set;C
⍝Read grid cache configuration info and set global cache
⍝Sets global cache to
⍝   [1] TRUE indicates caching is on (c:/cache_config.txt exists)
⍝   [2] path to local caching directory
⍝   [3] max cache size (MB, converted from GB in cache_config.txt)
⍝   [4] minimum disk space free (MB, converted from GB in cache_config.txt)
⍝   [5] number of cache index files
⍝   [6] amount of space to free when deleting grids (MB, converted from GB in cache_config.txt)
⍝B. Compton, 16 May 2016 (pulled from GETCACHEDIR)
⍝6 Nov 2017: convert cache[6] to MB here too



 :if 0=⎕NC 'cache'                          ⍝If we don't have cache yet,
    :if IFEXISTS C←'c:\cache_config.txt'    ⍝   If caching is on
        SETPARS NREAD C                     ⍝      Get cache configuration
        cache ← 1 cachepath maxsize minfree nbins deletesize  ⍝      and save it in cache
        cache[3 4 6]←cache[3 4 6]×1E3       ⍝      convert from GB to MB
        T←⎕EX ∆set
    :else                                   ⍝   else
        cache←6⍴0                           ⍝      caching is off
    :end
 :end