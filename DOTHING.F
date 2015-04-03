\ $Workfile:   dothing.f  $
\
\ weird music
\
\ $Revision:   1.3  $

needs b0b           b0b.f
needs __SYNTH110    synth110.f
needs __VOLUME      volume.f

Forth
ifdef __DOTHING  forget __DOTHING
ifend
create __DOTHING  .( loading dothing.f ...) cr

quan      its
pquan     bottom

:ap ?hesitate  ( -- )
     brnd
     if   brnd
          if   1|147 time-advance ped
          else ped 1|127 time-advance
          then
     then
;ap

:ap wha  ( n -- )
     to bottom
     /1 bottom $ /4
     its 3 + 3 
     do   ?hesitate
          ?ChangeVolume
          [ forth ] i [ b0b ]      \ i may be a minor chord!
          3 / 36 irnd 
          over / * dup
          if   bottom + dup
               39 = over 52 = or   \ avoiding chinese cymbal
               if   drop pedon$    \ and hand claps in drumChannel
               else $
               then
          else drop brnd
               if   bottom $
               else pedon$
               then
          then
     loop
     /1 bottom $
     ped
;ap


:ap thing
     ::ap chordChannel  vib.3 pedon
          /12 rest
          0 50 SetVolumeRange
          41 ( f2) wha
     ;;ap
     ::ap chordChannel  vib.3 pedon
          /16 rest rest rest
          0 50 SetVolumeRange
          43 ( g2) wha
     ;;ap
     ::ap bassChannel    ac.bass
          20 100 SetVolumeRange
          33 ( a1) wha
     ;;ap
     ::ap melodyChannel   a.piano.9 pedon
          -10 50 SetVolumeRange
     \     1|16 time-advance
          41 ( f2) wha pedoff          
     ;;ap
     ::ap melodyChannel   a.piano.9 pedon
          -10 50 SetVolumeRange
     \     3|16 time-advance
          48 ( c3) wha pedoff
     ;;ap
     ::ap drumChannel    drums
          40 90 SetVolumeRange
          1|8 time-advance
          38 ( snare drum 1) wha
     ;;ap
     drumChannel drums pedon
     20 80 SetVolumeRange
     5|32 time-advance
\     69 ( cabasa) wha
     36 ( bass drum 2) wha
     1|32 time-advance
;ap


:ap SetDothing
     2 U$patch      \ patch #3 is all set up for this on my U-110
;ap

:ap DoThing
     ::ap 36 to its thing     \ 3
          72 to its thing     \ 6
          24 to its thing     \ 2 
          96 to its thing     \ 8
          12 to its thing     \ 1
           1 to its thing
     ;;ap
;ap

formula SetDothing
