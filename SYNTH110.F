\ $Workfile:   synth110.f  $
\
\ Configuration for Roland U-110 PCM Sound Module
\
\ $Revision:   1.5  $
\ $Log:   B:/formula/vcs/synth110.f_v  $
\ 
\    Rev 1.5   29 Nov 1990 17:07:42   b0b
\ Removed patch information to PATCH110.f
\ 
\    Rev 1.4   21 Dec 1991 01:02:16   b0b
\ Added Part_1, Part_2, etc. aliases to match U-110 terminology.
\ 
\    Rev 1.3   07 Nov 1990 09:08:14   b0b
\ No change?
\ 
\    Rev 1.2   04 Nov 1990 10:19:10   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.1   03 Sep 1990 12:36:30   b0b
\ Added PVCS comment header

needs b0b      b0b.f   

Forth also ap-defs also
forth definitions decimal

ifdef __SYNTH110  forget __SYNTH110
ifend
create __SYNTH110  .( loading synth110.f...)  cr

\ set up to use Patch 60 - "Multi-Set1"
\ These are the MIDI channel assignments:
\ 0 - piano
\ 1 - bass
\ 2 - guitar
\ 3 - horn
\ 4 - sax
\ 9 - drums

\ It saves a lot of confusion if you set the control channel
\ to a channel that you aren't using to generate tones.
\ 
\ SETUP:MIDI
\ CTRL CHANNEL =16

15 constant U-CTRL       \ set synth for channel 16

quan U-110          \ U-110 synth descriptor
quan U-melody       \ melody channel descriptor
quan U-chord        \ chord channel descriptor
quan U-bass         \ bass channel descriptor
quan U-drum         \ drum channel descriptor
quan U-alt1         \ alternate voices
quan U-alt2

: config-U-110    
  \ setup like Multi-Set1 (Output Mode 49)
    declare-synth to U-110
    9 U-110 ['] generic-MIDI-driver    8 declare-channel to U-drum  
    1 U-110 ['] generic-MIDI-driver    8 declare-channel to U-bass
    0 U-110 ['] generic-MIDI-driver    7 declare-channel to U-melody
    2 U-110 ['] generic-MIDI-driver    8 declare-channel to U-chord
    3 U-110 ['] generic-MIDI-driver    4 declare-channel to U-alt1
    4 U-110 ['] generic-MIDI-driver    4 declare-channel to U-alt2
    U-CTRL
    U-110 ['] generic-MIDI-driver      0 declare-channel drop
;

: select-U-110
    $DSM                      \ use dumb synth manager
    U-melody to $channel  ;   \ melody channel

' config-U-110 is set-synth-config      \ setup for boot time
' select-U-110 is select-paradigm

: select-U-110-chord    $DSM  U-chord to $channel ;
: select-U-110-bass     $DSM  U-bass to $channel  ;
: select-U-110-drum     $DSM  U-drum to $channel ;
: select-U-110-alt1     $DSM  U-alt1 to $channel ;
: select-U-110-alt2     $DSM  U-alt2 to $channel ;

\ We use the following words (from b0b.f) for synth independence:

' select-U-110       is melodyChannel
' select-U-110-chord is chordChannel
' select-U-110-bass  is bassChannel
' select-U-110-drum  is drumChannel

\ Here's a set of channel setup words more in keeping
\ with the terminology seen on the U-110 front panel

alias Part_1   select-U-110-drum        alias MIDI_10  select-U-110-drum
alias Part_2   select-U-110-bass        alias MIDI_2   select-U-110-bass
alias Part_3   select-U-110             alias MIDI_1   select-U-110
alias Part_4   select-U-110-chord       alias MIDI_3   select-U-110-chord
alias Part_5   select-U-110-alt1        alias MIDI_4   select-U-110-alt1
alias Part_6   select-U-110-alt2        alias MIDI_5   select-U-110-alt2

needs __PATCH110      patch110.f


