\ $Workfile:   trump.f  $
\ $Revision:   1.4  $
\ $Log:   B:/formula/vcs/trump.f_v  $
\ 
\    Rev 1.4   04 Nov 1990 10:21:18   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.3   03 Sep 1990 22:16:54   b0b
\ added Wild.Card! - a p0p2 based jam
\ 
\    Rev 1.2   03 Sep 1990 18:54:28   b0b
\ removed Snap algorithm to a separate file, snap.f
\ 
\    Rev 1.1   03 Sep 1990 12:32:32   b0b
\ Added PVCS header comment

needs b0b           b0b.f
needs __SYNTH110    synth110.f
needs __SNAP        snap.f
needs __P0P         p0p.f

Forth
ifdef __TRUMP  forget __TRUMP
ifend
create __TRUMP  .( loading trump.f...) cr
     
quan lastun

:ap goodnote ( -- )
     lastun 16 min 3 max
     2 irnd 1+ 
     brnd
     if   + to lastun
     else - to lastun
     then
     6 irnd
     if   lastun aps 
          3 irnd 0= 
          if   Snap 
               dup _Key - 7 12 */ 1 max to lastun
          then  $
     else rest
     then
;ap


:ap /?
     6 irnd case
     0 of /4  endof
     1 of /4  endof
     2 of /12 endof
     3 of /6  endof
     4 of /8  endof
     5 of /8  endof
     endcase
;ap 

:ap SkipIntro
     8|1 time-advance
;ap

:ap SkipVerse
     16|1 time-advance
;ap

:ap Volume+-  ( range -- )
     dup 2* irnd -
     $volume b00st - 
     + -96 max -32 min 
     b00st + to $volume
;ap

:ap (trump)
     begin /? 
          10 Volume+-
          goodnote 
          comping @ not 
     until
     /2 8 irnd 8 + aps Snap $
;ap


:ap trumps
     16 irnd to lastun
     ::ap
          U-alt1 to $channel soft.tp.1
          SkipIntro
          _Key majorscale set-ps
          (trump)
     ;;ap
     ::ap
          U-alt1 to $channel soft.tp.1
          SkipIntro SkipVerse
          _Key majorscale set-ps
          (trump)
     ;;ap
     ::ap
          U-alt1 to $channel soft.tp.1
          _Key majorscale set-ps
          SkipIntro SkipVerse SkipVerse
          (trump)
     ;;ap
;ap 

:ap fini
     60 BPM goodnote 
;ap

:ap trump
     ::ap
          _Key majorscale set-ps
          comping on
          (trump) fini
     ;;ap
;ap

quan twice     false to twice        \ flag gets us out of recursion

:ap Wild.Card!   \ a p0p2-based jam
     recursive
     170 BPM p0p2
     twice
     if    1|1 time-advance
     else 13|2 time-advance
     then
     chordChannel        169 BPM trump 170 BPM trump
     7|2 time-advance
     U-alt1 to $channel  117 BPM trump
     U-alt2 to $channel  170 BPM trump
     ::ap begin comping @
          while 1|1 time-advance 
          repeat
          twice 
          if  false to twice         \ recursion exit point
          else true to twice Wild.Card!
          then
     ;;ap    
;ap
