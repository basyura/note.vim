
" ftdetect ?
au BufRead,BufNewFile *.mn set filetype=note


augroup note
  autocmd!
  autocmd BufReadPost *.mn call s:open_outline()
augroup END

function! s:open_outline()
  if &columns < 150
    return
  endif
  if exists('b:note_outline')
    return
  endif
  let b:note_outline = 1
  let cmd = ':Unite outline -vertical -no-quit -winwidth=50 -winheight=' . winheight(0)  . ' -no-start-insert'
  execute cmd
  execute 'wincmd p'
  "unlet b:note_outline
endfunction
