"=============================================================================
"
" outline for textile
"
" Licensed under the MIT license:
" http://www.opensource.org/licenses/mit-license.php
"
"=============================================================================

function! unite#sources#outline#note#outline_info()
  return s:outline_info
endfunction

"-----------------------------------------------------------------------------
" Outline Info

"let s:outline_info = {
      "\ 'heading'  : '^h\d',
      "\ }

"function! s:outline_info.create_heading(which, heading_line, matched_line, context)
  "return {
        "\ 'word'  : substitute(a:heading_line, 'h\d\{0,}\.\s\+', '', '') ,
        "\ 'level' : matchstr(a:heading_line, '^h\zs\d\{0,}\ze') ,
        "\ }
"endfunction
"
" markdown
"
let s:outline_info = {
      \ 'heading'  : '^#\+\|^\s\=★.\=',
      \ 'heading+1': '^[-=]\+$',
      \ }

function! s:outline_info.create_heading(which, heading_line, matched_line, context)
  let heading = {
        \ 'word' : a:heading_line,
        \ 'level': 0,
        \ 'type' : 'generic',
        \ }

  if a:which ==# 'heading'
    if a:heading_line =~ '^\s\=★.\='
      let heading.level = 4
    else
      let heading.level = strlen(matchstr(a:heading_line, '^#\+'))
      let heading.word = substitute(heading.word, '^#\+\s*', '', '')
      let heading.word = substitute(heading.word, '\s*#\+\s*$', '', '')
    endif
  elseif a:which ==# 'heading+1'
    if a:matched_line =~ '^='
      let heading.level = 1
    else
      let heading.level = 2
    endif
  endif

  if heading.level > 0
    let heading.word = substitute(heading.word, '\s*<a[^>]*>\s*\%(</a>\s*\)\=$', '', '')
    return heading
  else
    return {}
  endif
endfunction

" vim: filetype=vim
