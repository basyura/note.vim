
function! mynote#data_path()
  return expand(g:mynote_data_path)
endfunction

function! mynote#list()
  let list = split(glob(mynote#data_path() . "/*.mn"), "\n")
  return list
endfunction
