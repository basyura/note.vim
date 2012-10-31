
" ftdetect ?
au BufRead,BufNewFile *.mn set filetype=note


augroup note
  autocmd!
  autocmd BufReadPost *.mn call s:open_outline()
augroup END

function! s:open_outline()
  return
  if exists('b:note_outline')
    return
  endif
  let b:note_outline = 1
  :Unite outline -vertical -no-quit -winwidth=30 -no-start-insert
  execute 'wincmd p'
endfunction

