\ $Workfile:   b0b.f  $
\ Conveniences for FORMULA
\ $Revision:   1.6  $
\ $Log:   B:/formula/vcs/b0b.f_v  $
\ 
\    Rev 1.6   12 Jan 1991 17:55:06   b0b
\ Added Unlikely constant
\ 
\    Rev 1.5   30 Dec 1990 01:46:44   b0b
\ added 5Rand
\ 
\    Rev 1.4   02 Aug 1992 01:03:38   b0b
\ Added Rand, 3Rand, etc. for fast generation of small random numbers.
\ 
\    Rev 1.3   24 Nov 1990 20:59:56   b0b
\ Added 'Index' alias for Forth's 'i', because we use 'i' as a chord name
\ (the tonic minor chord).  Also added /24th note definition, and rewrote
\ RootKey to use recursion instead of begin ... while ... repeat.
\ 
\    Rev 1.2   04 Nov 1990 10:18:18   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.1   03 Sep 1990 12:36:02   b0b
\ Added PVCS comment header

\ Naming convention:
\ Neither Forthmacs nor FORMULA use uppercase at all, so when you
\ see an uppercase letter in a word name, you know it's mine.  The 
\ one exception is my own vocabulary, which is, of course, b0b.

.( loading b0b.f...)  cr

vocabulary b0b          \ the b0b vocabulary

forth definitions

: Forth  ( -- )         \ uppercase F invokes our default search order
     only 
     forth also     internals also      b0b also
     b0b definitions 
; immediate 
     
Forth

hex -b0b constant Unlikely
decimal 

alias Cell     /n        \ a Cell is 4 bytes in Forthmacs
alias Cells    /n*       \ more readable
alias Index    i         \ we must use 'i' as a chord name

alias BPM      beats-per-minute

\ some important speedy constants

2 Cells constant 2n      3 Cells constant 3n      4 Cells constant 4n
5 Cells constant 5n      6 Cells constant 6n      7 Cells constant 7n

\ shuffle timing

:sg ~/3      1|3  &  ;sg     \ third note timing sequence
:sg ~/6      1|6  &  ;sg     \ sixth note timing sequence
:sg ~/12     1|12 &  ;sg     \ twelfth note timing sequence
:sg ~/24     1|24 &  ;sg     \ twenty-fourth note

:ap /3  ::tsg begin ~/3  again ;;sg ;ap
:ap /6  ::tsg begin ~/6  again ;;sg ;ap
:ap /12 ::tsg begin ~/12 again ;;sg ;ap
:ap /24 ::tsg begin ~/24 again ;;sg ;ap

\ the octave that a "root" is in:

quan loR  38 to loR      \ lowest root is D
quan hiR  49 to hiR      \ highest root is C#

: RootKey  ( n -- n' )   \ move a note to the root octave
     recursive                \ this word calls itself
     dup hiR >
     if   12 -                \ note too high, knock it down an octave
          RootKey             \  and try again
     else dup loR <
          if   12 +           \ note too low, bring it up an octave
               RootKey        \  and try again
          then
     then
;

\ these channel assignment words are defered
\ for synthesizer independence

defer melodyChannel    ' noop is melodyChannel       \ melody (?!) 
defer chordChannel     ' noop is chordChannel        \ chord
defer pianoChannel     ' noop is pianoChannel        \ piano
defer guitarChannel    ' noop is guitarChannel       \ guitar
defer bassChannel      ' noop is bassChannel         \ bass
defer drumChannel      ' noop is drumChannel         \ drum kit
defer drummerChannel   ' noop is drummerChannel      \ pattern drum machine

\ These drum words are also defered.
\ They should sound the drum without advancing time (use z$ to do this).
\ Complex drum sounds can thus be built from large kits.

defer Snare   ' noop is Snare    \ hit snare
defer Rim     ' noop is Rim      \ hit rim shot
defer Kick    ' noop is Kick     \ hit bass drum
defer cHat    ' noop is cHat     \ hit closed high hat
defer oHat    ' noop is oHat     \ hit open high hat
defer Ride    ' noop is Ride     \ hit ride cymbal
defer Crash   ' noop is Crash    \ hit crash cymbal
defer loTom   ' noop is loTom    \ hit low tom tom
defer hiTom   ' noop is hiTom    \ hit high tom tom
defer Clap    ' noop is Clap     \ hit hand clap
 
\ words to mark time

:ap |1|   1|1  time-advance  ;ap
:ap |2|   1|2  time-advance  ;ap
:ap |3|   1|3  time-advance  ;ap
:ap |4|   1|4  time-advance  ;ap
:ap |6|   1|6  time-advance  ;ap
:ap |8|   1|8  time-advance  ;ap
:ap |9|   1|9  time-advance  ;ap
:ap |12|  1|12 time-advance  ;ap
:ap |16|  1|16 time-advance  ;ap
:ap |24|  1|24 time-advance  ;ap
:ap |32|  1|32 time-advance  ;ap
:ap |48|  1|48 time-advance  ;ap
:ap |64|  1|64 time-advance  ;ap
:ap |96|  1|96 time-advance  ;ap


\ fast random number things based on brnd

alias 1Rand brnd

: 2Rand ( -- n )  \ returns 0, 1, or 2
  1Rand 1Rand + 
;

: 3Rand ( -- n )  \ range 0-3
  1Rand 2Rand + 
;

: 4Rand ( -- n )  \ range 0-4
  2Rand 2Rand + 
;

: 5Rand ( -- n )  \ range 0-5
  1Rand 4Rand +
;

: Rand ( i -- n )  \ range 0 to i
  0 tuck
  ?do  1Rand +
  loop
;
