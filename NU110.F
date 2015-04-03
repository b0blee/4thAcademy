\ $Workfile:   nu110.f  $
\
\ Configuration for Roland U-110 PCM Sound Module
\
\ This is more versatile than the old SYNTH110.f code module.
\
\ $Revision:   1.0  $
\ $Log:   B:/formula/vcs/nu110.f_v  $
\ 
\    Rev 1.0   29 Nov 1990 17:09:24   b0b
\ Initial revision.

needs b0b      b0b.f   

Forth also ap-defs also
forth definitions decimal

ifdef __NU110  forget __NU110
ifend
create __NU110  .( loading nu110.f...)  cr

\ It saves a lot of confusion if you set the control channel
\ to a channel that you aren't using to generate tones.
\ 
\ SETUP:MIDI
\ CTRL CHANNEL =16

15 constant U-CTRL       \ set synth for channel 16

quan U-synth          \ U-110 synth descriptor

quan U-part1          \ channel descriptors
quan U-part2
quan U-part3
quan U-part4
quan U-part5
quan U-part6
quan U-control


: Mode_49      \ setup for U-110 Output Mode 49
     declare-synth to U-synth
\    MIDI channel                         voices
     0 U-synth ['] generic-MIDI-driver    8 declare-channel to U-part1  
     1 U-synth ['] generic-MIDI-driver    8 declare-channel to U-part2
     2 U-synth ['] generic-MIDI-driver    7 declare-channel to U-part3
     3 U-synth ['] generic-MIDI-driver    8 declare-channel to U-part4
     4 U-synth ['] generic-MIDI-driver    4 declare-channel to U-part5
     5 U-synth ['] generic-MIDI-driver    4 declare-channel to U-part6
     U-CTRL
       U-synth ['] generic-MIDI-driver    0 declare-channel to U-control
;


: Mode_20      \ setup for U-110 Output Mode 20
     declare-synth to U-synth
\    MIDI channel                         voices
     0 U-synth ['] generic-MIDI-driver    7 declare-channel to U-part1  
     1 U-synth ['] generic-MIDI-driver    8 declare-channel to U-part2
     2 U-synth ['] generic-MIDI-driver    4 declare-channel to U-part3
     3 U-synth ['] generic-MIDI-driver    4 declare-channel to U-part4
     4 U-synth ['] generic-MIDI-driver    4 declare-channel to U-part5
     5 U-synth ['] generic-MIDI-driver    4 declare-channel to U-part6
     U-CTRL
       U-synth ['] generic-MIDI-driver    0 declare-channel to U-control
;

\ part setup

: Part_1  $DSM U-part1 to $channel ;
: Part_2  $DSM U-part2 to $channel ;
: Part_3  $DSM U-part3 to $channel ;
: Part_4  $DSM U-part4 to $channel ;
: Part_5  $DSM U-part5 to $channel ;
: Part_6  $DSM U-part6 to $channel ;


\ setup for when we say "formula"

' Mode_49 is set-synth-config
' Part_1  is select-paradigm

\ patches

needs __PATCH110      patch110.f


