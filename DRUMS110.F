\ $Workfile:   drums110.f  $
\ drum note assignments for the Roland U-110
\ $Revision:   1.2  $
\ $Log:   B:/formula/vcs/drums110.f_v  $
\ 
\    Rev 1.2   04 Nov 1990 10:17:42   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.1   03 Sep 1990 12:33:36   b0b
\ Added PVCS header comment

needs b0b   b0b.f

Forth
ifndef __DRUMS110
create __DRUMS110  .( loading drums110.f...) cr

: ConstC
     create c,
     does>  c@ 
;

\ terse mnemonics for each drum in the kit

35 ConstC bd1       \ bass drum 1
36 ConstC bd2       \ bass drum 2
37 ConstC rs        \ rim shot
38 ConstC sd1       \ snare drum 1
39 ConstC hc        \ hand clap
40 ConstC sd2       \ snare drum 2
41 ConstC ltt1      \ low tom tom 1
42 ConstC chh1      \ closed high hat 1
43 ConstC ltt2      \ low tom tom 2
44 ConstC ohh2      \ open high hat 2
45 ConstC mtt1      \ middle tom tom 1
46 ConstC ohh1      \ open high hat 1
47 ConstC mtt2      \ middle tom tom 2
48 ConstC htt1      \ high tom tom 1
49 ConstC ccl       \ crash cymbal (low)
50 ConstC htt2      \ high tom tom 2
51 ConstC rcl       \ ride cymbal (low)
52 ConstC chil      \ chinese cymbal (low)
53 ConstC cup       \ cup (muted cymbal)

56 ConstC cowbell   \ cowbell
57 ConstC cch       \ crash cymbal (high)
58 ConstC sd3       \ snare drum 3
59 ConstC rch       \ ride cymbal (high)

69 ConstC cabasa    \ cabasa

79 ConstC hptt2     \ high pitch tom tom 2 (high)

81 ConstC hptt1     \ high pitch tom tom 1 (higher)

84 ConstC bd3       \ bass drum 3
85 ConstC bd4       \ bass drum 4
86 ConstC sd4       \ snare drum 4
87 ConstC sd5       \ snare drum 5
88 ConstC sd6       \ snare drum 6
89 ConstC ltt3      \ low tom tom 3
90 ConstC chh2      \ closed high hat 2
91 ConstC mtt3      \ middle tom tom 3
92 ConstC chih      \ chinese cymbal (high)
93 ConstC htt3      \ high tom tom 3
94 ConstC rcm       \ ride cymbal (mid)


:ap snare   sd1  z$ ;ap  ' snare is Snare
:ap kick    bd1  z$ ;ap  ' kick  is Kick
:ap rim     rs   z$ ;ap  ' rim   is Rim
:ap ohat    ohh1 z$ ;ap  ' ohat  is oHat
:ap chat    chh1 z$ ;ap  ' chat  is cHat
:ap ride    rcm  z$ ;ap  ' ride  is Ride

ifend
