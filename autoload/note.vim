
function! note#data_path()
  return expand(g:note_data_path)
endfunction

function! note#list()
  let list = split(glob(note#data_path() . "/*.mn"), "\n")
  return list
endfunction

function! note#all_tags()
  let tags = {}
  for file in note#list()
    for t in note#tags(file)
      let tags[t] = 1
    endfor
  endfor
  return sort(keys(tags))
endfunction


function! note#tags(file_path)
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


function! note#recache()
  let cache = {}
  for file in note#list()
    for tag in note#tags(file)
      let list = get(cache, tag, [])
      call add(list, file)
      let cache[tag] = list
    endfor
  endfor
  return cache
endfunction
