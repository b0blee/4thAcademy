\ $Workfile:   ohm.f  $
\ $Revision:   1.4  $
\ $Log:   B:/formula/vcs/ohm.f_v  $
\ 
\    Rev 1.4   27 Dec 1990 16:46:06   b0b
\ Put ?delay back in (oops).
\ Adjusted volumes and made a recording with new "Ohm2" patch.
\ 
\    Rev 1.3   04 Nov 1990 10:19:32   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.2   03 Sep 1990 18:36:06   b0b
\ Code to adjust volume pulled out into its own module, volume.f
\ 
\    Rev 1.1   03 Sep 1990 12:30:16   b0b
\ Added $minvol and $maxvol pquans to better control balance
\ Added PVCS header comment

needs b0b           b0b.f
needs __SYNTH110    synth110.f
needs __VOLUME      volume.f

Forth
ifdef __OHM  forget __OHM
ifend
create __OHM   .( loading ohm.f...) cr

\ the "Church" patch is assigned to P-59 on my U-110:
\ PART   1          2         3         4         5         6
\ MODE   L8         R8        11        4         4         4   (Mode #45)
\      bell.1   e.organ.3  a.piano.1  choir.1   choir.1   choir.1

quan ChurchSynth
quan BellChannel
quan OrganChannel
quan PianoChannel
quan CenterChoir
quan LeftChoir
quan RightChoir

: config-church-synth    
    declare-synth to ChurchSynth
    0 U-110 ['] generic-MIDI-driver    5 declare-channel to BellChannel  
    1 U-110 ['] generic-MIDI-driver    3 declare-channel to OrganChannel
    2 U-110 ['] generic-MIDI-driver   11 declare-channel to PianoChannel
    3 U-110 ['] generic-MIDI-driver    4 declare-channel to CenterChoir
    4 U-110 ['] generic-MIDI-driver    4 declare-channel to LeftChoir
    5 U-110 ['] generic-MIDI-driver    4 declare-channel to RightChoir
    U-CTRL
      U-110 ['] generic-MIDI-driver     0 declare-channel drop
;


: select-church-synth
    $DSM            \ use dumb synth manager
    BellChannel to $channel      \ bell channel
    58 U-CTRL mpc ;             \ Patch #59


formula config-church-synth

:ap ?delay
     brnd
     if   1  64 irnd 55 + r>i time-advance
     then
;ap
          
pquan curtime

quan finished
quan #done

:ap ?time.change
     19 irnd 0=
     if   $channel PianoChannel =
               if   7 irnd
               else curtime 1+ dup to curtime 
               then  
          case 0 of /6   endof 
               1 of /32  endof
               2 of /16  endof
               3 of /12  endof
               4 of /8   endof
               5 of /6   endof
               6 of /4   endof
               7 of /2   endof
               /1 
               #done 1+ to #done
               #done 8 > to finished
          endcase
     then
;ap

:ap vocalrange  ( n -- n' )
     dup 43 < over 76 > or
     if   drop 0 aps
     then
;ap     

:ap major.ending
     0 aps dup dup brnd
     if   4 + swap 7 +
     else 5 - swap 8 -
     then 
     /4 $3
;ap

:ap choir.loop  ( n -- )
     begin
          finished not
     while
          ?time.change
          ?ChangeVolume
          3 irnd 
          case 0 of  +ps  vocalrange
               endof 
               1 of  -ps  vocalrange
               endof
               2 of  0 +nps
               endof
          endcase
          2 irnd 2+ 
          brnd if   +nps
               else -nps
               then
          vocalrange           
          $2
          ?delay
     repeat
     major.ending
;ap

:ap organrange  ( n -- n' )
     dup 40 < over 80 > or
     if   drop 0 aps
     then
;ap
     
:ap organ.loop
     begin 
          finished not
     while
          ?time.change
          ?ChangeVolume
          brnd 
          if   +ps  vocalrange
               2 irnd 2+ +nps organrange 
               2 irnd 2+ +nps organrange 
          else -ps  vocalrange
               2 irnd 2+ -nps organrange 
               2 irnd 2+ -nps organrange 
          then
          $3
          ?delay
     repeat
     major.ending
;ap

:ap Ohm
     select-church-synth
     false to finished
     now 1+ rot 1+ rot 1+ * * rndinit
     0 to #done 
     ." Type 'done!' for premature finish. "
     g just
     30 beats-per-minute
     ::ap BellChannel to $channel
          70 100 SetVolumeRange
          c majorscale set-ps
          1|2 time-advance
          1 to curtime /6
          organ.loop
          major.ending
     ;;ap
     ::ap BellChannel to $channel
          50 70 SetVolumeRange
          g majorscale set-ps
          1 to curtime /6
          ?delay choir.loop
          major.ending
     ;;ap
     ::ap PianoChannel to $channel
          65 120 SetVolumeRange
          f majorscale set-ps
          ?delay /12 choir.loop
     ;;ap
     ::ap CenterChoir to $channel
          55 95 SetVolumeRange
          c majorscale set-ps
          1 to curtime /6
          choir.loop
     ;;ap
     ::ap LeftChoir to $channel
          50 100 SetVolumeRange
          e minorscale set-ps
          ?delay ?delay
          0 to curtime /12
          choir.loop
     ;;ap
     ::ap RightChoir to $channel
          50 100 SetVolumeRange
          a minorscale set-ps
          ?delay ?delay
          0 to curtime /12
          choir.loop
     ;;ap
;ap

:ap Done!
     true to finished
;ap
