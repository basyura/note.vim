
let g:note_unite_title_width = 100


" ftdetect ?
au BufRead,BufNewFile *.mn :call s:note_settings()

function s:note_settings()
  set filetype=note
  " autocmd BufReadPost *.mn call s:open_outline()
  nnoremap <silent> <buffer> <C-a> :call unite#sources#note_action#start()<CR>
  nnoremap <silent> <buffer> <Enter> :call <SID>open_browser()<CR>
endfunction

function! s:open_browser()
  " todo
  let word = getline('.')
  let matched = matchlist(word, 'https\?://[0-9A-Za-z_#?~=\-+%\.\/:]\+')
  if len(matched) != 0
    execute "OpenBrowser " . matched[0]
    return
  endif
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
