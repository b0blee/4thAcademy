\ $Workfile:   poppa.f  $
\ $Revision:   1.5  $
\
\ "pop" song derived from p0p.f

needs b0b           b0b.f
needs __NU110       nu110.f
needs __DRUMS110    drums110.f
needs __CHORDS      chords.f
needs __VOLUME      volume.f
needs __DRUMBOT     drumbot.f
needs __SNAP        snap.f
needs __THEME       theme.f

ifdef __POPPA       forget __POPPA
otherwise           formula
ifend

create __POPPA  .( loading poppa.f...) cr

variable comping

\ our "standard" notational conveniences

ifndef // alias //  |1|            ifend
ifndef /' alias /'  |2|            ifend
ifndef ?V alias ?V  ?ChangeVolume  ifend
ifndef V$ 
:ap V$ ( note -- )  ?ChangeVolume  $   ;ap
ifend

' V$ is Theme$

\ add a random int between -n and +n to v
:ap randVol ( v n -- )
     dup 2* irnd - 
     + to $volume
;ap

:ap snare2&4  ( -- )
     /4 ?V Kick 
     /2 ?V Snare
     /4 ?V Snare
;ap


\ create a composite drum
:ap fatdrum:
    create ( n1 n2 n3 -- )  \ drum has 3 components
          c, c, c,
    does> count ?dup if z$ then
          count ?dup if z$ then
          c@ V$
;ap

0   0   0   fatdrum: noDrum
sd1 sd2 0   fatdrum: sd12
sd1 sd2 sd3 fatdrum: sd123
sd3 sd4 sd5 fatdrum: sd345
bd1 bd2 0   fatdrum: bd12

\ 8 bars of drums for the intro.  Cryptic stuff, huh?
:ap drumIntro
     ['] sd345 is Snare
     ['] noDrum is Kick  snare2&4
                         snare2&4
     ['] sd123  is Kick  snare2&4
     ['] noDrum is Kick  snare2&4
     ['] sd123  is Kick  snare2&4
     ['] noDrum is Kick  snare2&4
     ['] bd12   is Kick  snare2&4
     ['] sd12  is Snare  snare2&4
;ap

\ ***** drum fills *****

chil chih cch ccl 4  Limb: cymbowl   \ array of chinese and crash cymbals

\ hit toms n times
:ap toms  ( n -- )
     0 ?do tomhand Hit loop
;ap

\ hit ride cymbals n times
:ap rides  ( n -- )
     0 ?do ridehand Hit loop
;ap

\ hit rototoms n times
:ap rotos  ( n -- )
     0 ?do rotohand Hit loop
;ap

\ hit a crash cymbal
:ap crash  crashhand Hit ;ap

\ hit crash cymbals n times
:ap crashes  ( n -- )
     0 ?do crash loop
;ap

\ half a measure as Dick Clark intended
:ap halfCliche  ( -- )
     /4 clubfoot Hit
     /8 snarehand Hit  clubfoot Hit
;ap

:ap theCliche  ( -- )
     halfCliche
     /4 clubfoot Hit   snarehand Hit
;ap

\ sequence generators
:sg ~/7s    2|7  &  ;sg
:sg ~/4     1|4  &  ;sg
:sg ~/7.    3|14 &  ;sg
:sg ~/7     1|7  &  ;sg
:sg ~/8     1|8  &  ;sg
:sg ~/10    1|10 &  ;sg
:sg ~/21s   2|21 &  ;sg
:sg ~/14    1|14 &  ;sg
:sg ~/16    1|16 &  ;sg
:sg ~/20    1|20 &  ;sg
:sg ~/21    1|21 &  ;sg

:ap /7s  ::tsg begin ~/7s  again ;;sg ;ap
:ap /7   ::tsg begin ~/7   again ;;sg ;ap
:ap /7.  ::tsg begin ~/7.  again ;;sg ;ap
:ap /14  ::tsg begin ~/14  again ;;sg ;ap
:ap /21  ::tsg begin ~/21  again ;;sg ;ap
:ap /21s ::tsg begin ~/21s again ;;sg ;ap

:ap dfill/2
     ::tsg     \ 7 timing elements 
          3Rand case
          0 of 6 0 do ~/16 loop /8      endof
          1 of 5 0 do ~/20 loop ~/8 ~/8 endof
          2 of 7 0 do ~/14 loop         endof
          3 of 3 0 do ~/16 loop ~/8
               3 0 do ~/16 loop         endof
          endcase
     ;;sg
     5Rand case
     0 of 7 rotos                  endof
     1 of 6 toms crash             endof
     2 of 3 toms crash 3 rides     endof
     3 of crash 5 rotos crash      endof
     4 of 4 toms crash 2 rides     endof
     5 of 2 crashes 5 rides        endof
     endcase
;ap


:ap dfill/1
     ::tsg     \ 7 timing elements 
          3Rand case
          0 of 6 0 do ~/8  loop /4      endof
          1 of 5 0 do ~/10 loop ~/4 ~/4 endof
          2 of 7 0 do ~/7  loop         endof
          3 of 3 0 do ~/8  loop ~/4
               3 0 do ~/8  loop         endof
          endcase
     ;;sg
     5Rand case
     0 of 7 rotos                  endof
     1 of 6 toms crash             endof
     2 of 3 rotos crash 3 rotos    endof
     3 of crash 5 rotos crash      endof
     4 of 4 toms crash 2 rides     endof
     5 of 3 crashes 4 rides        endof
     endcase
;ap

\ one measure which might contain a drum fill
:ap ?drumfill  ( -- )
     3Rand
     if   2Rand 
          if   theCliche
          else /4 clubfoot Hit 
               dfill/2 /4 cymbowl Hit
          then
     else 2Rand
          if   2Rand if   theCliche 
                     else dfill/1 
                     then
          else 2Rand if   halfCliche dfill/2
                     else dfill/1
                     then
          then
     then
;ap
     
\ one measure that WILL contain a drum fill
:ap drumfill
     brnd
     if   dfill/1
     else brnd 
          if   dfill/2    dfill/2
          else halfCliche dfill/2
          then
     then
;ap
      

\ the chord progression for the verse
:ap Verse 
     I    //   I    //   I    //   I    //
     IV   //   IV   //   IV   //   IV   //
     I    //   I    //   I    //   I    //
     IV   //   IV   //   IV   //   III  //
;ap

\ the alternate chord progression for the verse
:ap altVerse 
     vi   //   vi   //   vi   //   vi   //
     ii   //   ii   //   ii   //   III  //
     vi   //   vi   //   vi   //   III  //
     ii   //   ii   //   II   //   V    //
;ap

:ap Bottom  ( -- n )
    Root 5th RootKey min      \ the lower of Root or 5th
;ap

:ap bGroove
     /4  36 48 randVol Root $
     /8  12 24 randVol rest Bottom $
     /2  36 48 randVol Root $
;ap


quan gRand

:ap guit$
     [ octal ] 10000 irnd to gRand
     0
     gRand 0111 and if Gtr1 swap 1+ then
     gRand 1110 and if Gtr2 swap 1+ then
     gRand 0222 and if Gtr3 swap 1+ then
     gRand 2220 and if Gtr4 swap 1+ then
     gRand 0444 and if Gtr5 swap 1+ then
     gRand 4440 and if Gtr6 swap 1+ then     [ decimal ]
     ?dup if dup 1-
               if   ?V $n     \ play chord
               else drop V$   \ or single note
               then
          then                \ or nothing at all
;ap

:ap alt$  [ octal ]
     0              \ use existing gRand
     gRand 4200 and if Gtr1 swap 1+ then
     gRand 0024 and if Gtr2 swap 1+ then
     gRand 2400 and if Gtr3 swap 1+ then
     gRand 0012 and if Gtr4 swap 1+ then
     gRand 0041 and if Gtr5 swap 1+ then
     gRand 1100 and if Gtr6 swap 1+ then     [ decimal ]
     ?dup if dup 1-
               if   ?V $n     \ play chord
               else drop V$   \ or single note
               then
          then                \ or nothing at all
;ap

:ap firstHalf8
     /4   guit$ 
     /8   alt$ 
     /4   guit$
;ap

:ap secondHalf8
\    /8   pedon$
     /4   guit$ 
     /16  alt$
     rest 
;ap

:ap compGuitar  ( -- )
     comping on
     begin comping @ if  firstHalf8  then
           comping @ if  secondHalf8 then
           comping @ 0= if exit then
     again
;ap

:ap rthmTrack
     ::ap \ chord progression, beat leader
          I  
          // // // //
          // // // 
          comping on //
          Verse altVerse Verse
          Verse altVerse Verse
          comping off
          vi
     ;;ap
     ::ap \ alternating progression
          // // // //
          // // // // /'
          Verse altVerse altVerse
          altVerse Verse Verse
     ;;ap
     ::ap \ cliche 2&4 drums
          Part_2 drums pedon
          0 60 SetVolumeRange
          1|256 time-advance   \ trail slightly
          drumIntro
          begin comping @    \ keep it up till comping is turned off
          while snare2&4
          repeat
          /7 7 rotos crash
     ;;ap
     ::ap \ drum fills
          Part_2 drums pedon
          60 120 SetVolumeRange
          1|256 time-advance   \ trail slightly
          dfill/2 /2 chil V$
          // // /'  dfill/2 /1 crash
          // // /7 7 rotos
          begin comping @
          while /2            \ 8 measures 
               cymbowl Hit    halfCliche
                              theCliche
               ?drumfill      ?drumfill
               ?drumfill      ?drumfill
               theCliche      drumfill
          repeat
          /7 chil V$ 6 rotos Kick
     ;;ap
     ::ap Part_4 ac.bass
          60 100 SetVolumeRange
          1|256 time-advance   \ bass trails
          // // // //
          pedon /1
          /' Root $ /'      \ 2 measures  
          /' Root $ /'      \ 2 more
          pedoff
          96 0
          do   bGroove
          loop
          /1 Root $ pedon
     ;;ap
     ::ap Part_3 a.guitar.2
          -12.0 to $transpose
          1|512 time-advance   \ trail slightly
          // // // // 
          -25 25 SetVolumeRange pedon
          /' |8| secondHalf8
          compGuitar          
          /1 guit$ pedon
     ;;ap
;ap

\ *** Theme Composer ***

: sgArray: 
     create ( #elements -- ) , 
;

: sgCount  ( sgArray -- adr0 #elements )
     dup @
     swap Cell + swap
;


\ each of these sg (Sequence Generator) arrays is 2/7ths long

1 sgArray: sg7.0    ' /7s ,
2 sgArray: sg7.1    ' /7. ,   ' /14 ,
2 sgArray: sg7.2    ' /7 ,    ' /7 ,
3 sgArray: sg7.3    ' /7 ,    ' /14 ,   ' /14 ,
3 sgArray: sg7.4    ' /7 ,    ' /21s ,  ' /21 ,
4 sgArray: sg7.5    ' /7 ,    ' /21 ,   ' /21 ,   ' /21 ,
3 sgArray: sg7.6    ' /21s ,  ' /21 ,   ' /7 ,
3 sgArray: sg7.7    ' /14 ,   ' /14 ,   ' /7 ,
2 sgArray: sg7.8    ' /14 ,   ' /7. ,

create sg[]
sg7.0 ,   sg7.1 ,   sg7.2 ,   sg7.3 ,   sg7.4 ,
sg7.5 ,   sg7.6 ,   sg7.7 ,   sg7.8 ,   sg7.0 ,

:ap randSg ( -- sgArray )
     10 irnd Cells sg[] + @
;ap

\ note range checking

pquan $maxnote
pquan $minnote

:ap fixhi ( note -- note' )
     recursive
     dup $maxnote > 
     if   drop 2 -nps fixhi
     then
;ap

:ap fixlo ( note -- note' )
     recursive
     dup $minnote <
     if   drop 2 +nps fixlo
     then
;ap

\ these are the Note Generators.  Stack for each is ( -- note )

:ap ng1   +ps fixhi           ;ap 
:ap ng2   +ps fixhi Snap      ;ap
:ap ng3   -ps fixlo           ;ap
:ap ng4   -ps fixlo Snap      ;ap
:ap ng5   2 +nps fixhi        ;ap
:ap ng6   2 -nps fixlo        ;ap
:ap ng7   2Rand 1+ +nps fixhi ;ap
:ap ng8   2Rand 1+ -nps fixlo ;ap

create ng[]
' 0   ,
' ng1 ,        ' ng2 ,        ' ng3 ,        ' ng4 ,
' ng5 ,        ' ng6 ,        ' ng7 ,        ' ng8 ,
' 0   ,

:ap randNoteCfa  ( -- cfa )
     ng[] 10 irnd Cells + @
;ap

:ap composeTheme7  ( Theme -- )
     dup to $theme ClearTheme
     7 0 
     do   randSg sgCount 0
          do   randNoteCfa
               over @ $theme >Theme
               Cell +
          loop  drop 
     loop
;ap

28 Theme: theMainTheme
28 Theme: mainTheme1
28 Theme: mainTheme2
28 Theme: mainTheme3
28 Theme: mainTheme4
28 Theme: theAltTheme
28 Theme: theJammer

:ap initPoppa
     140 BPM  _Eb to _Key  Academy_49
;ap

initPoppa

:ap playHead
     2 0 do
          mainTheme1 PlayTheme     mainTheme2 PlayTheme
          mainTheme3 PlayTheme     mainTheme4 PlayTheme
     loop
;ap

:ap _sitout2
     /7 -ps Snap V$ 
     13|7 time-advance 
;ap
:ap sitout2_
     13|7 time-advance 
     /7 +ps Snap V$ 
;ap
:ap _sitout2_
     /7 -ps Snap V$ 
     12|7 time-advance 
     /7 +ps Snap V$
;ap

:ap jam7for2
     $volume dup $vstep + 
     $maxvol min to $volume
     theJammer PlayTheme
     ( old $volume) to $volume
;ap

:ap newJam     theJammer composeTheme7
;ap

:ap keyboardIntro
     //   //   sitout2_   _sitout2  sitout2_
;ap

:ap lead1intro
     sitout2_  //   //    //   //  _sitout2_
;ap

:ap lead2intro
     //   //   _sitout2   sitout2_  sitout2_

;ap
     
:ap keyboardPart
     keyboardIntro
     playHead
     _sitout2                 sitout2_
     mainTheme1 PlayTheme     mainTheme2 PlayTheme
     _sitout2                 sitout2_
     mainTheme1 PlayTheme     mainTheme2 PlayTheme

     jam7for2                 jam7for2
     mainTheme3 PlayTheme     mainTheme4 PlayTheme
     _sitout2                 sitout2_
     mainTheme3 PlayTheme     mainTheme4 PlayTheme

     mainTheme1 PlayTheme     _sitout2
     mainTheme2 PlayTheme     _sitout2
     mainTheme1 PlayTheme     jam7for2
     mainTheme2 PlayTheme     _sitout2

     mainTheme3 PlayTheme     _sitout2
     mainTheme4 PlayTheme     jam7for2
     mainTheme3 PlayTheme     _sitout2
     mainTheme4 PlayTheme     _sitout2
     playHead
     /1 2 -nps Snap pedon $
;ap

:ap 1stLeadPart
     lead1intro
     playHead

     jam7for2   newJam        jam7for2   newJam
     mainTheme1 PlayTheme     mainTheme2 PlayTheme
     _sitout2                 sitout2_
     mainTheme1 PlayTheme     mainTheme2 PlayTheme

     _sitout2                 sitout2_
     mainTheme3 PlayTheme     mainTheme4 PlayTheme
     jam7for2   newJam        jam7for2       
     _sitout2                 mainTheme4 PlayTheme 

     mainTheme1 PlayTheme     jam7for2   newJam
     mainTheme2 PlayTheme     _sitout2
     mainTheme1 PlayTheme     _sitout2
     mainTheme2 PlayTheme     jam7for2   newJam

     mainTheme3 PlayTheme     _sitout2
     mainTheme4 PlayTheme     _sitout2
     mainTheme3 PlayTheme     jam7for2   newJam
     mainTheme4 PlayTheme     jam7for2

     playHead
     /1 2 -nps Snap V$
;ap


:ap 2ndLeadPart
     lead2intro
     playHead

     _sitout2                 sitout2_
     mainTheme1 PlayTheme     mainTheme2 PlayTheme
     jam7for2   newJam        jam7for2   newJam
     mainTheme1 PlayTheme     mainTheme2 PlayTheme

     _sitout2                 sitout2_
     mainTheme3 PlayTheme     mainTheme4 PlayTheme
     _sitout2                 sitout2_
     jam7for2   newJam        jam7for2 

     mainTheme1 PlayTheme     _sitout2
     mainTheme2 PlayTheme     jam7for2   newJam
     mainTheme1 PlayTheme     _sitout2
     mainTheme2 PlayTheme     _sitout2

     mainTheme3 PlayTheme     jam7for2   newJam
     mainTheme4 PlayTheme     _sitout2
     mainTheme3 PlayTheme     _sitout2
     mainTheme4 PlayTheme     jam7for2

     playHead
     /1 2 -nps Snap V$
;ap

:ap Poppa
     mainTheme1   composeTheme7
     mainTheme2   composeTheme7
     mainTheme3   composeTheme7
     mainTheme4   composeTheme7
     theJammer    composeTheme7
     rthmTrack
     ::ap Part_5 soft.tp.1
          _Key 12 + majorscale set-ps
          53 to $minnote           \ F3
          77 to $maxnote           \ F5
          -20 30 SetVolumeRange
          1stLeadPart
     ;;ap
     ::ap Part_6 sax.2
          1|98 time-advance        \ not TOO in-sync 
          _Key 4 + minorscale set-ps
          60 to $minnote           \ D3
          74 to $maxnote           \ D5
          10 70 SetVolumeRange
          2ndLeadPart
     ;;ap
     ::ap Part_1 e.piano.5
          1|75 time-advance        \ not TOO in-sync 
          _Key 12 + majorscale set-ps
          58 to $minnote           \ Bb3
          87 to $maxnote           \ Eb6
          -20 40 SetVolumeRange
          keyboardPart
     ;;ap
     ::ap Part_1 e.piano.5
          1|84 time-advance        \ not TOO in-sync 
          _Key 7 - majorscale set-ps
          51 to $minnote           \ Eb3
          75 to $maxnote           \ Eb5
          -20 50 SetVolumeRange
          keyboardPart
     ;;ap
;ap
