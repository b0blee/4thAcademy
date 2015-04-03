\ $Workfile:   kit.f  $
\

needs b0b           b0b.f
needs __CHET&FARLEY chet&far.f
needs __DRUMVOL     drumvol.f
Forth
ifdef __KIT     forget __KIT
ifend           create __KIT

:ap Kick  ( -- )
    BothDrumsMC  useDV  dvRand- to $volume
\   35 84 85 3 $n
    35 $ 
;ap

:ap Snare ( -- )  
    BothDrumsMC  useDV  
    $volume dvStep + dvMax min to $volume   \ need LOUD snare
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
    U110DrumsMC     useDV  dvRand- to $volume 44 z$
    CardDrumsMC    useDV  dvRand- to $volume 44 $
;ap

59 constant hiRd    94 constant midRd   51 constant loRd
     quan lastRd    midRd to lastRd

\ Ride cymbal is usually played mid, but sometimes goes low or hi
:ap Ride ( -- )
    U110DrumsMC useDV  $volume dvStep - to $volume
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

:ap lt1 BothDrumsMC useDV ." lt1 " 41 $ ;ap
\ :ap ltx U110DrumsMC useDV ." ltx " 41 43 2 $n ;ap
\ :ap lt2 U110DrumsMC useDV ." lt2 " 43 $ ;ap
\ :ap lt3 U110DrumsMC useDV ." lt3 " 89 $ ;ap
\ :ap mt1 U110DrumsMC useDV ." mt1 " 45 $ ;ap
\ :ap mt2 U110DrumsMC useDV ." mt2 " 47 $ ;ap
:ap mtx U110DrumsMC useDV ." mtx " 47 45 2 $n ;ap
\ :ap mt3 U110DrumsMC useDV ." mt3 " 91 $ ;ap
:ap ht1 
    U110DrumsMC ." ht1 " 48 z$ 
    CardDrumsMC useDV 48 $
;ap
\ :ap ht2 U110DrumsMC useDV ." ht2 " 50 $ ;ap
\ :ap htx BothDrumsMC useDV ." htx " 48 50 2 $n ;ap
\ :ap ht3 U110DrumsMC useDV ." lt1 " 93 $ ;ap

:ap Tom_low lt1 ;ap
:ap Tom_mid mtx ;ap
:ap Tom_hi  ht1 ;ap

\ here's a test program

variable Drumming
:sg ~/18     1|18 &  ;sg     \ eighteenth note
:ap /18  ::tsg begin ~/18  again ;;sg ;ap
:sg ~/9     1|9 &  ;sg       \ ninth note
:ap /9  ::tsg begin ~/9  again ;;sg ;ap

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
    ::ap  /24
        begin Drumming @
        while brnd
            if   18 0 do rest loop
            else brnd if 4 0 do Uncent Tom_hi  loop
                         4 0 do Uncent Tom_mid loop
                         4 0 do Uncent Tom_low loop
                    else 4 0 do Tom_low loop
                         4 0 do Tom_mid loop
                         4 0 do Tom_hi  loop
                    then cr
            then
        repeat
    ;;ap
;ap 
    
formula

: x Drumming off ;

