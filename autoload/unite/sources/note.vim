
function! unite#sources#note#define()
  return s:unite_source
endfunction
"
let s:unite_source = {
      \ 'name'           : 'note' ,
      \ 'description'    : 'candidates from note' ,
      \ 'action_table'   : {},
      \ 'default_action' : {'common' : 'execute'},
      \ }
" create list
function! s:unite_source.gather_candidates(args, context)
  let ret = []
  for val in s:find_pages()
    let word = s:padding(val.name, 50) . ' ' . s:padding(val.date, 12) . join(val.tags, ', ')
    let candidate = {
        \ "word"          : word ,
        \ "source"        : "note",
        \ "kind"          : "file" ,
        \ "action__path"  : val.path ,
        \ "source__ftime" : getftime(val.path)
        \ }
    call add(ret, candidate)
  endfor

  call sort(ret, "unite#sources#note#ftime_sort")

  return ret
endfunction
" new page
function! s:unite_source.change_candidates(args, context)
  let page = substitute(a:context.input, '\*', '', 'g')
  let path = expand(note#data_path() . '/' . page . '.mn' , ':p')
  if page != '' && !filereadable(path)
    return [{
          \ 'abbr'         : '[new page] ' . page ,
          \ 'word'         : page   ,
          \ "source"       : "note" ,
          \ "action__path" : path   ,
          \ }]
  else
    return []
  endif
endfunction
"
" find pages
"
function! s:find_pages()
  let list = map(note#list(), '{
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

function! unite#sources#note#ftime_sort(i1, i2)
  return  a:i1.source__ftime == a:i2.source__ftime ? 0 
           \ : a:i1.source__ftime > a:i2.source__ftime ? -1 : 1
endfunction

let s:unite_source.action_table.execute = {'description' : 'create new note'}
function! s:unite_source.action_table.execute.func(candidate)
  silent edit  `=a:candidate.action__path`
  call append(0, [
        \'# ' . a:candidate.word,
        \'date : ' . strftime('%Y-%m-%d'),
        \'tags : ',
        \ ])
  silent delete _
  startinsert!
endfunction
