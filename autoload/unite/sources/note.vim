
function! unite#sources#note#define()
  return s:unite_source
endfunction
"
let s:unite_source = {
      \ 'name'           : 'note' ,
      \ 'description'    : 'candidates from note' ,
      \ }
" create list
function! s:unite_source.gather_candidates(args, context)
  let ret = []
  for val in s:find_pages()
    let candidate = {
        \ "abbr"         : val.name . ' [' . join(note#tags(val.path), ',') . ']' ,
        \ "word"         : val.name ,
        \ "source"       : "note",
        \ "kind"         : "file" ,
        \ "action__path" : val.path ,
        \ }
    call add(ret, candidate)
  endfor
  return ret
endfunction
" new page
function! s:unite_source.change_candidates(args, context)
  let page = substitute(a:context.input, '\*', '', 'g')
  let path = expand(g:unite_uiki_path . '/' . page . '.mn' , ':p')
  if page != '' && !filereadable(path)
    return [{
          \ 'abbr'         : '[new page] ' . page ,
          \ 'word'         : page   ,
          \ "source"       : "note" ,
          \ "kind"         : "file" ,
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
  return reverse(map(note#list(), '{
          \ "name" : fnamemodify(v:val , ":t:r") ,
          \ "path" : v:val
          \ }'))
endfunction


function! s:padding(msg, len)
  let msg = a:msg
  while strwidth(msg) < a:len
    let msg .= ' '
  endwhile
  return msg
endfunction
