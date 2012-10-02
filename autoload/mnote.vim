
function! mnote#data_path()
  return expand(g:mnote_data_path)
endfunction

function! mnote#list()
  let list = split(glob(mnote#data_path() . "/*.mn"), "\n")
  return list
endfunction
