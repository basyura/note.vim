function! unite#sources#note_action#define()
  return s:unite_source
endfunction
"
let s:unite_source = {
      \ 'name'           : 'note/action' ,
      \ 'description'    : 'candidates for note action' ,
      \ 'action_table'   : {},
      \ 'default_action' : {'common' : 'execute'},
      \ 'is_listed'      : 0,
      \ }

function! unite#sources#note_action#start()
  if !exists(':Unite')
    echoerr 'unite.vim is not installed.'
    echoerr 'Please install unite.vim'
    return ''
  endif
  return unite#start(['note/action'], {
        \ 'winheight'         : '5', 
        \ 'hide-source-names' : '1'
        \ })
endfunction

function! s:unite_source.gather_candidates(args, context)
  let ret = []
  for val in ['delete']
    let candidate = {
        \ "word"          : val,
        \ "action__path"  : expand("%:p") ,
        \ }
    call add(ret, candidate)
  endfor
  return ret
endfunction

let s:unite_source.action_table.execute = {'description' : 'note actions'}
function! s:unite_source.action_table.execute.func(candidate)
  if a:candidate.word == 'delete'
    call s:delete_action(a:candidate)
  endif
endfunction

function! s:delete_action(candidate)
  echohl ErrorMsg | let ret = input('delete "' . fnamemodify(a:candidate.action__path, ':t:r') . '" ? (y/n) : ')  | echohl None
  if ret != 'y'
    redraw
    echo 'canceled'
    return
  endif
  redraw
  call delete(a:candidate.action__path)
  echo 'deleted'
  bd!
endfunction
