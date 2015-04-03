\ $Workfile:   quartz.f  $
\
\ a jam tune
\
\ $Revision:   1.5  $
\ $Log:   B:/formula/vcs/quartz.f_v  $
\ 
\    Rev 1.5   30 Dec 1990 01:44:20   b0b
\ use 4Rand and 5Rand in qProgression - faster!
\ 
\    Rev 1.4   24 Nov 1990 21:04:10   b0b
\ Used 'Index' (from b0b.f) instead of '[ forth ] i [ Forth ]'
\ 
\    Rev 1.3   07 Nov 1990 09:13:52   b0b
\ oooooo... Lotsa good work.  There's also pQuartz, a variation for two pianos.
\ 
\    Rev 1.2   04 Nov 1990 15:08:50   b0b
\ added Jammers
\ 
\    Rev 1.1   04 Nov 1990 10:19:52   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.0   04 Nov 1990 02:30:36   b0b
\ Initial revision.

needs b0b           b0b.f
needs __SYNTH110    synth110.f
needs __CHORDS      chords.f
needs __PIANOMAN    pianoman.f
needs __JAMMERS     jammers.f

Forth
ifdef __QUARTZ  forget __QUARTZ
ifend
create __QUARTZ  .( loading quartz.f...) cr 

create quartz_array   \ 20 chords used
]
    I V IV -VII -III i v iv II V vi III ii IV iii -VII vi V IV I 
[

\ get and execute a chord from the array
:ap qChange  ( n -- )
     19 min 0 max
     Cells quartz_array + @ execute     \ set the chord
;ap


\ the chord progression itself
:ap qProgression  ( -- )
     20 -4 
     do   4Rand Index + qChange |1|
          5Rand Index + qChange |1|
     loop 
;ap


80 BPM  .(   tempo is 80 BPM  )

\ the tune
:ap Quartz
     _Eb to _Key
     Jamming on
     ::ap qProgression
          Jamming off
     ;;ap
     ::ap melodyChannel a.piano.1
          50 to $volume
          10 90 SetVolumeRange
          _Key 12 - majorscale set-ps
          begin Jamming @
          while brnd 
               if   /6   else /4 
               then
               hit_piano
          repeat
          /2 hit_piano 
     ;;ap
     ::ap bassChannel  ac.bass
          60 100 SetVolumeRange
          /2
          begin /2 Root $
               Jamming @
          while ?ChangeVolume
               brnd if   Root 
                    else 5th
                    then
               brnd if   /4 $ rest
                    else /2 $
                    then
          repeat
          /1 Root $
     ;;ap
     ::ap melodyChannel a.piano.1
          10 80 SetVolumeRange
          _Key majorscale set-ps 
          LeadJammer
          /1 lastmid aps Snap $
     ;;ap
     ::ap $DSM U-alt1 to $channel
          20 60 SetVolumeRange
          _Key majorscale set-ps 
          LoJammer
          /2 lastmid aps 5 - Snap $ 
     ;;ap
     ::ap $DSM U-alt2 to $channel
          20 60 SetVolumeRange
          _Key majorscale set-ps 
          HiJammer
          /2 lastmid aps Snap $
     ;;ap
     ::ap drumChannel
          40 80 SetVolumeRange
          /3
          begin Jamming @
          while ?ChangeVolume 
               brnd if   5th 7 - $ 
                    else brnd if   Root 5 -  else 3rd
                              then 
                         $ rest 
                    then
          repeat
          /1 Root 12 - $
     ;;ap
;ap
     
\ piano, bass, and timpani version
:ap pQuartz
     _F to _Key
     Jamming on
     ::ap qProgression
          Jamming off
     ;;ap
     ::ap |3| |3| qProgression
     ;;ap
     ::ap melodyChannel a.piano.1
          50 to $volume
          10 50 SetVolumeRange
          _Key 12 - majorscale set-ps
          begin Jamming @
          while brnd 
               if   /6   else /4 
               then
               hit_piano
          repeat
          /2 hit_piano 
     ;;ap
     ::ap bassChannel  ac.bass
          65 100 SetVolumeRange
          /2
          begin Root $
               Jamming @
          while ?ChangeVolume
               brnd if   Root 
                    else 5th
                    then
               brnd if   /4 $ rest
                    else /2 $
                    then
          repeat
          /1 Root $
     ;;ap
     ::ap chordChannel a.piano.1
          10 65 SetVolumeRange
          _Key majorscale set-ps 
          LoJammer
          /1 lastmid aps Snap $
     ;;ap
     ::ap $DSM U-alt1 to $channel a.piano.1
          10 65 SetVolumeRange
          _Key majorscale set-ps 
          LeadJammer
          /2 lastmid aps 5 - Snap $ 
     ;;ap
     ::ap $DSM U-alt2 to $channel a.piano.1
          10 65 SetVolumeRange
          _Key majorscale set-ps 
          HiJammer
          /2 lastmid aps Snap $
     ;;ap
     ::ap drumChannel
          50 100 SetVolumeRange
          /3
          begin Jamming @
          while ?ChangeVolume 
               brnd if   5th 7 - $ 
                    else brnd if   Root 5 -  else 3rd
                              then 
                         $ rest 
                    then
          repeat
          /1 Root 12 - $
     ;;ap
;ap
     
