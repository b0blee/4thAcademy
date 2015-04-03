\ $Workfile:   drumvol.f  $
\ volume variables and methods for Farley's drum kit

needs b0b b0b.f 
Forth
ifdef __DRUMVOL  forget __DRUMVOL 
ifend            create __DRUMVOL

quan DrumVolume 75 to DrumVolume

\ convention: use "dv" prefix for local quans and methods

quan dvMin      25 to dvMin
quan dvMax     125 to dvMax
quan dvCenter   75 to dvCenter
quan dvStep     25 to dvStep
quan dvHalfStep 12 to dvHalfStep

\ from dvMin and dvMax, the other dvQuans are calculated
: set_dvQuans  ( -- )
    dvMax dvMin -
    2/ dup dvMin + to dvCenter
    2/ dup to dvStep                \ dvStep is 1/4th of the range
    2/ to dvHalfStep
;

\ Set the range of the drum volume
: SetDrumVolumeRange ( v1 v2 -- )  
    2dup
    min to dvMin
    max to dvMax
    set_dvQuans  
    dvCenter to DrumVolume
;

\ ---- Accent is a global concept, perhaps misplaced here ----

pquan (Accent)    \ flag to play next note louder or softer

:ap Accent  1 to (Accent) ;ap
:ap Uncent -1 to (Accent) ;ap

\ ------------------------------------------------------------

\ Accent a drum volume
:ap dvAccent  ( dvol -- dvol' )
    (Accent) ?dup 
    if  0>  if   dvStep + dvMax min
            else dvStep - dvMin max
            then
        0 to (Accent)
    then     
;ap

\ generate a volume louder than DrumVolume
: dvRand+  ( -- vol )
    DrumVolume dvStep irnd + dvMax min  
;

\ generate a volume softer than DrumVolume
: dvRand-  ( -- vol )
    DrumVolume dvStep irnd - dvMin max 
;

\ keep drum volume from getting extreme
: dvCool  ( -- )
    dvMax DrumVolume - dvStep <
        if  dvRand- to DrumVolume exit 
        then
    DrumVolume dvMin - dvStep <  
        if  dvRand+ to DrumVolume
        then
;

\ decrease DrumVolume
\ :ap decDrumVolume  ( -- )
\     dvRand- to DrumVolume
\ ;ap
 
\ increase DrumVolume
\ :ap incDrumVolume  ( -- )
\     dvRand+ to DrumVolume
\ ;ap

\ set $volume according to DrumVolume and accent flag
:ap UseDrumVolume  ( -- )
    DrumVolume dvAccent to $volume
;ap

\ random DrumVolume changer
:ap changeDrumVolume  ( -- )
    brnd if   dvRand+
         else dvRand-
         then 
    to DrumVolume
;ap

:ap ?changeDrumVolume ( -- )
    brnd if   changeDrumVolume
         else dvCool
         then
;ap

\ the internal random drum volume setter
:ap useDV  ( -- )
    ?changeDrumVolume UseDrumVolume
;ap
