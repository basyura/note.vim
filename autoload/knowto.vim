
function! knowto#data_path()
  return expand(g:knowto_data_path)
endfunction

function! knowto#file_list()
  let list = split(glob(knowto#data_path() . "/*.mn"), "\n")
  return list
endfunction

function! knowto#all_tags()
  let tags = {}
  for file in knowto#file_list()
    for t in knowto#tags(file)
      let tags[t] = 1
    endfor
  endfor
  return sort(keys(tags))
endfunction


function! knowto#recache()
  let cache = {}
  for file in knowto#file_list()
    for tag in knowto#tags(file)
      let list = get(cache, tag, [])
      call add(list, file)
      let cache[tag] = list
    endfor
  endfor
  return cache
endfunction

function! knowto#tags(file_path)
  let list = []
  let header = readfile(a:file_path, '', 2)
  if len(header) < 2 | return list | endif
  if header[1] !~ '^tags :' | return list | endif
  let line = substitute(header[1], '^tags :', '', '')
  for t in split(line, ',')
    let tag = substitute(substitute(t, '^\s\+', '', ''), '\s\+$', '', '')
    call add(list, tag)
  endfor
  return list
endfunction
