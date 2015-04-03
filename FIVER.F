\ $Workfile:   fiver.f  $
\ $Revision:   1.10  $
\
\ "The 5 & 10", a song in 5/5 time

needs b0b           b0b.f
needs __NU110       nu110.f
needs __DRUMS110    drums110.f
needs __CHORDS      chords.f
needs __SNAP        snap.f
needs __VOLUME      volume.f
needs __DRUMBOT     drumbot.f
needs __THEME       theme.f

Forth
ifdef __FIVER  forget __FIVER
otherwise formula
ifend

create __FIVER  .( loading fiver.f...) cr 

variable fing

\ fifth notes and derivitives
:sg ~/5      1|5  &  ;sg     \ fifth note timing sequence
:sg ~/10     1|10 &  ;sg     \ tenth note timing sequence
:sg ~/15     1|15 &  ;sg     \ 15th note timing sequence
:sg ~/30     1|30 &  ;sg     \ 30th note timing sequence
:sg ~2/15    2|15 &  ;sg     \ 2/15ths timing sequence
:sg ~4/15    4|15 &  ;sg     \ 4/15ths timing sequence

:ap /5  ::tsg begin ~/5  again ;;sg ;ap
:ap /10 ::tsg begin ~/10 again ;;sg ;ap
:ap /15 ::tsg begin ~/15 again ;;sg ;ap
:ap /30 ::tsg begin ~/30 again ;;sg ;ap
:ap 2/15 ::tsg begin ~2/15 again ;;sg ;ap
:ap 4/15 ::tsg begin ~4/15 again ;;sg ;ap

\ our "standard" notational conveniences

ifndef // alias //  |1|            ifend
ifndef /' alias /'  |2|            ifend
ifndef ?V alias ?V  ?ChangeVolume  ifend
ifndef V$ 
:ap V$  ( note -- )  ?ChangeVolume  $   ;ap
ifend

' V$ is Theme$

\ a little state machine to make drum decisions

quan woBinIch?

: woBinIch  ( -- n )
     woBinIch? dup 2 =
     if   drop 2Rand
     then
;

:ap fVerse1  ( -- )
     0 to woBinIch?
     vi   //    I    //    iii  //    V    // 
     vi   //    I    //    iii  //    V    // 
     III  //    vi   //    ii   //    vi   // 
     ii   //    vi   //    II   //    V    // 
;ap

:ap fVerse2  ( -- )
     1 to woBinIch?    
     vi   //    I    //    iii  //    V    // 
     vi   //    I    //    iii  //    V    // 
     III  //    vi   //    ii   //    vi   // 
     ii   //    vi   //    VII  //    III  // 
;ap

\ the technique used in Quartz is used here to generate chords for the jam

create jamArray   \ 12 chords used in jam
     ]
          I   ii  V   IV   vi   -VII  -III  vi   III   ii   IV   I 
     [

\ get and execute a chord from the array
:ap jChord  ( n -- )
     11 min 0 max
     Cells jamArray + perform
;ap

:ap fJam  ( -- )  \ 16-bar jam progression
     2 to woBinIch?
     12 -2 
     do   2Rand Index + jChord 
          3Rand Index +  brnd
          if   3|5 time-advance jChord 2|5 time-advance
          else 1|2 time-advance jChord 1|2 time-advance
          then
     loop 
     -III /' -VII /'     I  //  
;ap

:ap fProg  ( -- )
     I |2|
     fVerse1 fVerse2 fJam       \ 16 measures each
     fVerse1 fVerse2 fJam
     fVerse1 
     I  //     I  //     I  //     I  //  
;ap

:ap maybeV$  ( note probability -- )
     Rand if   V$
          else drop pedon$
          then
;ap

:ap bArpeg
     brnd if   Root else Gtr6 12 - then V$
     brnd if   3rd  else Gtr5 12 - then 6 maybeV$
     brnd if   5th  else Gtr4 12 - then V$
     brnd if   3rd  else Gtr5 12 - then 6 maybeV$
     brnd if   5th  else Gtr6 12 - then V$
;ap

:ap highArpeg
     brnd if   8th      else Gtr4 then 3 maybeV$
     brnd if   3rd 12 + else Gtr3 then 5 maybeV$
     brnd if   5th 12 + else Gtr2 then 9 maybeV$
     brnd if   3rd 12 + else Gtr3 then 3 maybeV$
     brnd if   5th 12 + else Gtr4 then 8 maybeV$
;ap


\ drum stuff lifted from psx4.f

rcl rcm rch cch ccl 5  Limb: cymbal    \ array of cymbals

:ap !snare  ( -- )  brnd if sd1 else sd5 then V$  ;ap
:ap !kick   ( -- )  ?V bd1 bd2 2 $n               ;ap

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
     
:ap dVamp
     ::tsg  woBinIch case
          0 of      ~/5       ~/10 ~/10 ~/5       ~/10 ~/10 ~/5       endof
          1 of      ~/5       ~/10 ~/10 ~/5       ~/5       ~/10 ~/10 endof
          2 of      ~/6     ~/12 ~/12 ~/6    ~/10 ~/5       ~/5       endof
          endcase
     ;;sg
     pedon
     !kick     !snare    !snare    ?kick     !snare    !snare    ?cymb 
;ap

:ap dFill/2
     pedon
     /5   ?kick  cymbal Hit 
     /10  ?kick
;ap


\ *********************
\ Theme composer/player

\ pquans used in composing themes
     
pquan theme
pquan timeray

\ time element arrays

: timeRay:
     create ( elements #30ths -- )
          ,   ,
;

alias #30ths @  ( timeRay -- #30ths )

: elements  ( timeRay -- #elements )
     Cell + @
;

: element  ( timeRay n -- time_cfa )
     Cells 2 Cells + + @
;
      

\ timeRays for main theme
\ the two measures are divided into three segmentss
\ of lengths 18|30, 28|30, and 14|30, respectively

\ mainA choices:

3 18 timeRay: mainA.1
     ' /5 ,    ' /5 ,    ' /5 ,

4 18 timeRay: mainA.2
     ' /5 ,    ' 2/15 ,  ' /15 ,   ' /5 ,

\ mainB choices:

6 28 timeRay: mainB.1
     ' 4/15 ,  ' 4/15 ,
     ' /10 ,   ' /10 ,   ' /10 ,   ' /10 ,

6 28 timeRay: mainB.2
     ' 4/15 ,  ' 2/15 ,  ' /15 ,
     ' 4/15 ,  ' /10 ,   ' /10 ,

\ mainC choices:

4 14 timeRay: mainC.1
     ' /5 ,    ' 2/15 ,   ' /15 ,   ' /15 ,

4 14 timeRay: mainC.2
     ' /15 ,   ' 2/15 ,   ' /15 ,   ' /5 ,

quan mainLen

mainA.1 elements
mainA.2 elements max     \ max size of mainA segment
mainB.1 elements
mainB.2 elements max +   \ plus max size of mainB segment
mainC.1 elements
mainC.2 elements max +   \ plus max size of mainC segment
  1 + to mainLen
mainLen Theme: theAlt      \ create theAlt Theme object
mainLen Theme: theMain     \ create theMain Theme object
mainLen Theme: theFlex     \ create theFlex Theme object

\ distribution of main theme notes:

create maintab  21 ,
\         8th  7th -7th  5th  4th  3rd  6th  9th
          4 ,  2 ,  3 ,  3 ,  2 ,  2 ,  2 ,  3 , 



\ select a note
:ap mainNoteCfa  ( -- cfa )
     maintab trand
     case 0 of [']  8th  endof          1 of [']  7th  endof
          2 of [']  -7th endof          3 of [']  5th  endof
          4 of [']  4th  endof          5 of [']  3rd  endof
          6 of [']  6th  endof          7 of [']  9th  endof
     endcase
;ap

quan gotBreath

:ap fillMainSegment  ( -- )
     timeray elements 0
     do   mainNoteCfa
          timeray Index element
          gotBreath 0=
          if   dup ['] /15 =
               if   nip ['] 0 swap      \ give player a /15th to breath
                    true to gotBreath
               then
          then
          theme >Theme
     loop
;ap

:ap composeMain  ( theme -- )
     dup to theme ClearTheme
     0 to gotBreath
     brnd if   mainA.1
          else mainA.2
          then to timeray
     fillMainSegment
     brnd if   mainB.1
          else mainB.2
          then to timeray
     fillMainSegment
     brnd if   mainC.1
          else mainC.2
          then to timeray
     fillMainSegment
     ['] Unlikely ['] noop theme >Theme
;ap

:ap playHarmony ( theme -- )
     dup to theme
     tSize 0
     do   theme Index ThemeTime 
          theme Index ThemeNote dup Unlikely =
          if   drop
          else ?dup
               if   brnd if   7 -  else 5 -  then
                    Snap V$
               else rest
               then
          then
     loop
;ap

\ ****** Jam composer/player ******
\ themes for jammin'

61 Theme: theJam1
61 Theme: theJam2

\ timeRays for jammin'

1 6 timeRay: one/5
     ' /5 ,

1 3 timeRay: one/10     
     ' /10 ,

2 5 timeRay: oneWeird
     ' /10 ,   ' /15 ,

2 6 timeRay: oneShuf
     ' 2/15 ,  ' /15 ,

1 2 timeRay: one/15
     ' /15 ,

1 5 timeRay: one/6
     ' /6 ,

\ distribution of jammin' notes:

create distab  21 ,
\         8th Root -7th  5th  4th  3rd  2nd  9th  rest
          3 ,  2 ,  3 ,  3 ,  1 ,  2 ,  1 ,  3 ,  3 ,

\ select a note
:ap jamNoteCfa  ( -- cfa )
     distab trand
     case 0 of [']  8th  endof          1 of [']  Root endof
          2 of [']  -7th endof          3 of [']  5th  endof
          4 of [']  4th  endof          5 of [']  3rd  endof
          6 of [']  2nd  endof          7 of [']  9th  endof
          8 of [']  0    endof
          abort" illegal jamNoteCfa"
     endcase
;ap

quan sofar

:ap composeJam  ( theme -- )
     dup to theme ClearTheme
     0 to sofar
     begin sofar 55 <
     while 6 irnd
          case 0 of one/5    endof
               1 of one/10   endof
               2 of oneShuf  endof
               3 of one/15   endof
               4 of oneWeird endof
               5 of one/6    endof
          endcase  dup to timeray
          elements 0
          do   jamNoteCfa
               timeray Index element
               theme >Theme
          loop
          timeray #30ths sofar + to sofar    
     repeat
     60 sofar - 0   \ over cr . ." 30ths needed " 
     ?do   ['] 0  ['] /30  theme >Theme 
     loop
     ['] Unlikely ['] /5   theme >Theme
;ap

:ap playJam1   theJam1 PlayTheme   ;ap
:ap playJam2   theJam2 PlayTheme   ;ap

:ap playAnyJam
     brnd if   theJam1 composeJam  playJam1
          else theJam2 composeJam  playJam2
          then
;ap

\ the jam is an overlapping "call and response"
\
\      | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | A | B | C | D | E | F |
\ call | play1 | play2 | -   -   - | play? | play1 | -   -   - | play2 |
\ resp | -   -   - | play1 | play2 | -   -   - | play2 | play? | harm2 |

:ap jamCall
     playJam1       playJam2   //      //     //  
     playAnyJam     playJam1   //      //     // 
     playJam2
;ap

:ap jamResponse
     //      //     //    playJam1      playJam2
     //      //     //    playJam2      playAnyJam
     theJam2 playHarmony
;ap

:ap testJam
     theJam1 composeJam  theJam2 composeJam
     ::ap fJam ." fJam fini" cr ;;ap  
     ::ap Part_6 jamCall     ." call done"     cr /30 Root $ ;;ap
     ::ap Part_5 jamResponse ." response done" cr /30 5th $ ;;ap
;ap

:ap theLeadPart
     2 0
     do   \ verse1
          theMain PlayTheme   theMain PlayTheme
          theAlt  PlayTheme   theAlt  PlayTheme
          theMain PlayTheme   theMain PlayTheme
          theAlt  PlayTheme   theAlt  PlayTheme
          \ verse2
          theFlex PlayTheme   theAlt  PlayTheme
          theMain PlayTheme   theFlex PlayTheme
          theAlt  PlayTheme   theFlex PlayTheme
          theMain PlayTheme   theFlex PlayTheme
          \ the Jam
          $maxvol $vstep irnd - to $volume
          jamCall
          theFlex composeMain
     loop
     \ verse 1
     theMain PlayTheme   theMain PlayTheme
     theAlt  PlayTheme   theAlt  PlayTheme
     theMain PlayTheme   theMain PlayTheme
     theAlt  PlayTheme   theAlt  PlayTheme
     \ ending
     theMain PlayTheme
     theMain PlayTheme
     $minvol to $volume
     8th V$
;ap

:ap theHarmonyPart
     2 0
     do   \ verse1
          theMain playHarmony   theMain playHarmony
          theAlt  playHarmony   theAlt  playHarmony
          theMain playHarmony   theMain playHarmony
          theAlt  playHarmony   theAlt  playHarmony
          \ verse2
          theFlex playHarmony   theAlt  playHarmony
          theMain playHarmony   theFlex playHarmony
          theAlt  playHarmony   theFlex playHarmony
          theMain playHarmony   theFlex playHarmony
          \ the Jam
          $maxvol $vstep irnd - to $volume
          jamResponse
     loop
     \ verse 1
     theMain playHarmony   theMain playHarmony
     theAlt  playHarmony   theAlt  playHarmony
     theMain playHarmony   theMain playHarmony
     theAlt  playHarmony   theAlt  playHarmony
     \ ending
     theMain playHarmony
     theMain playHarmony
     $minvol to $volume
     5th V$
;ap

:ap Five_&_Ten     4 U$patch ;ap       \ the patch we've set up

Five_&_Ten
_Bb to _Key

:ap Fiver
     theMain composeMain
     theAlt  composeMain
     theFlex composeMain
     theJam1 composeJam
     theJam2 composeJam
     fing on
     ::ap fProg fing off
     ;;ap
     ::ap Part_1 e.piano.2
          -20 30 SetVolumeRange
          12.0 to $transpose 
          /10  2|5 time-advance
          begin fing @
          while bArpeg
          repeat
          /1 Root $
     ;;ap
     ::ap Part_1 e.piano.2
          -20 30 SetVolumeRange
          /15  /'
          begin fing @
          while highArpeg
          repeat
          /1 Root $
     ;;ap
     ::ap Part_4 ac.bass
          60 120 SetVolumeRange
          /' /5
          begin fing @
          while bArpeg
          repeat
          /2 pedon Root $
     ;;ap
     ::ap Part_2 drums pedon
          60 120 SetVolumeRange
          begin fing @
          while dVamp
          repeat
          /1 cymbal Hit 
     ;;ap
     ::ap Part_2 drums pedon
          50 100 SetVolumeRange
          dFill/2 
          begin fing @
          while dVamp
          repeat
          !kick
     ;;ap
     ::ap Part_6 sax.1
          12.0 to $transpose
          70 120 SetVolumeRange
          /' theLeadPart
     ;;ap
     ::ap Part_5 shaku.2
          12.0 to $transpose
          25 60 SetVolumeRange
          /' theHarmonyPart
     ;;ap
;ap

