\ $Workfile:   kit.f   $
\

needs b0b           b0b.f
needs __CHET&FARLEY chet&far.f

Forth
ifdef __KIT forget __KIT
ifend

create __KIT

\ the drumkit needs its' own volume controls

quan DrumVolume      75 to DrumVolume
quan dMinVolume      25 to dMinVolume
quan dMaxVolume     125 to dMaxVolume
quan dVolumeStep     25 to dVolumeStep

pquan (accent)    \ flag to play next note louder or softer

:ap Accent  1 to (accent) ;ap
:ap Uncent -1 to (accent) ;ap

: SetDrumVolumeRange ( v1 v2 -- )
    2dup 
    min to dMinVolume
    max to dMaxVolume
    dMaxVolume dMinVolume - 2/      \ range/2
    dup 2/ to dVolumeStep           \ dVolumeStep is 1/4th of the range
    dMinVolume + to DrumVolume      \ initial DrumVolume at middle of range
;

: ResetDrumVolumeRange  ( -- )
    dMinVolume dMaxVolume SetDrumVolumeRange
;

\ generate a volume louder than DrumVolume
:ap (++dv)  ( -- vol )
    DrumVolume dVolumeStep irnd +
    dMaxVolume min  
;ap

\ generate a volume softer than DrumVolume
:ap (--dv)  ( -- vol )
    DrumVolume dVolumeStep irnd -
    dMinVolume max 
;ap

\ set $volume according to DrumVolume and accent flag
:ap UseDrumVolume  ( -- )
    (accent) ?dup 
    if  0>  if   DrumVolume dVolumeStep + dMaxVolume min
            else DrumVolume dVolumeStep - ( dMinVolume max)
            then
        0 to (accent)
    else DrumVolume
    then to $volume     
;ap

\ decrease DrumVolume
:ap DecDrumVolume  ( -- )
    (--dv) to DrumVolume
;ap

\ increase DrumVolume
:ap IncDrumVolume  ( -- )
    (++dv) to DrumVolume
;ap

\ random DrumVolume changer
:ap ChangeDrumVolume  ( -- )
    brnd if   (++dv)
         else (--dv)
         then to DrumVolume
;ap

:ap ?changeDrumVolume ( -- )
    brnd if   ChangeDrumVolume  then
;ap

\ the internal random drum volume setter
:ap useDV  ( -- )
    ?changeDrumVolume UseDrumVolume
;ap

\ now define the compound drum hits

:ap Kick  ( -- )
    BothDrumsMC  useDV  (--dv) to $volume
\   35 84 85 3 $n
    35 $ 
;ap

:ap Snare ( -- )  
    BothDrumsMC  useDV  
    $volume dVolumeStep + dMaxVolume min to $volume   \ need LOUD snare
    86 88 2 $n
;ap

:ap Rim   ( -- )  
    BothDrumsMC  useDV    37 $
;ap

:ap Stick ( -- )  
    CardDrumsMC    useDV    39 $ 
;ap 

:ap Hat_c ( -- )
    U110DrumsMC     useDV    42 z$
    CardDrumsMC    useDV    90 $
;ap 

\ :ap ohh1 U110DrumsMC 46 z$ ;ap
\ :ap ohh2 U110DrumsMC 44 z$ ;ap
\ :ap ohh3 CardDrumsMC 46 z$ ;ap
\ :ap ohh4 CardDrumsMC 44 z$ ;ap

:ap Hat_o ( -- )
    U110DrumsMC     useDV  (--dv) to $volume 44 z$
    CardDrumsMC    useDV  (--dv) to $volume 44 $
;ap

59 constant hiRd    94 constant midRd   51 constant loRd
     quan lastRd    midRd to lastRd

\ Ride cymbal is usually played mid, but sometimes goes low or hi
:ap Ride ( -- )
    U110DrumsMC useDV  $volume dVolumeStep - to $volume
    2 Rand  if   midRd
            else lastRd midRd = 
                 if  brnd
                     if    loRd
                     else  hiRd
                     then
                 else lastRd    \ hi or low
                 then
            then
    dup to lastRd  $
;ap
    
\ here's a test program

variable Drumming

:ap test
    Drumming on 
    60 127 SetDrumVolumeRange
    ::ap  /12 
        begin Drumming @
        while Accent Kick |3| Uncent Kick
        repeat
        Accent Kick
    ;;ap
    ::ap  /12
        begin Drumming @
        while        Ride   rest Ride
              Accent Ride   rest Ride
                     Ride   Ride Ride
              Accent Ride   Ride Ride
              Accent Hat_o  rest Hat_c
                     Hat_c  rest Hat_c
                     Hat_o  rest Hat_c
              Accent Hat_c Hat_c Hat_c 
        repeat
    ;;ap
    ::ap  /4 rest /2
        begin Drumming @
        while brnd if   Accent else Uncent then
              brnd if   Snare Snare 
                   else Rim   Rim
                   then
        repeat
    ;;ap
;ap 
    
formula

: x Drumming off ;

