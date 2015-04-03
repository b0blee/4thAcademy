\ $Workfile:   pianoman.f  $
\ our outside piano player
\ $Revision:   1.4  $
\ $Log:   B:/formula/vcs/pianoman.f_v  $
\ 
\    Rev 1.4   07 Nov 1990 09:06:52   b0b
\ Cleaned up implementation for use with Quartz.f
\ 
\    Rev 1.3   04 Nov 1990 10:18:36   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.2   03 Sep 1990 18:40:14   b0b
\ Removed ?volume.change, access volume.f algorithm instead
\ 
\    Rev 1.1   03 Sep 1990 15:40:40   b0b
\ Incremental development changes
\ 
\    Rev 1.0   03 Sep 1990 12:34:42   b0b
\ Initial revision.

needs b0b           b0b.f
needs __CHORDS      chords.f
needs __VOLUME      volume.f
needs __SNAP        snap.f

ifdef _TESTING_
needs __TRUMP       trump.f
ifend

ifdef __PIANOMAN forget __PIANOMAN
ifend
create __PIANOMAN   .( loading pianoman.f...) cr

\ rules to play by:
\
\ This guy's hands each have a maximum range of 10 scalenotes.
\
\ On each trigger pulse, each hand may move up or down
\ by 0, 1, or 2 scale notes.
\
\ The two hands are not permitted to overlap.
\
\ The LEFT hand responds with music to between 1/4 and 1/3
\ of the trigger pulses.
\
\ When triggered, the LEFT hand has the following probabilities:
\
\      1 note  - 1/3
\      2 notes - 1/3
\      3 notes - 1/4
\      4 notes - 1/12
\
\ Adjacent tones or semitones are illegal in the LEFT hand.
\
\ Notes played with the LEFT hand are taken from the chord 1/2 of the time.
\
\ The RIGHT hand responds to between 2/3 or 3/4 of the trigger pulses.
\
\ When triggered, the RIGHT hand has the following probabilities:
\
\      1 note  - 1/12
\      2 notes - 1/3
\      3 notes - 1/3
\      4 notes - 1/4
\
\ Adjacent semitones are perfectly legal in the RIGHT hand.
\
\ Each note played with the RIGHT hand has a 1/3 probability of being
\ "snapped" to the current chord.
\

\ current hand positions

quan lo_left        quan hi_left        quan last_left
quan lo_right       quan hi_right       quan last_right

 0 to lo_left       10 to hi_left        5 to last_left
12 to lo_right      21 to hi_right      17 to last_right

defer hit_left      ' noop is hit_left
defer hit_right     ' noop is hit_right


:ap hit_piano  ( -- )
     brnd
     if   brnd brnd and
          if   hit_left       \ left hand 1/4th of the time
          else pedon$
          then
     else 3 irnd 
          if   pedon$
          else hit_left       \ left hand 1/3rd of the time
          then
     then
     
     brnd
     if   3 irnd
          if   hit_right      \ right hand 2/3rds of the time
          then
     else brnd brnd or
          if   hit_right      \ right hand 3/4ths of the time
          then
     then
;ap


:ap ?leftSnap  ( scalenote -- actualnote )
     aps  brnd 
     if   Snap                 \ snap the actual pitch
     then  
;ap


:ap good_left  ( -- note )
     recursive
     lo_left 8 irnd + 
     ?leftSnap                     \ s: note 
     dup last_left -               \ s: note delta_last
     abs 3 <                       \ no unison or semitones allowed 
     if   drop good_left           \ try again
     else dup to last_left
     then
;ap
     

:ap (hit_left)
     ped
     0 to last_left
     ?ChangeVolume
     good_left
     12 irnd ?dup
     if   dup 4 >
          if   good_left 
               swap 8 >
               if   good_left 
                    3 $n
               else 2 $n
               then
          else drop $ 
          then
     else good_left good_left good_left 
          4 $n
     then
;ap

' (hit_left) is hit_left

:ap (hit_right)
     Root z$
     5th  z$
;ap

' (hit_right) is hit_right

ifdef _TESTING_
:ap test
     comping on
     ::ap chordChannel a.piano.1
          50 to $volume
          10 80 SetVolumeRange
          _C to _Key I
          _Key 12 - majorscale set-ps
          /8
          begin comping @
          while hit_piano
               lo_left 5 irnd 2 - +
               0 max 12 min to lo_left
          repeat
          /2 pedon hit_piano 
          Root 5th over 12 + $3
          |2| pedoff
     ;;ap
     ::ap Verse altVerse I
          4|1 time-advance
          comping off
     ;;ap
;ap
ifend
     
    
