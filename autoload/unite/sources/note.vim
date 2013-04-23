let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'action_table': {},
\ }
" create list
function! s:source.gather_candidates(args, context)
  let source = a:context.source.name
  let ret = []
  for val in s:find_pages(source)
    let word = s:padding(val.name, g:note_unite_title_width) . ' ' . s:padding(val.date, 12) . join(val.tags, ', ')
    let candidate = {
        \ "word"              : word ,
        \ "source"            : "note",
        \ "kind"              : "file" ,
        \ "action__path"      : val.path ,
        \ "action__directory" : fnamemodify(val.path, ":h") . '/.' ,
        \ "source__ftime"     : getftime(val.path)
        \ }
    call add(ret, candidate)
  endfor

  call sort(ret, "unite#sources#note#ftime_sort")

  return ret
endfunction
" new page
function! s:source.change_candidates(args, context)
  let page = substitute(a:context.input, '\*', '', 'g')
  let path = expand(note#data_path() . '/' . page . '.mn' , ':p')
  if a:context.source.name == 'note/archive'
    return []
  endif
  if page != '' && !filereadable(path)
    return [{
          \ 'abbr'              : '[new page] ' . page ,
          \ 'word'              : page   ,
          \ "source"            : "note" ,
          \ "action__path"      : path   ,
          \ "action__directory" : fnamemodify(path, ":h") . '/.',
          \ }]
  else
    return []
  endif
endfunction

let s:source.action_table.execute = {'description' : 'create new note'}
function! s:source.action_table.execute.func(candidate)
  silent edit  `=a:candidate.action__path`
  call append(0, [
        \'# ' . a:candidate.word,
        \'date : ' . strftime('%Y-%m-%d'),
        \'tags : ',
        \ ])
  silent delete _
  startinsert!
endfunction


let s:source.action_table.delete = {'description' : 'delete note'}
function! s:source.action_table.delete.func(candidate)
  if input('delete "' . fnamemodify(a:candidate.action__path, ':t:r') . '" ? (y/n) : ') != 'y'
    return
  endif
  call delete(a:candidate.action__path)
  redraw
  echo 'deleted'
endfunction


function! unite#sources#note#define()
  let sources = []
  for name in ['note', 'note/archive']
    let source = {
              \ 'name'           : name ,
              \ 'description'    : 'candidates from ' . name,
              \ 'default_action' : {'common' : 'execute'},
              \ }
    call add(sources, extend(source, copy(s:source)))
  endfor
  return sources
endfunction


function! unite#sources#note#ftime_sort(i1, i2)
  return  a:i1.source__ftime == a:i2.source__ftime ? 0 
           \ : a:i1.source__ftime > a:i2.source__ftime ? -1 : 1
endfunction

"
" find pages
"
function! s:find_pages(source)
  let list = map(note#list(a:source), '{
          \ "name" : fnamemodify(v:val , ":t:r") ,
          \ "path" : v:val
          \ }')
  for page in list
    call extend(page, note#attributes(page.path))
  endfor
  return list
endfunction


function! s:padding(msg, len)
  let msg = a:msg
  while strdisplaywidth(msg) < a:len
    let msg .= ' '
  endwhile
  return msg
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
