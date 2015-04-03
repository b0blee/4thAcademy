\ $Workfile:   psx4.f  $
\
\ Composition for Psi-seX #4
\ The basic time signature is 3 bars of 8/8 followed by 1 bar of 7/8
\
\ $Revision:   1.7  $

needs b0b           b0b.f
needs __NU110       nu110.f
needs __DRUMS110    drums110.f
needs __CHORDS      chords.f
needs __VOLUME      volume.f
needs __DRUMBOT     drumbot.f

Forth
ifdef __PSX4  forget __PSX4
ifend

create __PSX4  .( loading PSX4.f...) cr 

\ notational conveniences

:ap ?V  ( -- )      ?ChangeVolume       ;ap
:ap V$  ( n -- )    ?ChangeVolume  $    ;ap

\ the odd measures
:ap |7/8|  7|8 time-advance  ;ap
:ap |3/8|  3|8 time-advance  ;ap
:ap |p3|   3|1 time-advance  ;ap

\ basic 4 bar segment
:ap |p4|  31|8 time-advance  ;ap

variable running

\ chord progression for this song
:ap psx4_progression  ( -- )
     running on
     i    |p4| |p4| |p4|      -ii |7/8|           ( intro )  
     2 0                                          ( 2 verses )
     do   i    |p4| |p4|      i    |p4| |p4|
          ii   |p4| |p4|      ii   |p4| |p3| |2| -ii |3/8|
          i    |p4| |p4|      i    |p4| |p4|
          ii   |p4| |p4|      ii   |p4| 
          III  |1| |1|  iv |1|  -ii |7/8|         ( turnaround )
          i    |p4|
     loop
     I    |p4| |p4|   |p3|  -ii  |2| |4|  i  ( ending )
     running off 
;ap


\ distribution of bass notes:
\                             Root 8th -7th  5th  4th  3rd  2nd  lo7th
create bass_table   18 ,      4 ,  2 ,  3 ,  3 ,  1 ,  2 ,  1 ,  2 ,

\ select a bass note
:ap bass_select  ( -- n )
     bass_table trand
     case 0 of Root endof
          1 of 8th  endof
          2 of -7th endof
          3 of 5th  endof
          4 of 4th  endof
          5 of 3rd  endof
          6 of 2nd  endof
          7 of -7th 12 - endof
     endcase
;ap

:ap someRoot  ( -- n )
     Root brnd if 12 + then 
;ap

:ap some-7th  ( -- n )
     -7th brnd if 12 - then
;ap

\ the bass vamp is 4 bars long, assumes eighth notes
:ap bass_vamp  ( -- )
     3 0
     do   Root V$      Root V$
          someRoot V$  some-7th V$
          bass_select V$ bass_select V$
          Index 0> 4Rand 0= and      
          if   /6  bass_select V$ 
               /12 bass_select V$
               /8
          else bass_select V$ bass_select V$
          then
     loop
     Root V$      Root V$
     someRoot V$  some-7th V$
     5th  V$      -3rd V$
     Root V$
;ap     

:ap bass_loop
     begin running @
     while bass_vamp
     repeat
;ap

:ap bass_intro_1    \ acoustic bass
     bass_vamp 
     /1   someRoot V$ 
          someRoot V$ 
          someRoot $
     /2   someRoot V$  /8 rest rest rest  
     bass_vamp
     /2   8th V$  /8 rest bass_select V$ Root V$
;ap

:ap bass_intro_2    \  fretless electric bass 
     |p4| 
     bass_vamp
     bass_vamp
     /2   Root V$ /8 bass_select V$ rest Root V$
;ap


rcl rcm rch cch ccl 5  Limb: cymbal    \ array of cymbals

:ap !snare  ( -- )  ?V pedon sd1 sd5 2 $n  ;ap
:ap !kick   ( -- )  ?V bd1 $               ;ap

:ap ?snare  ( -- )  brnd
     if   rest
     else $volume  $minvol $vstep + to $volume
          brnd
          if   snarehand Hit 
          else brnd if   !kick
                    else cymbal Hit
                    then
          then
          ( old $volume )  to $volume 
     then
;ap

:ap ?cymb  ( -- )
     brnd if   cymbal Hit   else rest   then
;ap

:ap ?kick  ( -- )
     brnd if   !kick        else ?snare then
;ap      

:ap drum_vamp  ( -- )
     ::tsg     1|4 &  
          7 0
          do   1|4 &  1|8 &  1|8 &
          loop 
               1|8 &
     ;;sg
     !kick               !snare    !kick     rest      !snare    
     !kick     ?snare    !snare    !kick     rest      !snare
     !kick     rest      !snare    !kick     ?kick     !snare
     !kick     ?cymb     !snare    !kick     ?snare    !snare
;ap 

:ap drum_loop  ( -- )
     begin running @
     while drum_vamp
     repeat
;ap
          
:ap drum_intro  ( -- )
     3 0  do   drum_vamp      loop      \ 3 vamps
     /12 
     6 0  do   snarehand Hit  loop      \ 6 hits in half a measure
     /8 
     !snare !kick crashhand Hit         \ 3/8ths
;ap     

\ sequence generator for organ vamp
:sg organ_sg
     5|6 &  1|6 &
     brnd if   2|3 &  1|3 &   1|3 &  2|3 &
          else 1|3 &  2|3 &   2|3 &  1|3 &
          then   
     brnd if   2|3 &  5|24 &
          else 1|3 & 13|24 &
          then
;sg

:ap organ_vamp
     ::tsg organ_sg
     ;;sg
     3 0
     do   ?V Root 3rd  5th -7th  4 $n
          brnd
          if   ?V 5th 12 - Root 4th  6th  8th  5 $n
          else ?V 5th 12 - 2nd  4th  6th       4 $n
          then
     loop
     ?V 5th 12 - Root 3rd 5th -7th 5 $n
     ?V 5th 12 - -7th 12 - 4th 6th 4 $n
;ap

:ap organ_loop  ( -- )
     begin running @
     while organ_vamp
     repeat
;ap
          
:ap organ_intro
     ::tsg 7|8 &
     ;;sg
     |p4| |p4| |p4|
     5th 12 - Root 3rd 5th -7th 5 $n
;ap     


\ distribution of other notes:

create other_table   21 ,
\         8th Root -7th  5th  4th  3rd  2nd  9th  rest
          3 ,  2 ,  3 ,  3 ,  1 ,  2 ,  1 ,  3 ,  3 ,

\ select an other note
:ap other_note  ( -- n )
     other_table trand
     case 0 of      8th  V$ endof
          1 of ped  Root V$ endof
          2 of      -7th V$ endof
          3 of      5th  V$ endof
          4 of ped  4th  V$ endof
          5 of ped  3rd  V$ endof
          6 of ped  2nd  V$ endof
          7 of      9th  V$ endof
          8 of brnd if   rest 
                    else pedon$ 
                    then 
                      endof
     endcase
;ap

variable counter

:ap other_vamp
     ::tsg 15 0 do  brnd brnd or 
                    if   1|8 &  1|8  &
                    else 1|6 &  1|12 &
                    then
               loop
           1|8 &
     ;;sg 
     31 0 
     do   other_note
     loop
;ap 

:ap lead?vamp  ( f -- )
     if   other_vamp
     else /8 bass_vamp
     then
;ap   
     
:ap lead_part
     counter off /8
     -25 40 SetVolumeRange  Part_2 e.organ.9
     8 0  do   Index 0=
               if   /8 bass_vamp
               else brnd lead?vamp
               then
          loop
     50 110 SetVolumeRange  Part_3 sax.2
     80 to $volume
     9 0  do   4Rand lead?vamp
          loop  
     -10 80 SetVolumeRange  Part_2 e.organ.9
     60 to $volume
     8 0  do   Index 1+ Rand lead?vamp
               2Rand ?dup
               if   1-   if   7.0  
                         else 12.0
                         then
               else 0.0
               then  to $transpose
          loop
     12.0 to $transpose     Part_3 strings.4
     4 0  do   other_vamp
          loop
     50 115 SetVolumeRange
     12.0 to $transpose     sax.2
     other_vamp other_vamp other_vamp /8 bass_vamp
     other_vamp other_vamp 
     /3 Root 2 - V$
     0.0 to $transpose      shaku.2  pedoff
     begin running @
     while other_vamp
     repeat
;ap 
          
:ap other_intro
     /8 Part_2 e.organ.9
     $minvol to $volume
     |p4|
     bass_vamp
     /1   someRoot V$ 
          someRoot V$ 
          someRoot $
     /2   someRoot V$  /8 rest rest rest  
     /2 Root V$
     /4 someRoot V$
     /8 rest
     $minvol $vstep 2* + to $volume  
;ap



133 beats-per-minute

:ap Psx4  ( -- )
     _E to _Key i   38 to loR  49 to hiR
     running on
     ::ap psx4_progression
     ;;ap
     ::ap Part_5  ac.bass     
          20 80 SetVolumeRange  50 to $volume /8
          bass_intro_1
          bass_loop
          /1 Part_3 
          80 to $volume shaku.2 someRoot $
     ;;ap
     ::ap Part_6  fretless.2
          -10 45 SetVolumeRange  00 to $volume /8
          bass_intro_2
          bass_loop
          /1 Root $ 
     ;;ap
     ::ap Part_1  drums
          77 127 SetVolumeRange
          drum_intro
          drum_loop
          /1 crashhand Hit !kick 
     ;;ap
     ::ap Part_4  e.organ.4  12.0 to $transpose
          -50 10 SetVolumeRange
          organ_intro
          organ_loop
          /1 Root 3rd 5th -7th 8th 5 $n
     ;;ap
     ::ap Part_3  e.organ.9
          00 50 SetVolumeRange
          other_intro
          lead_part
          /1 rest
     ;;ap
;ap

