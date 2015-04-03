\ $Workfile:   snap.f  $
\ $Revision:   1.2  $
\ $Log:   B:/formula/vcs/snap.f_v  $
\ 
\    Rev 1.2   04 Nov 1990 10:18:52   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.1   03 Sep 1990 22:18:50   b0b
\ cleaner implementation uses recursion
\ 
\    Rev 1.0   03 Sep 1990 18:56:10   b0b
\ Initial revision.

needs __CHORDS   chords.f

ifndef __SNAP
create __SNAP  .( loading Snap.f...) cr

\ algorithm to "snap" a note to the current triad

:ap (snap)  ( n -- n' )       \ assumes note is in Root octave
     dup 6th >
     if   drop 8th
     else dup 5th  >= 
          if   drop 5th 
          else 2nd > 
               if   3rd 
               else Root
               then
          then
     then 
;ap

:ap Snap  ( n -- n' )
     recursive                     \ this word calls itself
     dup Root <
     if   12 + Snap 12 -           \ note is below Root octave
     else dup Root 11 + > 
          if   12 - Snap 12 +      \ note is above Root octave
          else (snap)              \ recursion exit point
          then
     then
;ap
     
ifend
