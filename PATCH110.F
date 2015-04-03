\ $Workfile:   patch110.f  $
\
\ patch definitions for Roland U-110 PCM Sound Module
\
\ $Revision:   1.1  $
\ $Log:   B:/formula/vcs/patch110.f_v  $
\ 
\    Rev 1.1   30 Dec 1990 23:11:24   b0b
\ Added some of my personal synth patches
\ 
\    Rev 1.0   29 Nov 1990 17:10:40   b0b
\ Initial revision.

needs b0b      b0b.f   

Forth also ap-defs also
forth definitions decimal

ifdef __PATCH110  forget __PATCH110
ifend
create __PATCH110  .( loading patch110.f...)  cr

ifndef U-CTRL    \ in case it's not defined yet (oops!)

\ It saves a lot of confusion if you set the control channel
\ to a channel that you aren't using to generate tones.
\ 
\      SETUP:MIDI
\      CTRL CHANNEL =16

       15 constant U-CTRL       \ set synth for channel 16
ifend

\ the internal tones

:ap a.piano.1        0 to $patch ;ap    :ap a.piano.2        1 to $patch ;ap
:ap a.piano.3        2 to $patch ;ap    :ap a.piano.4        3 to $patch ;ap
:ap a.piano.5        4 to $patch ;ap    :ap a.piano.6        5 to $patch ;ap
:ap a.piano.7        6 to $patch ;ap    :ap a.piano.8        7 to $patch ;ap
:ap a.piano.9        8 to $patch ;ap    :ap a.piano.10       9 to $patch ;ap
:ap e.piano.1       10 to $patch ;ap    :ap e.piano.2       11 to $patch ;ap
:ap e.piano.3       12 to $patch ;ap    :ap e.piano.4       13 to $patch ;ap
:ap e.piano.5       14 to $patch ;ap    :ap vib.1           15 to $patch ;ap
:ap vib.2           16 to $patch ;ap    :ap vib.3           17 to $patch ;ap
:ap bell.1          18 to $patch ;ap    :ap bell.2          19 to $patch ;ap
:ap bell.3          20 to $patch ;ap    :ap bell.4          21 to $patch ;ap
:ap marimba         22 to $patch ;ap    :ap a.guitar.1      23 to $patch ;ap
:ap a.guitar.2      24 to $patch ;ap    :ap a.guitar.3      25 to $patch ;ap
:ap a.guitar.4      26 to $patch ;ap    :ap a.guitar.5      27 to $patch ;ap
:ap e.guitar.1      28 to $patch ;ap    :ap e.guitar.2      29 to $patch ;ap
:ap e.guitar.3      30 to $patch ;ap    :ap e.guitar.4      31 to $patch ;ap
:ap slap.1          32 to $patch ;ap    :ap slap.2          33 to $patch ;ap
:ap slap.3          34 to $patch ;ap    :ap slap.4          35 to $patch ;ap
:ap slap.5          36 to $patch ;ap    :ap slap.6          37 to $patch ;ap
:ap slap.7          38 to $patch ;ap    :ap slap.8          39 to $patch ;ap
:ap slap.9          40 to $patch ;ap    :ap slap.10         41 to $patch ;ap
:ap slap.11         42 to $patch ;ap    :ap slap.12         43 to $patch ;ap
:ap fingered.1      44 to $patch ;ap    :ap fingered.2      45 to $patch ;ap
:ap picked.1        46 to $patch ;ap    :ap picked.2        47 to $patch ;ap
:ap fretless.1      48 to $patch ;ap    :ap fretless.2      49 to $patch ;ap
:ap ac.bass         50 to $patch ;ap    :ap syn.bass.1      51 to $patch ;ap
:ap syn.bass.2      52 to $patch ;ap    :ap syn.bass.3      53 to $patch ;ap
:ap choir.1         54 to $patch ;ap    :ap choir.2         55 to $patch ;ap
:ap choir.3         56 to $patch ;ap    :ap choir.4         57 to $patch ;ap
:ap strings.1       58 to $patch ;ap    :ap strings.2       59 to $patch ;ap
:ap strings.3       60 to $patch ;ap    :ap strings.4       61 to $patch ;ap
:ap e.organ.1       62 to $patch ;ap    :ap e.organ.2       63 to $patch ;ap
:ap e.organ.3       64 to $patch ;ap    :ap e.organ.4       65 to $patch ;ap
:ap e.organ.5       66 to $patch ;ap    :ap e.organ.6       67 to $patch ;ap
:ap e.organ.7       68 to $patch ;ap    :ap e.organ.8       69 to $patch ;ap
:ap e.organ.9       70 to $patch ;ap    :ap e.organ.10      71 to $patch ;ap
:ap e.organ.11      72 to $patch ;ap    :ap e.organ.12      73 to $patch ;ap
:ap e.organ.13      74 to $patch ;ap    :ap soft.tp.1       75 to $patch ;ap
:ap soft.tp.2       76 to $patch ;ap    :ap soft.tp.3       77 to $patch ;ap
:ap tp/trb.1        78 to $patch ;ap    :ap tp/trb.2        79 to $patch ;ap
:ap tp/trb.3        80 to $patch ;ap    :ap tp/trb.4        81 to $patch ;ap
:ap tp/trb.5        82 to $patch ;ap    :ap tp/trb.6        83 to $patch ;ap
:ap sax.1           84 to $patch ;ap    :ap sax.2           85 to $patch ;ap
:ap sax.3           86 to $patch ;ap    :ap sax.4           87 to $patch ;ap
:ap sax.5           88 to $patch ;ap    :ap brass.1         89 to $patch ;ap
:ap brass.2         90 to $patch ;ap    :ap brass.3         91 to $patch ;ap
:ap brass.4         92 to $patch ;ap    :ap brass.5         93 to $patch ;ap
:ap flute.1         94 to $patch ;ap    :ap flute.2         95 to $patch ;ap
:ap shaku.1         96 to $patch ;ap    :ap shaku.2         97 to $patch ;ap
:ap drums           98 to $patch ;ap

\ voices from ROM card #6, Orchestral Winds, are assigned to Map #1:

:ap timpani.1       99 to $patch ;ap    :ap timpani.2      100 to $patch ;ap
:ap oboe.1         101 to $patch ;ap    :ap oboe.2         102 to $patch ;ap
:ap oboe.3         103 to $patch ;ap    :ap oboe.4         104 to $patch ;ap
:ap oboe.5         105 to $patch ;ap    :ap bassoon.1      106 to $patch ;ap
:ap bassoon.2      107 to $patch ;ap    :ap bassoon.3      108 to $patch ;ap
:ap bassoon.4      109 to $patch ;ap    :ap clarinet.1     110 to $patch ;ap
:ap clarinet.2     111 to $patch ;ap    :ap clarinet.3     112 to $patch ;ap
:ap clarinet.4     113 to $patch ;ap    :ap clarinet.5     114 to $patch ;ap
:ap bass.cl.1      115 to $patch ;ap    :ap bass.cl.2      116 to $patch ;ap
:ap bass.cl.3      117 to $patch ;ap    :ap bass.cl.4      118 to $patch ;ap
:ap fr.horn.1      119 to $patch ;ap    :ap fr.horn.2      120 to $patch ;ap
:ap fr.horn.3      121 to $patch ;ap    :ap fr.horn.4      122 to $patch ;ap
:ap fr.horn.5      123 to $patch ;ap    :ap tuba.1         124 to $patch ;ap
:ap tuba.2         125 to $patch ;ap    :ap tuba.3         126 to $patch ;ap
:ap tuba.4         127 to $patch ;ap


 

\ The 64 factory preset Patches are selected on the U-CTRL MIDI channel.
\ The names here are exactly as they appear on the display, with "_" as 
\ the "space" character.  Trailing spaces are not included.

: U$patch  ( n -- )  
    $channel swap U-CTRL mpc
    to $channel
;

\ the factory patches have been commented out
\ :ap Ac.Piano        0 U$patch ;ap      :ap Brt_Piano       1 U$patch ;ap
\ :ap ff_Piano        2 U$patch ;ap      :ap Wide_Piano      3 U$patch ;ap
\ :ap Double_A.P      4 U$patch ;ap      :ap Dtun_Piano      5 U$patch ;ap
\ :ap E.Piano         6 U$patch ;ap      :ap Double_E.P      7 U$patch ;ap
\ :ap Detune_E.P      8 U$patch ;ap      :ap Hard_E.P        9 U$patch ;ap
\ :ap Vibraphone     10 U$patch ;ap      :ap Hard_Vib       11 U$patch ;ap
\ :ap DetuneBell     12 U$patch ;ap      :ap Marimba        13 U$patch ;ap
\ :ap A.Guitar       14 U$patch ;ap      :ap Double_A.G     15 U$patch ;ap
\ :ap 12Str_A.G      16 U$patch ;ap      :ap Mute_Sw_EG     17 U$patch ;ap
\ :ap Double_EG      18 U$patch ;ap      :ap Slap_Bass      19 U$patch ;ap
\ :ap DetuneBass     20 U$patch ;ap      :ap V-Sw_Slap      21 U$patch ;ap
\ :ap Fing_Bass      22 U$patch ;ap      :ap Pick_Bass      23 U$patch ;ap
\ :ap Fless_Bass     24 U$patch ;ap      :ap Ac.Bass        25 U$patch ;ap
\ :ap Synth_Bass     26 U$patch ;ap      :ap Choir          27 U$patch ;ap
\ :ap Oct_Choir      28 U$patch ;ap      :ap Double_Chr     29 U$patch ;ap
\ :ap Strings        30 U$patch ;ap      :ap Double_Str     31 U$patch ;ap
\ :ap E.Organ        32 U$patch ;ap      :ap DoubleOrg1     33 U$patch ;ap
\ :ap DoubleOrg2     34 U$patch ;ap      :ap Soft_Tp        35 U$patch ;ap
\ :ap Tp/Tromb       36 U$patch ;ap      :ap Oct_Tp/Trb     37 U$patch ;ap
\ :ap Sax            38 U$patch ;ap      :ap Bright_Sax     39 U$patch ;ap
\ :ap Detune_Sax     40 U$patch ;ap      :ap Oct_Sax        41 U$patch ;ap
\ :ap Brass          42 U$patch ;ap      :ap Oct_Brass      43 U$patch ;ap
\ :ap Double_Brs     44 U$patch ;ap      :ap Flute          45 U$patch ;ap
\ :ap Dtn_Flute      46 U$patch ;ap      :ap Shakuhachi     47 U$patch ;ap
\ :ap Drums          48 U$patch ;ap      :ap Double_Drm     49 U$patch ;ap
\ :ap Short_Drm      50 U$patch ;ap      :ap Fantasy        51 U$patch ;ap
\ :ap Brs_+_Str      52 U$patch ;ap      :ap 5th_Br+Str     53 U$patch ;ap
\ :ap Choir+Str      54 U$patch ;ap      :ap Thick_Bell     55 U$patch ;ap
\ :ap Guit>Piano     56 U$patch ;ap      :ap Trump>Sax      57 U$patch ;ap
\ :ap Sax_/_Tp       58 U$patch ;ap      :ap Multi-Set1     59 U$patch ;ap
\ :ap Multi-Set2     60 U$patch ;ap      :ap Multi-Set3     61 U$patch ;ap
\ :ap Multi-Set4     62 U$patch ;ap      :ap Multi-Set5     63 U$patch ;ap

\ these are my patches
:ap Academy_49       1 U$patch ;ap
:ap Do.Thing         2 U$patch ;ap
:ap pQuartz.        40 U$patch ;ap
:ap Quartz.         41 U$patch ;ap
:ap Church          57 U$patch ;ap
:ap Ohm2.           58 U$patch ;ap
:ap Orchestron      60 U$patch ;ap
:ap Techs.Band      63 U$patch ;ap

