\ $Workfile:   chet&far.f  $
\
\ Chet & Farley synth configuration for Roland U-110 PCM Sound Module
\
\ $Revision:   1.0  $

needs b0b      b0b.f   

Forth also ap-defs also
forth definitions decimal

ifdef __CHET&FARLEY  forget __CHET&FARLEY
ifend
create __CHET&FARLEY  .( loading chet&far.f...)  cr

\ It saves a lot of confusion if you set the Patch control channel
\ to a MIDI channel that you aren't for music data on the U-110.
\ 
\ SETUP:MIDI
\ CTRL CHANNEL =16

15 constant U-CTRL         \ set synth for channel 16

quan U-synth               \ U-110 synth descriptor

quan basschannel           \ channel descriptors
quan chordchannel
quan bothdrumchannel
quan extdrumchannel
quan intdrumchannel

: C&Fsynth       \ setup for U-110 Chet & Farley patch
     declare-synth to U-synth
\   MIDI channel (0 based)               #voices
     0  U-synth ['] generic-MIDI-driver  4  declare-channel to basschannel  
     1  U-synth ['] generic-MIDI-driver  11 declare-channel to chordchannel
     9  U-synth ['] generic-MIDI-driver  16 declare-channel to bothdrumchannel
     10 U-synth ['] generic-MIDI-driver  16 declare-channel to extdrumchannel
     11 U-synth ['] generic-MIDI-driver  16 declare-channel to intdrumchannel
     U-CTRL
        U-synth ['] generic-MIDI-driver   0 declare-channel drop
;

\ use the ____MC words to specify the MIDI Channel to use

:ap BassMC   $DSM basschannel  to $channel ;ap
:ap ChordMC  $DSM chordchannel to $channel ;ap

:ap BothDrumsMC  $DSM bothdrumchannel to $channel ;ap
:ap CardDrumsMC  $DSM extdrumchannel  to $channel ;ap
:ap U110DrumsMC  $DSM intdrumchannel  to $channel ;ap
    
\ setup for when we say "formula"

' C&Fsynth    is set-synth-config
' ChordMC     is select-paradigm

\ select C&F patch

:ap Chet&Farley  ( -- )
     $channel 
     49 U-CTRL mpc	\ P-50 on the Roland U-110
     to $channel
;ap

formula Chet&Farley

