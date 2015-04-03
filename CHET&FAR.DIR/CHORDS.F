\ $Workfile:   chords.f  $
\ guitar chord voicings by b0b 
\ $Revision:   1.3  $
\ $Log:   B:/formula/vcs/chords.f_v  $
\ 
\    Rev 1.3   18 Feb 1991 13:16:06   b0b
\ Added definitions for I7 and IV7 chords, and alias V7 for V chord.
\ 
\    Rev 1.2   04 Nov 1990 10:17:58   b0b
\ implemented __NAME convention for file labels
\ 
\    Rev 1.1   03 Sep 1990 12:33:00   b0b
\ Added PVCS header comment

needs b0b      b0b.f

Forth
ifdef __CHORDS  forget __CHORDS
ifend
create __CHORDS  .( loading chords.f...)  cr

\ for readability, we define the notes in guitar range.
\ the lowest octave uses the _ prefix

50 constant _D      51 constant _D#     alias _Eb _D#
52 constant _E      53 constant _F      54 constant _F#
alias _Gb _F#       55 constant _G      56 constant _G#
alias _Ab _G#       57 constant _A      58 constant _A#
alias _Bb _A#       59 constant _B      60 constant _C
61 constant _C#     alias _Db _C#       alias _E# _F

\ middle octave uses ~ prefix

62 constant ~D      63 constant ~D#     alias ~Eb ~D#
64 constant ~E      65 constant ~F      66 constant ~F#
alias ~Gb ~F#       67 constant ~G      68 constant ~G#
alias ~Ab ~G#       69 constant ~A      70 constant ~A#
alias ~Bb ~A#       71 constant ~B      72 constant ~C
73 constant ~C#     alias ~Db ~C#       alias ~E# ~F

\ high guitar octave uses ^ prefix

74 constant ^D      75 constant ^D#     alias ^Eb ^D#
76 constant ^E      77 constant ^F      78 constant ^F#
alias ^Gb ^F#       79 constant ^G      80 constant ^G#
alias ^Ab ^G#       81 constant ^A      82 constant ^A#
alias ^Bb ^A#       83 constant ^B      84 constant ^C
85 constant ^C#     alias ^Db ^C#       alias ^E# ^F
86 constant ^^D


\ six note chords in memory use ` prefix
\ stashes a root tone and six-note chord in memory
: Chord:
    create  , , , , , ,  , 
;


\ create first position Major chords:

\ root  str6 str5 str4 str3 str2 str1         name
  _D    _D   _A   ~D   ~A   ^D   ^F#   Chord: `D
  _Eb   _Eb  _Bb  ~Eb  ~Bb  ^Eb  ^G    Chord: `Eb   alias `D# `Eb
  _E    _E   _B   ~E   ~G#  ~B   ^E    Chord: `E
  _F    _F   _C   ~F   ~A   ~C   ^F    Chord: `F
  _F#   _F#  _C#  ~F#  ~A#  ~C#  ^F#   Chord: `F#   alias `Gb `F#
  _G    _G   _B   ~D   ~G   ~B   ^G    Chord: `G
  _Ab   _Ab  _C   ~Eb  ~Ab  ^Eb  ^Ab   Chord: `Ab   alias `G# `Ab
  _A    _E   _A   ~E   ~A   ~C#  ^E    Chord: `A
  _Bb   _F   _Bb  ~F   ~Bb  ^D   ^F    Chord: `Bb   alias `A# `Bb
  _B    _F#  _B   ~F#  ~B   ^D#  ^F#   Chord: `B
  _C    _G   _C   ~E   ~G   ~C   ^G    Chord: `C
  _C#   _G#  _C#  ~E#  ~G#  ~C#  ^E#   Chord: `C#   alias `Db `C#


   
\ the first position Minor chords:

\ root  str6 str5 str4 str3 str2 str1         name
  _D    _D   _A   ~D   ~A   ^D   ^F    Chord: `Dm
  _Eb   _Eb  _Bb  ~Eb  ~Bb  ^Eb  ^Gb   Chord: `Ebm  alias `D#m `Ebm
  _E    _E   _B   ~E   ~G   ~B   ^E    Chord: `Em
  _F    _F   _C   ~F   ~Ab  ~C   ^F    Chord: `Fm
  _F#   _F#  _C#  ~F#  ~A   ~C#  ^F#   Chord: `F#m  alias `Gbm `F#m
  _G    _G   ~D   ~G   ~Bb  ^D   ^G    Chord: `Gm
  _G#   _G#  ~D#  ~G#  ~B   ^D#  ^G#   Chord: `G#m  alias `Abm `G#m
  _A    _E   _A   ~E   ~A   ~C   ^E    Chord: `Am
  _Bb   _F   _Bb  ~F   ~Bb  ~Db  ^F    Chord: `Bbm  alias `A#m `Bbm
  _B    _F#  _B   ~F#  ~B   ^D   ^F#   Chord: `Bm
  _C    _G   _C   ~Eb  ~G   ~C   ^G    Chord: `Cm
  _C#   _G#  _C#  ~E   ~G#  ~C#  ^E    Chord: `C#m  alias `Dbm `C#m


\ guitar chord arrays

\ to look up chords, pitch n becomes zero based.
\ 'any D' = 0
: D_range  ( n -- n' )
     _D - dup 0<
     if   begin 12 + dup 0> 
          until
     else dup 11 >
         if   begin 12 - dup 12 < 
              until
         then
     then 
;


\ create 12-chord arrays
: 12Chords:  
     create                  \ assumes addresses of 12 chords follow
     does>  ( n -- adr[n] )     
         swap D_range
         Cells + @           \ at runtime, extracts chords from table
;

12Chords: _Majors
    `D ,     `Eb ,    `E ,     `F ,     `F# ,    `G ,
    `G# ,    `A ,     `Bb ,    `B ,     `C ,     `C# ,     

12Chords: _Minors
    `Dm ,    `Ebm ,   `Em ,    `Fm ,    `F#m ,   `Gm ,
    `G#m ,   `Am ,    `Bbm ,   `Bm ,    `Cm ,    `C#m ,    



\ reminder: the definition of bassChannel (in the synth configuration)
\           should transpose guitar pitches down one octave.  If the
\           synth patch itself doesn't do it, set #transpose to -12.0.

\ extracting guitar notes from the current chord

quan _Chord     \ the current chord's memory address  

: Gtr1  ( -- note )     _Chord @  ;
: Gtr2  ( -- note )     _Chord /n + @ ;
: Gtr3  ( -- note )     _Chord 2n + @  ;
: Gtr4  ( -- note )     _Chord 3n + @  ;
: Gtr5  ( -- note )     _Chord 4n + @  ;
: Gtr6  ( -- note )     _Chord 5n + @  ;

\ basic bass stuff 

\ these quans tell the bass handler how to alter the basic notes of a chord.
\ For example, _alt7 gets set to -1 on a dominant 7th chord, 0 on a major 7th.

quan _Alt2      quan _Alt3      quan _Alt4
quan _Alt5      quan _Alt6      quan _Alt7

\ our bass player plays by these numbers:

: Root  ( -- note )    _Chord 6n + @ RootKey  ;
: 2nd   ( -- note )    Root 2 +  _Alt2 +  ;
: -3rd  ( -- note )    Root 3 +  ;
: 3rd   ( -- note )    Root 4 +  _Alt3 +  ;
: 4th   ( -- note )    Root 5 +  _Alt4 +  ;
: -5th  ( -- note )    Root 6 +  ;
: 5th   ( -- note )    Root 7 +  _Alt5 +  ;
: +5th  ( -- note )    Root 8 +  ;
: 6th   ( -- note )    Root 9 +  _Alt6 +  ;
: -7th  ( -- note )    Root 10 +  ;
: 7th   ( -- note )    Root 11 +  _Alt7 +  ;
: 8th   ( -- note )    Root 12 +  ;
: -9th  ( -- note )    Root 13 +  ;
: 9th   ( -- note )    Root 14 +  ;


\ chords by the number

quan _Key           \ a copy of Root of the key we're in

: (Major)  ( ofst -- )     \ setting up a major chord
     _Key + _Majors to _Chord    
     0 to _Alt2  0 to _Alt3   0 to _Alt5  0 to _Alt6  
;

: I    ( -- )   0 (Major)  0 to _Alt4   0 to _Alt7  ; 
: -II  ( -- )   1 (Major)  0 to _Alt4   0 to _Alt7  ; 
: II   ( -- )   2 (Major)  0 to _Alt4  -1 to _Alt7  ; 
: -III ( -- )   3 (Major)  1 to _Alt4  -1 to _Alt7  ; 
: III  ( -- )   4 (Major)  0 to _Alt4  -1 to _Alt7  ; 
: IV   ( -- )   5 (Major)  1 to _Alt4   0 to _Alt7  ; 
: -V   ( -- )   6 (Major)  1 to _Alt4   0 to _Alt7  ; 
: V    ( -- )   7 (Major)  0 to _Alt4  -1 to _Alt7  ; 
: -VI  ( -- )   8 (Major)  0 to _Alt4   0 to _Alt7  ; 
: VI   ( -- )   9 (Major)  0 to _Alt4  -1 to _Alt7  ; 
: -VII ( -- )  10 (Major)  0 to _Alt4   0 to _Alt7  ; 
: VII  ( -- )  11 (Major)  0 to _Alt4   0 to _Alt7  ; 

: I7   ( -- )    I    -1 to _Alt7    ;
: IV7  ( -- )    IV   -1 to _Alt7    ; 
alias V7 V

: (Minor)  ( ofst -- )     \ setting up a major chord
    _Key + _Minors to _Chord    
    -1 to _Alt3  0 to _Alt4  0 to _Alt5  -1 to _Alt7 
;


: i    ( -- )   0 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: -ii  ( -- )   1 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: ii   ( -- )   2 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: -iii ( -- )   3 (Minor)   0 to _Alt6   0 to _Alt2  ; 
: iii  ( -- )   4 (Minor)  -1 to _Alt6  -1 to _Alt2  ; 
: iv   ( -- )   5 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: -v   ( -- )   6 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: v    ( -- )   7 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: -vi  ( -- )   8 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: vi   ( -- )   9 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: -vii ( -- )  10 (Minor)   0 to _Alt2   0 to _Alt6  ; 
: vii  ( -- )  11 (Minor)   0 to _Alt2   0 to _Alt6  ; 


_D to _Key  I       \ initialization


