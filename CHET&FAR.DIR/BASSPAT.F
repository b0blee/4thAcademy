\ $Workfile:   basspat.f  $
\ $Revision:   1.3  $
\ bass patterns

needs b0b           b0b.f
needs __CHORDS      chords.f
needs __VOLUME      volume.f
needs __NU110       nu110.f

Forth
ifdef __BASSPAT  forget __BASSPAT
ifend
create __BASSPAT  .( loading basspat.f...)  cr

quan lastB       \ last bass note played

\ constants for state machine

2 constant SUPER
5 constant SUB
7 constant DOM

quan MovingTo    \ state variable

: >Nowhere  0     to MovingTo ;
: >Super    SUPER to MovingTo ;
: >Sub      SUB   to MovingTo ;
: >Dom      DOM   to MovingTo ;


:ap InitBass  ( -- )
     _Key RootKey to lastB
     >Nowhere
;ap

:ap closestRoot  ( -- n )
     lastB Root - 6 >
     if   8th
     else Root
     then
;ap
     
:ap 6?7th  ( -- n )
     _Alt7 brnd and
     if   7th
     else 6th
     then
;ap

:ap B_OneFive  ( -- )
     /2  closestRoot         +V$
     5th RootKey             ?V$
     4th RootKey to lastB          \ in case chord doesn't change
;ap

:ap moving_hqq  ( -- lastB )  \ call only if MovingTo is set
     /2  closestRoot 
     dup to lastB            +V$   \ play downbeat Root louder
     /4 MovingTo
     case SUPER of  lastB          ?V$ 
                    lastB 1+ dup   -V$  
               endof
          SUB  of   lastB 4th RootKey <
                    if   2nd       ?V$  \ ascending
                         3rd dup   -V$
                    else lastB 8th =
                         if   7th       ?V$  \ descending
                              5th dup   -V$
                         else 7th 12 -  ?V$  \ descending
                              5th 12 - 
                                  dup   -V$
                         then
                    then
               endof
          DOM  of   lastB 5th RootKey <
                    if   3rd       ?V$   \ ascending
                         4th dup   ?V$
                    else lastB 8th =
                         if   7th       ?V$  \ descending
                              6th dup   ?V$
                         else 7th 12 -  ?V$   \ descending
                              6th 12 - 
                                  dup   ?V$
                         then
                    then
               endof
     endcase >Nowhere
;ap

:ap B_OneFive&  ( -- )
     MovingTo
     if   moving_hqq
     else /2  closestRoot     +V$  \ play downbeat Root louder
          /4  5th RootKey          \ get a 5th
          dup Root <               \  and another note
          if   6?7th RootKey            
          else 3rd
          then 
          brnd if swap then   ?V$  \ alter volume for this one
          dup                 -V$  \ play last note softer
     then
     to lastB
;ap

\ ---- Subroutines for walking /4 bass ----

:ap after5th  ( -- n )             \ quadatonic following the 5th
     brnd if   3rd  
          else 6?7th then
;ap

:ap descend  ( -- )      \ play 8th then below
     8th            ?V$
     6?7th          -V$
     5th            ?V$
     after5th  
     dup to lastB   -V$
;ap

:ap lo_descend  ( -- )   \ play Root then below
     Root           ?V$
     6?7th 12 -     -V$
     5th   12 -     ?V$
     after5th 12 - 
     dup to lastB   ?V$
;ap

:ap ascend  ( -- )       \ play Root then above
     Root           +V$
     3rd            -V$
     5th            ?V$
     after5th
     dup to lastB   -V$
;ap

:ap tossup  ( -- )       \ play Root then up or down
     brnd
     if   Root      +V$
          3rd       -V$
          5th       ?V$
          3rd  dup  -V$
     else Root           ?V$
          6?7th 12 -     -V$
          5th   12 -     ?V$
          6?7th 12 - dup -V$
     then  to lastB
;ap

:ap B_Quarters  ( -- )
     /4  lastB Root - 6 >
     if   descend
     else 3rd 12 - loR >=
          if   lo_descend
          else Root loR 6 + <
               if   ascend
               else tossup
               then
          then
     then
;ap

variable testing

: done testing off ;

:ap test
     testing on
     ::ap begin testing @
               if   I    //   I    //   IV   //   IV   //
                    I    //   V    //   I    //   I7   //
               then testing @
               if   III  //   III  //   VI   //   VI   //
                    II   //   II   //   V    //   V    //
               then testing @ not
          until I
     ;;ap
     ::ap Part_4 ac.bass
          50 100 SetVolumeRange
          InitBass
          begin 8 0 
               do   B_Quarters
               loop
               testing @ not
          until
          /1 Root $
     ;;ap
;ap

