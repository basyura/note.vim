

if exists('b:current_syntax')
  finish
endif

runtime! syntax/markdown.vim

setlocal conceallevel=2
setlocal concealcursor=nc

syntax match note_start "★"
syntax match note_strong "\*\*.\{-1,}\*\*" contains=note_strong_mark
syntax match note_strong_mark /\*\*/ contained conceal

highlight note_strong guifg=#ff9be8
highlight note_start  guifg=#ff9be8

if g:colors_name == 'solarized'
  hi markdownh1 guifg=brown
  hi markdownh2 guifg=brown
  hi markdownh3 guifg=brown
  hi markdownHeadingDelimiter guifg=brown
endif

let b:current_syntax = 'note'
