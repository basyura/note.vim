"
"
"
function! unite#sources#note_action#define()
  return s:unite_source
endfunction
"
"
"
let s:unite_source = {
      \ 'name'           : 'note/action' ,
      \ 'description'    : 'candidates for note action' ,
      \ 'action_table'   : {},
      \ 'default_action' : {'common' : 'execute'},
      \ 'is_listed'      : 0,
      \ }
"
"
"
function! unite#sources#note_action#start()
  if !exists(':Unite')
    echoerr 'unite.vim is not installed.'
    echoerr 'Please install unite.vim'
    return ''
  endif
  return unite#start(['note/action'], {
        \ 'winheight'         : '7', 
        \ 'hide-source-names' : '1'
        \ })
endfunction
"
"
"
function! s:unite_source.gather_candidates(args, context)
  let ret = []
  for val in ['archive', 'restore', 'rename', 'delete']
    if val == 'archive' && expand("%:p:h:t") == 'archive'
      continue
    elseif val == 'restore' && expand("%:p:h:t") != 'archive'
      continue
    endif
    let candidate = {
        \ "word"          : val,
        \ "action__path"  : expand("%:p") ,
        \ }
    call add(ret, candidate)
  endfor
  return ret
endfunction
"
"
"
let s:unite_source.action_table.execute = {'description' : 'note actions'}
function! s:unite_source.action_table.execute.func(candidate)
  let word = a:candidate.word
  call call('s:' . word . '_action', [a:candidate])
endfunction
"
"
"
function! s:archive_action(candidate)
  let path = expand("%:p:h") . "/archive/" . expand("%")
  call writefile(readfile(expand("%")), path)
  call delete(a:candidate.action__path)
  bd
  echohl ErrorMsg | echo 'archived ... ' . fnamemodify(path, ':t:r')  | echohl None
endfunction
"
"
"
function! s:restore_action(candidate)
  let path = expand("%:p:h") . "/../" . expand("%")
  if filereadable(path)
    echohl ErrorMsg | echo path . ' is already exists.'  | echohl None
    return
  endif
  call writefile(readfile(expand("%")), path)
  call delete(a:candidate.action__path)
  bd
  edit `=path`
  redraw
  echohl ErrorMsg | echo 'restored ... ' . fnamemodify(path, ':t:r')  | echohl None
endfunction
"
"
"
function! s:rename_action(candidate)
  echohl ErrorMsg | let fname = input('rename to : ', expand("%:t:r"))  | echohl None
  let fname .= '.mn'
  if filereadable(fname)
    echohl ErrorMsg | echo fname . ' is already exists.'  | echohl None
    return
  endif
  call rename(expand("%"), fname)
  bd
  execute 'open ' . fname
  redraw
  echohl ErrorMsg | echo 'saved as ... ' . fname  | echohl None
endfunction
"
"
"
function! s:delete_action(candidate)
  let path = a:candidate.action__path
  echohl ErrorMsg | let ret = input('delete ... "' . fnamemodify(path, ':t:r') . '" ? (y/n) : ')  | echohl None
  if ret != 'y'
    redraw
    echo 'canceled'
    return
  endif
  call delete(path)
  bd
  echohl ErrorMsg | echo 'deleted ... ' . fnamemodify(path, ':t:r')  | echohl None
endfunction
