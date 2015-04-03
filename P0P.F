\ $Workfile:   p0p.f  $
\ electronic pop song
\ $Revision:   1.3  $
\ $Log:   B:/formula/vcs/p0p.f_v  $
\ 
\    Rev 1.3   07 Nov 1990 09:09:36   b0b
\ Added a version that uses Jammers.f
\ 
\    Rev 1.2   04 Nov 1990 10:20:08   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.1   03 Sep 1990 12:35:32   b0b
\ Added PVCS comment header

needs b0b           b0b.f
needs __SYNTH110    synth110.f
needs __DRUMs110    drums110.f
needs __CHORDS      chords.f

ifdef __P0P forget __P0P
ifend
create __P0P  .( loading p0p.f...) cr

variable comping

quan b00st 20 to b00st

\ add a random int between -n and +n to v
:ap randVol ( v n -- )
     dup 2* irnd - 
     + b00st + to $volume
;ap

:ap snare2&4  ( -- )
     /4 32 16 randVol Kick 
     /2 36 18 randVol Snare 
     /4 24 32 randVol Snare
;ap


\ create a composite drum
:ap fatdrum:
     create ( n1 n2 n3 -- )  \ drum has 3 components
          c, c, c,
     does> count z$
          count z$
          c@ $
;ap

0   0   0   fatdrum: noDrum
sd1 sd2 0   fatdrum: sd12
sd1 sd2 sd3 fatdrum: sd123
sd2 sd3 sd4 fatdrum: sd234
sd3 sd4 sd5 fatdrum: sd345
bd1 bd2 0   fatdrum: bd12
bd1 bd2 bd3 fatdrum: bd123
bd2 bd3 bd4 fatdrum: bd234
bd1 bd2 bd4 fatdrum: bd124

\ 8 bars of drums for the intro
:ap drumIntro
     drumChannel
     ['] sd345 is Snare
     ['] noDrum is Kick
     snare2&4
     snare2&4
     ['] sd123 is Kick
     snare2&4
     ['] noDrum is Kick
     snare2&4
     ['] sd123 is Kick
     snare2&4
     ['] noDrum is Kick
     snare2&4
     ['] bd12 is Kick    \ was bd124
     snare2&4
     ['] sd12 is Snare   \ added 16Jun90
     snare2&4
;ap


\ chord player adds some "quiet" drums
:ap //
     $channel U-drum =
     if   /4
          -32 32 randVol Kick
          -92 31 randVol Snare
          -32 32 randVol Kick      \ hit on the 3
          -96 31 randVol Snare     \ boost main drummer
     else |1|
     then
;ap

\ the chord progression for the verse
:ap Verse 
     I    //   I    //   I    //   I    //
     IV   //   IV   //   IV   //   IV   //
     I    //   I    //   I    //   I    //
     IV   //   IV   //   IV   //   III  //
;ap

\ the chord progression for the verse
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

:ap set_p0p
     formula
     117 beats-per-minute /3
     Techs.Band
     _D to _Key   I
     drumChannel  drums   Kick
     bassChannel  ac.bass Root $
;ap
     set_p0p

:ap quad$
     Bottom dup Root =
     if   5th 8th 3rd 12 +
     else Root 3rd Root 12 +
     then
     4 $n
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
               if   $n        \ play chord
               else drop $    \ or single note
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
     gRand 1100 and if Gtr6 swap 1+ then
     [ decimal ]
     ?dup if dup 1-
               if   $n        \ play chord
               else drop $    \ or single note
               then
          then                \ or nothing at all
;ap

:ap gVol
     -75 20 randVol
;ap

:ap firstHalf8
     /4   guit$ 
     /8   gVol guit$ 
          gVol guit$
;ap

:ap secondHalf8
     /8   rest 
     /4   guit$ 
     /16  gVol guit$ 
     pedon rest pedoff
;ap

:ap compGuitar
     comping on gVol
     begin comping @
     while firstHalf8
          comping @
          if   secondHalf8 
          then
     repeat
;ap

:ap pulses
     begin comping @ 
     while gVol alt$ gVol alt$ 
           rest alt$
     repeat
;ap
     
     
:ap p0p
     ::ap \ cliche 2&4 drums
          drumChannel drums
          1|256 time-advance   \ trail slightly
          drumIntro
          begin comping @    \ keep it up till comping is turned off
          while snare2&4
          repeat
      Kick
     ;;ap
     ::ap \ chord progression, aux drums, beat leader
          drumChannel drums
          I  7|1 time-advance 
          comping on //
          Verse altVerse Verse
          comping off
          vi
     ;;ap
     ::ap bassChannel ac.bass
          1|256 time-advance   \ bass trails
          4|1 time-advance
          pedon /1
          |2| Root $ |2|      \ 2 measures  
          |2| Root $ |2|      \ 2 more
          pedoff
          48 0
          do   bGroove
          loop
          /1 Root $ pedon
     ;;ap
     ::ap chordChannel a.guitar.2
          -12.0 to $transpose
          1|512 time-advance   \ trail slightly
          |1| |1| |1| |1|
          /2 rest gVol secondHalf8
          compGuitar          
          /1 guit$ pedon
     ;;ap
     ::ap U-alt2 to $channel ac.bass
          8|1 time-advance 
          1|512 time-advance   \ trail slightly
          /16 rest
          pulses
          /1 alt$
     ;;ap  
;ap


:ap p0p2
     p0p
     ::ap 8|1 time-advance |2|
          altVerse Verse altVerse
     ;;ap
;ap


needs __VOLUME      volume.f
needs __JAMMERS     jammers.f

:ap p0p3
     p0p
     ::ap 8|1 time-advance |3|
          altVerse Verse altVerse
     ;;ap
     ::ap $DSM U-alt1 to $channel vib.1
          15|2 time-advance
          _Key majorscale set-ps
          -80 -20 SetVolumeRange
          LeadJammer
          /1 lastmid aps Snap $
     ;;ap
     ::ap $DSM U-alt1 to $channel vib.1
          8|1 time-advance
          _Key 12 + majorscale set-ps
          -80 -30 SetVolumeRange
          LeadJammer
          /1 lastmid aps Snap $
     ;;ap
     ::ap $DSM U-alt1 to $channel vib.1
          15|2 time-advance
          _Key majorscale set-ps
          -80 -25 SetVolumeRange
          HiJammer
          /1 lastmid 5 + Snap $
     ;;ap
     ::ap $DSM U-alt1 to $channel vib.1
          8|1 time-advance
          _Key 12 + majorscale set-ps
          -80 -25 SetVolumeRange
          LoJammer
          /1 lastmid 5 - Snap $
     ;;ap
     ::ap 32|1 time-advance
          begin comping @
          while |6|
          repeat
          Jamming off
     ;;ap
;ap
