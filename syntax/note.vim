

if exists('b:current_syntax')
  finish
endif

setlocal conceallevel=2
setlocal concealcursor=nc

"runtime! syntax/markdown.vim
"
" Vim syntax original
" Language:     Markdown
" Maintainer:   Tim Pope <vimNOSPAM@tpope.org>
" Filenames:    *.markdown
" Last Change:	2010 May 21

syn sync minlines=10
syn case ignore

syn match noteValid '[<>]\S\@!'
syn match noteValid '&\%(#\=\w*;\)\@!'

syn match noteLineStart "^[<@]\@!" nextgroup=@noteBlock

syn cluster noteBlock contains=noteH1,noteH2,noteH3,noteH4,noteH5,noteH6,noteBlockquote,noteListMarker,noteOrderedListMarker,noteCodeBlock,noteRule
"syn cluster noteInline contains=noteLineBreak,noteLinkText,noteItalic,noteBold,noteCode,noteEscape,@htmlTop
syn cluster noteInline contains=noteLineBreak,noteLinkText,noteBold,noteCode,noteEscape,@htmlTop

syn match noteH1 ".\+\n=\+$" contained contains=@noteInline,noteHeadingRule
syn match noteH2 ".\+\n-\+$" contained contains=@noteInline,noteHeadingRule

syn match noteHeadingRule "^[=-]\+$" contained

syn region noteH1 matchgroup=noteHeadingDelimiter start="##\@!"      end="#*\s*$" keepend oneline contains=@noteInline contained
syn region noteH2 matchgroup=noteHeadingDelimiter start="###\@!"     end="#*\s*$" keepend oneline contains=@noteInline contained
syn region noteH3 matchgroup=noteHeadingDelimiter start="####\@!"    end="#*\s*$" keepend oneline contains=@noteInline contained
syn region noteH4 matchgroup=noteHeadingDelimiter start="#####\@!"   end="#*\s*$" keepend oneline contains=@noteInline contained
syn region noteH5 matchgroup=noteHeadingDelimiter start="######\@!"  end="#*\s*$" keepend oneline contains=@noteInline contained
syn region noteH6 matchgroup=noteHeadingDelimiter start="#######\@!" end="#*\s*$" keepend oneline contains=@noteInline contained

syn match noteBlockquote ">\s" contained nextgroup=@noteBlock

"syn region noteCodeBlock start="      \|\t" end="$" contained

" TODO: real nesting
syn match noteListMarker " \{0,6\}[-*+]\%(\s\+\S\)\@=" contained
syn match noteOrderedListMarker " \{0,6}\<\d\+\.\%(\s*\S\)\@=" contained

syn match noteRule "\* *\* *\*[ *]*$" contained
syn match noteRule "- *- *-[ -]*$" contained

syn match noteLineBreak "\s\{2,\}$"

syn region noteIdDeclaration matchgroup=noteLinkDelimiter start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=noteUrl skipwhite
syn match noteUrl "\S\+" nextgroup=noteUrlTitle skipwhite contained conceal
syn region noteUrl matchgroup=noteUrlDelimiter start="<" end=">" oneline keepend nextgroup=noteUrlTitle skipwhite contained conceal
syn region noteUrlTitle matchgroup=noteUrlTitleDelimiter start=+"+ end=+"+ keepend contained
syn region noteUrlTitle matchgroup=noteUrlTitleDelimiter start=+'+ end=+'+ keepend contained
syn region noteUrlTitle matchgroup=noteUrlTitleDelimiter start=+(+ end=+)+ keepend contained

syn region noteLinkText matchgroup=noteLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" keepend nextgroup=noteLink,noteId skipwhite contains=@noteInline,noteLineStart
syn region noteLink matchgroup=noteLinkDelimiter start="(" end=")" contains=noteUrl keepend contained conceal
syn region noteId matchgroup=noteIdDelimiter start="\[" end="\]" keepend contained
syn region noteAutomaticLink matchgroup=noteUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline

"syn region noteItalic start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" keepend contains=noteLineStart
"syn region noteItalic start="\S\@<=_\|_\S\@=" end="\S\@<=_\|_\S\@=" keepend contains=noteLineStart
syn region noteBold start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contains=noteLineStart
syn region noteBold start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend contains=noteLineStart
"syn region noteBoldItalic start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contains=noteLineStart
"syn region noteBoldItalic start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contains=noteLineStart
"
"
"
syn match noteIgnore		"." contained conceal
syn region noteCodeBlock	matchgroup=noteIgnore start=" >$" start="^>$" end="^[^ \t]"me=e-1 end="^<" concealends
"syn region noteCode matchgroup=noteIgnore start="`" end="`" concealends
syn region noteCode start="`" end="`" concealends

syn match noteEscape "\\[][\\`*_{}()#+.!-]"

hi def link noteH1                    htmlH1
hi def link noteH2                    htmlH2
hi def link noteH3                    htmlH3
hi def link noteH4                    htmlH4
hi def link noteH5                    htmlH5
hi def link noteH6                    htmlH6
hi def link noteHeadingRule           noteRule
hi def link noteHeadingDelimiter      Delimiter
hi def link noteOrderedListMarker     noteListMarker
hi def link noteListMarker            htmlTagName
hi def link noteBlockquote            Comment
hi def link noteRule                  PreProc

hi def      noteLinkText              guifg=blue gui=underline
hi def link noteIdDeclaration         Typedef
hi def link noteId                    Type
hi def link noteAutomaticLink         noteUrl
hi def link noteUrl                   Float
hi def link noteUrlTitle              String
hi def link noteIdDelimiter           noteLinkDelimiter
hi def link noteUrlDelimiter          htmlTag
hi def link noteUrlTitleDelimiter     Delimiter

hi def link noteItalic                htmlItalic
hi def link noteBold                  htmlBold
hi def link noteBoldItalic            htmlBoldItalic
hi def link noteCodeDelimiter         Delimiter

hi def link noteEscape                Special

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                    original                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""


syntax match note_star "★"
syntax match note_strong "\*\*.\{-1,}\*\*" contains=note_strong_mark
syntax match note_strong_mark /\*\*/ contained conceal
"syntax match note_highlight "\~\~.\{-1,}\~\~" contains=note_highlight_mark
"syntax match note_highlight_mark /\~\~/ contained conceal
syntax match note_highlight "##[^\#]\+##" contains=note_highlight_mark
syntax match note_highlight_mark /\#/ contained conceal



hi def noteH1                guifg=brown
hi def noteH2                guifg=brown
hi def noteH3                guifg=brown
hi def noteRule              guifg=brown
hi def noteListMarker        guifg=blue
hi def noteHeadingDelimiter  guifg=brown
hi def noteCodeBlock         guifg=#2c694a
hi def noteCode              guifg=#2c694a
hi def noteLinkTextDelimiter guifg=bg
hi def note_strong           guifg=red
hi def note_star             guifg=#ff9be8
hi def note_highlight        guibg=#d3d47a


let b:current_syntax = 'note'
