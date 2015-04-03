\ $Workfile:   volume.f  $
\
\ volume adjustment algorithm
\
\ $Revision:   1.2  $
\ $Log:   B:/formula/vcs/volume.f_v  $
\ 
\    Rev 1.2   07 Nov 1990 09:12:44   b0b
\ SetVolumeRange now also sets a random starting volume within that range
\ by summing 4 random numbers.
\ 
\    Rev 1.1   04 Nov 1990 10:20:44   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.0   03 Sep 1990 18:34:54   b0b
\ Initial revision.

ifndef __VOLUME
create __VOLUME  .( loading volume.f...) cr

pquan $minvol
pquan $maxvol
pquan $vstep

:ap SetVolumeRange ( v1 v2 -- )
     2dup 
     min to $minvol
     max to $maxvol
     $maxvol $minvol - 2 >> to $vstep        \ $vstep is 1/4th of the range
     $minvol
     $vstep irnd +  $vstep irnd +
     $vstep irnd +  $vstep irnd +            \ initial $volume
     to $volume
;ap

:ap ?ChangeVolume  ( -- )
     brnd
     if   $volume $vstep irnd 
          brnd
          if   - $minvol max
          else + $maxvol min
          then 
          to $volume
     then
;ap

ifend
