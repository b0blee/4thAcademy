\ $Workfile:   theme.f  $
\ $Revision:   1.4  $
\ $Log:   B:/formula/vcs/theme.f_v  $
\ 
\    Rev 1.4   12 Jan 1991 23:47:48   b0b
\ cleaned up PlayTheme
\ 
\    Rev 1.3   12 Jan 1991 19:23:48   b0b
\ fixed bug - Unlikely wasn't in ClearTheme
\ 
\    Rev 1.2   12 Jan 1991 17:56:22   b0b
\ Added deferred word Theme$ as the action verb in PlayTheme
\ Intialize note_cfa to the Unlikely constant
\ 
\    Rev 1.1   04 Jan 1991 19:38:18   b0b
\ Total rewrite
\ 
\    Rev 1.0   28 Dec 1990 23:41:20   b0b
\ Initial revision.

needs   b0b         b0b.f

Forth
ifdef __THEME  forget __THEME
ifend
create __THEME  .( loading theme.f...) cr

\ create a theme array
: Theme: 
  create ( tSize -- )
     align
     0 ,                 \ current ThemeIndex
     dup ,               \ max notes
     0
     do   ['] noop ,     \ timing cell  ( -- )
          ['] Unlikely , \ note cell    ( -- note )
     loop
  does>  ( -- theme )
     aligned
;

pquan $theme     \ convenient per-process theme array

\ --- theme array primitives ---

2 Cells constant tHeadSize

\ set theme index to 0
alias RewindTheme off    ( theme -- )

\ get current theme index
alias ThemeIndex @       ( theme -- n )

\ get theme size (number of cells)
: tSize  ( theme -- n )
     Cell + @
;

\ get address of slot n
: tSlot  ( theme n -- slotadr )
     2* Cells + tHeadSize +
;

\ get adr of current theme slot
: tCurSlot  ( theme -- slotadr )
     dup ThemeIndex tSlot
;

\ perform timing cell
alias tTime perform  ( slotadr -- )

\ perform note cell
: tNote  ( slotadr -- note )
     Cell + perform
;

\ is slot in valid range?
: tGoodSlot?  ( theme n -- flag )
     swap tSize <
;

\ ---- words to change the current theme index ----

\ backup the theme index by 1 notch
: --ThemeIndex  ( theme -- )
     dup ThemeIndex 1- 
     0 max swap !
;

\ advance the theme index by 1 notch
: ++ThemeIndex  ( theme -- )
     dup ThemeIndex 1+   \ current index +1
     over tSize 1-       \ max allowable index
     min swap !
;

\ set ThemeIndex to an absolute value
: >ThemeIndex  ( theme n -- )
     over tSize min 0 max
     swap !
;

\ --- words to change the contents of a theme array ---

\ clear a theme structure
: ClearTheme  ( theme -- )
     dup RewindTheme
     dup 0 tSlot              \ s: theme, adr of 0th slot
     swap tSize 0
     do   ['] noop over !     \ timing cfa
          Cell +
          ['] Unlikely over ! \ note cfa
          Cell +
     loop  drop
;


\ put timing_cfa into nth slot of theme
: Time>Theme  ( timing_cfa theme n -- )
     tSlot !
;
     

\ put note_cfa into nth slot of theme
: Note>Theme  ( note_cfa theme n -- )
     tSlot Cell + !
;     


\ put note_cfa and timing_cfa into current slot of theme, then inc theme index
: >Theme  ( note_cfa timing_cfa theme -- )
     dup >r 
     tCurSlot tuck !     \ stash timing_cfa
     Cell + !            \ stash note_cfa
     r> ++ThemeIndex
;


\ --- words to execute elements of a Theme array ---
  
\ execute timing cell n
: ThemeTime  ( theme n -- )
     2dup tGoodSlot?
     if   tSlot tTime
     else 2drop
     then
;


\ execute note cell n
: ThemeNote  ( theme n -- note )
     2dup tGoodSlot?
     if   tSlot tNote
     else 2drop
     then
;

\ execute current timing cell
: CurThemeTime  ( theme -- )
     tCurSlot tTime   
;

\ execute current note cell
: CurThemeNote  ( theme -- note )
     tCurSlot tNote
;

\ execute both cfa's and then increment the theme index
: Theme>  ( theme -- note )
     dup dup >r
     CurThemeTime        \ execute timing cell
     CurThemeNote        \ execute note cell
     r> ++ThemeIndex
;

\ execute a random timing cell
: RandThemeTime  ( theme -- )
     dup tSize irnd ThemeTime
;

\ execute a random note cell
: RandThemeNote  ( theme -- note )
     dup tSize irnd ThemeNote
;

\ execute a random timing/note cell pair
: RandThemeElement  ( theme -- note )
     dup tSize irnd 
     2dup ThemeTime ThemeNote
;


\ ************
\ Theme Player

defer Theme$  ( note -- )     \ the word used to play a note in PlayTheme
' $ is Theme$                 \ assign default value

\ the generic theme player
:ap PlayTheme  ( theme -- )
     dup tSize 0
     do   dup Index ThemeNote Unlikely <>
          if   dup Index ThemeTime
               dup Index ThemeNote Theme$
          then
     loop  drop
;ap


\ **************
\ Debugging aids

\ dump theme contents
:ap DumpTheme  ( theme -- )
     dup tSize 0
     do   Index 4 mod if 4 spaces else cr then
          dup Index tSlot
          dup @ >name .id
          Cell + @ >name .id
     loop  drop
;ap
