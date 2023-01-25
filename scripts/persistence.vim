

function Write(path,contents)
  :sil exe '!mkdir -p $(dirname '.a:path.')'
  :call writefile([a:contents],a:path)
endfunction
function Read(path)
  if filereadable(a:path)
    :let array = readfile(a:path)
    :let i = 0
    :let ret = ""
    while i<len(array)
      :let ret = ret . array[i]
      :let i+=1
    endwhile
    :return ret
  else
    :return ""
  endif
endfunction


function Load(path)
  :let file_str = Read(a:path)
  try
    :let obj = json_decode(file_str)
  catch
    :return {}
  endt
  if type(obj) !=# type({})
    :return {}
  endif
  :return obj
endfunction

function Save(obj,path)
  :let stringified = json_encode(a:obj)
  :call Write(a:path, stringified)

  ":let pretty = system('python -m json.tool', stringified)
  ":call Write(a:path, pretty)

  ":silent exe '!python -m json.tool '.a:path.' > /tmp/$(basename '.a:path.')'
  ":silent exe '!mv /tmp/$(basename '.a:path.') '.a:path
endfunction


function PersistentObjectFomDict(dict_obj)
endfunction

function PersistentObject(storage_path)
  :let obj = {}
  :let obj._storage_path = a:storage_path
  :let obj.toDict = {->s:toDict(obj)}
  :let obj.save = {->s:save(obj)}
  :return obj
endfunction

