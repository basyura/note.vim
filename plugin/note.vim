
" ftdetect ?
au BufRead,BufNewFile *.mn :call s:note_settings()

function s:note_settings()
  set filetype=note
  " autocmd BufReadPost *.mn call s:open_outline()
  nnoremap <silent> <buffer> <C-a> :call unite#sources#note_action#start()<CR>
endfunction

function! s:open_outline()
  if &columns < 150
    return
  endif
  if exists('b:note_outline')
    return
  endif
  let b:note_outline = 1
  let cmd = ':Unite outline -vertical -no-quit -winwidth=30 -winheight=' . winheight(0)  . ' -no-start-insert -direction=rightbelow -hide-source-names'
  execute cmd
  execute 'wincmd p'
  "unlet b:note_outline
endfunction
