
function! mnote#data_path()
  return expand(g:mnote_data_path)
endfunction

function! mnote#list()
  let list = split(glob(mnote#data_path() . "/*.mn"), "\n")
  return list
endfunction

function! mnote#tags()
  let tags = {}
  let list = split(glob(mnote#data_path() . "/*.mn"), "\n")
  for file in list
    let header = readfile(file, '', 2)
    if len(header) < 2 | next | endif
    if header[1] !~ '^tags :' | next | endif
    let line = substitute(header[1], '^tags :', '', '')
    for t in split(line, ',')
      let tags[substitute(substitute(t, '^\s\+', '', ''), '\s\+$', '', '')] = 1
    endfor
  endfor
  return sort(keys(tags))
endfunction
