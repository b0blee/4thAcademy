\ $Workfile:   volume.f  $
\
\ volume adjustment algorithm
\
\ $Revision:   1.3  $
\ $Log:   B:/formula/vcs/volume.f_v  $
\ 
\    Rev 1.3   18 Feb 1991 11:33:12   b0b
\ Added more useful primitives ++V --V etc.
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
     $maxvol $minvol - 2/     \ range/2
     dup   2/  to $vstep      \ $vstep is 1/4th of the range
     $minvol + to $volume     \ initial $volume at middle of range
;ap

:ap IncVolume  ( -- )
     $volume $vstep irnd +
     $maxvol min to $volume
;ap

:ap DecVolume  ( -- )
     $volume $vstep irnd -
     $minvol max to $volume
;ap

:ap ChangeVolume
     brnd 
     if   IncVolume
     else DecVolume
     then
;ap

:ap ?ChangeVolume  ( -- )
     brnd if   ChangeVolume
          then
;ap

alias ++V IncVolume
alias --V DecVolume
alias ??V ?ChangeVolume

:ap V$  ( n -- )    \ alter volume, play note
     ChangeVolume $
;ap

:ap ?V$  ( n -- )   \ maybe alter volume, then play note
     ??V $
;ap

:ap +V$ ( n -- )    \ play one louder note
     $volume swap
     ++V ++V $
     to $volume
;ap

:ap -V$ ( n -- )    \ play one softer note
     $volume swap
     --V --V $
     to $volume
;ap

ifend

