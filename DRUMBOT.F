\ $Workfile:   drumbot.f  $
\
\ the weird drummer guy
\
\ $Revision:   1.7  $

needs b0b           b0b.f

ifndef __SYNTH110   needs __NU110 nu110.f
ifend
needs __DRUMS110    drums110.f
needs __VOLUME      volume.f

Forth
ifdef __DRUMBOT  forget __DRUMBOT
ifend
create __DRUMBOT  .( loading drumbot.f ...) cr

variable  Drumming

: Limb:
     create    ( n n n ... count -- )     \ each n is a note, x is the # of n's 
          dup c,
          0 do c, loop
     does>     ( -- adr count )
          count 
;

bd2 bd4 2 
     Limb: lfoot          \ 2 hollow bass drums

bd1 1
     Limb: clubfoot       \ the dead bass drum

ltt1 mtt1 htt1 3
     Limb: tomhand        \ some tom toms

rcl rcm rch 3
     Limb: ridehand       \ some ride cymbals

cch ccl 2
     Limb: crashhand      \ some crash cymbals

sd1 sd2 2
     Limb: snarehand      \ main snare drum

ltt3 mtt3 mtt3 htt3 bd3 5
     Limb: rotohand       \ rototoms

\ Syntax example:   snarehand Hit
\ Hits one of the drums in the snarehand array

:ap Hit  ( adr count -- )
     ?ChangeVolume
     irnd + c@ $
;ap

\ Syntax example:
\ lfoot 1|2 64 Pound
\ Checks the lfoot every half note,,
\ and hits a random drum about 1 time in four (64/16)
\ If air is less than 17, it hits every time

:sg pulse  ( rate -- )
     begin Drumming @
     while dup & 
     repeat drop
;sg

:ap Pound  ( adr count rate air -- )
     Drumming on  
     ::ap [ 4 params ]
          swap
          ::tsg  ( rate -- )
               [ 1 params ] pulse
          ;;sg
          0 100 SetVolumeRange
          begin Drumming @
          while dup irnd 4 >>           \ divide a copy of 'air' by 16
               if   brnd if   pedon$
                         else pedoff$   \ two kinds of silence
                         then
               else -rot                \ tuck 'air'
                    2dup Hit            \ Hit a drum
                    rot                 \ 'air' to top of stack
               then
          repeat
          drop 2drop 
    ;;ap
;ap


:ap Drumbot4
     drumChannel drums /4
     crashhand Hit 
     lfoot 1|4 0 Pound
     clubfoot 128|129 0 Pound
     crashhand 7|32 180 Pound
     rest
     snarehand 1|2 0 Pound
     snarehand 64|129 0 Pound
     rest
     ::ap 8192|129 time-advance
          crashhand Hit
          Drumming off
     ;;ap
;ap

:ap Drumbot5
     drumChannel drums
     clubfoot 1|4 22 Pound
     lfoot 5|4 0 Pound
     crashhand 7|19 200 Pound
     2|4 time-advance
     snarehand 5|4 0 Pound
     snarehand 5|8 0 Pound
     1|8 time-advance
     snarehand 15|8 0 Pound
     lfoot 5|8 0 Pound
     ridehand 1|16 22 Pound
     5|8 time-advance
     snarehand 5|4 0 Pound
;ap

\ :ap SetDrumbot
\     formula
\     Techs.Band
\     drumChannel drums
\     125 beats-per-minute
\ ;ap      


