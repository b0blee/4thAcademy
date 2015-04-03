\ $Workfile:   jammers.f  $
\ $Revision:   1.1  $
\ $Log:   B:/formula/vcs/jammers.f_v  $
\ 
\    Rev 1.1   07 Nov 1990 09:15:00   b0b
\ fine tuned algorithm
\ 
\    Rev 1.0   04 Nov 1990 14:54:38   b0b
\ Initial revision.

needs   b0b         b0b.f
needs __SNAP        snap.f
needs __VOLUME      volume.f

Forth
ifdef __JAMMERS  forget __JAMMERS
ifend
create __JAMMERS  .( loading jammers.f...) cr

ifdef __INSTRUCTIONS_FOR_USE__
     
     This contains three jamming music processes: LeadJammer, 
     LoJammer, and HiJammer.  Essential setup is as follows:

     ::ap 10 80 SetVolumeRange     \ volume is not a constant
          _Key majorscale set-ps   \ the process must have a scale
          LeadJammer               \ start LeadJammer first
     ;;ap

          Jamming off    \ when done, this will turn them all off
ifend

variable Jamming    \ keep jamming while flag is true

quan lastmid        \ last scale note calculated by leadJammerNote

\ rest, or find next scale note play it
:ap leadJammerNote ( -- )
     6 irnd                   \ play or rest?
     if   ?ChangeVolume
          lastmid 14 min 3 max
          2 irnd 1+ 
          brnd if   +  else -      \ calculate next note
               then 
          dup to lastmid aps       \ traslate scale note to MIDI note 
          3 irnd 0=                \ Snap 1 out of 3 to the current chord
          if   Snap 
               dup 0 aps - 
               7 12 */             \ translate back to a scale interval
               1 max to lastmid    \ to save it
          then  
          $                        \ play 5 out of 6
     else rest                     \ rest 1 out of 6
     then
;ap


\ set timing value for next leadJammerNote
:ap /lead       
     6 irnd
     case 0 of /4  endof
          1 of /4  endof
          2 of /12 endof
          3 of /6  endof
          4 of /8  endof
          5 of /8  endof
     endcase
;ap 


\ the middle "Lead" Jammer play loop
\ Be sure to invoke him before the other jammers.
:ap LeadJammer
     Jamming on
     8 to lastmid   
     begin /lead 
          leadJammerNote 
          Jamming @ not 
     until
;ap


\ rest, or find next scale note play it
:ap loJammerNote ( -- )
     5 irnd                   \ play or rest?
     if   ?ChangeVolume
          lastmid 2 -         \ calculate next note
          brnd - brnd - 0 max
          aps                 \ translate scale note to MIDI note 
          3 irnd 0=           \ Snap 1 out of 3 to the current chord
          if   Snap 
          then  
          $                   \ play 4 out of 5
     else rest                \ rest 1 out of 5
     then
;ap


\ set timing value for next loJammerNote
:ap /lo
     6 irnd
     case 0 of /3  endof
          1 of /4  endof
          2 of /4  endof
          3 of /6  endof
          4 of /8  endof
          5 of /8  endof
     endcase
;ap 


\ The low harmonizing Jammer play loop
\ Be sure the LeadJammer is running, or this guy will be really boring.
:ap LoJammer
     begin /lo 
          loJammerNote 
          Jamming @ not 
     until
;ap


\ rest, or find next scale note play it
:ap hiJammerNote ( -- )
     7 irnd                   \ play or rest?
     if   ?ChangeVolume
          lastmid 1+          \ calculate next note
          brnd + brnd + 
          brnd + 16 min
          aps                 \ translate scale note to MIDI note 
          3 irnd 0=           \ Snap 1 out of 3 to the current chord
          if   Snap 
          then  
          $                   \ play 4 out of 5
     else rest                \ rest 1 out of 5
     then
;ap


\ set timing value for next hiJammerNote
:ap /hi
     7 irnd
     case 0 of /4  endof
          1 of /4  endof
          2 of /6  endof
          3 of /8  endof
          4 of /12 endof
          5 of /16 endof
          6 of /3  endof
     endcase
;ap 


\ The hiw harmonizing Jammer play loop
\ Be sure the LeadJammer is running, or this guy will be really boring.
:ap HiJammer
     begin /hi 
          hiJammerNote 
          Jamming @ not 
     until
;ap
