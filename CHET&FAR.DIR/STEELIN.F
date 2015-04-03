\ $Workfile:   steelin.f  $
\ $Revision:   1.0  $
\ Steelin' the Blues, rhythm tracks

needs b0b           b0b.f
needs __CHORDS      chords.f
needs __VOLUME      volume.f
needs __NU110       nu110.f
needs __BASSPAT     basspat.f

Forth
ifdef __STEELIN   forget __STEELIN
ifend
create __STEELIN  .( loading steelin.f...)  cr

quan running

:ap quickV  ( -- )       \ I V chord figure
     I    |2|  V    |2|
;ap

:ap sixbars  ( -- )      \ first 6 bars of any verse
     I    //   >Sub //   IV   //   >Dom //
     I    //   quickV
;ap

:ap sb_A  ( -- )     \ chord progression for verse
     sixbars   I    //   //     
;ap

alias sb_In sb_A         \ verse is intro

:ap sb_B  ( -- )    \ chord progression for bridge
     III  //   >Sub //   VI   //   >Sub //
     II   //   >Sub //   V    //   >Sub //
;ap

:ap sb_AAB  ( -- )  sb_A      sb_A      sb_B      ;ap
:ap sb_AABA ( -- )  sb_AAB    sb_A                ;ap

:ap sb_Amod  ( -- )    \ verse ending with VI lead-in for modulation
     sixbars
     I    |2|  VII  |4|  -VII |4|
     _Key 2 + RootKey to _Key
     V    //
;ap

:ap sb_Out  ( -- )    \ chord progression for ending
     sixbars
     quickV    quickV    I    //   -VI  //   //   I
;ap     

:ap sb_Chords  ( -- )    \ the whole song
     sb_In               \ intro
     sb_AABA             \ head in Eb
     sb_AABA             \ first jam
     sb_AAB    sb_Amod   \ second jam
     sb_AAB    sb_Out    \ head in F, ending
;ap

:ap q5_hqq     \ hqq bass part for quick5 measure
     /2   closestRoot dup to lastB      +V$
     /4   closestRoot dup               ?V$
     8th =
     if   brnd if   5th  else 6th  then
     else brnd if   3rd  
               else brnd if   5th  else 6th  then
                    RootKey  
               then
     then  dup to lastB            -V$
;ap

:ap hh?hqq
     brnd if   B_OneFive
          else B_OneFive&
          then
;ap

alias do_hqq B_OneFive&

:ap sb_bassA
     hh?hqq    do_hqq    hh?hqq    do_hqq
     hh?hqq    q5_hqq    hh?hqq    do_hqq
;ap

:ap sb_bassB
     8 0 do do_hqq loop
;ap

:ap sb_BassPart
     sb_bassA  4 0
     do   sb_bassA  sb_bassA  sb_bassB  sb_bassA
     loop
     do_hqq    do_hqq
     do_hqq    do_hqq    /1   Root $
;ap

:ap Steelin
     _Eb to _Key
     ::ap 1 to running
          sb_Chords
          0 to running
     ;;ap
     ::ap Part_4 ac.bass
          0 100 SetVolumeRange
          InitBass
          sb_BassPart
     ;;ap
;ap
