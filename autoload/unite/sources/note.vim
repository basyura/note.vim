
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
        \ "abbr"         : val.name ,
        \ "word"         : val.name ,
        \ "source"       : "uiki",
        \ "kind"         : "file" ,
        \ "action__path" : val.path ,
        \ }
    let keys = split(val.name, '_')
    if len(keys) == 3
     let candidate.abbr = s:padding("[" . keys[1] . "]", 5) . " " . s:padding(keys[2], 32)
     if keys[0] != "00000000"
       let candidate.abbr .= " " . strpart(keys[0], 4, 2) . '/' . strpart(keys[0], 6, 2)
     endif
    endif
    call add(ret, candidate)
  endfor
  return ret
endfunction
" new page
function! s:unite_source.change_candidates(args, context)
  let page = substitute(a:context.input, '\*', '', 'g')
  let path = expand(g:unite_uiki_path . '/' . page . '.uiki' , ':p')
  if page != '' && !filereadable(path)
    return [{
          \ 'abbr'         : '[new page] ' . page ,
          \ 'word'         : page   ,
          \ "source"       : "uiki" ,
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
  return reverse(map(split(globpath(g:unite_uiki_path , '*.uiki') , '\n') , '{
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
