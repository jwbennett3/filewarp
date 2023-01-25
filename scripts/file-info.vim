


let s:_FILE_INFO_PATH="/cache/file_info.json"
let s:_PINNED_INDEX = "pinned_index"
let s:_TRANSIENT_INDEX = "transient_index"

function! s:_getFileInfo()
   return Load(s:_FILE_INFO_PATH)
endfunction

function! GetFileInfo()
   echo s:_FILE_INFO_PATH
   return Load(s:_FILE_INFO_PATH)
endfunction

function! s:_setFileInfo(file_info)
  :call Save(a:file_info,s:_FILE_INFO_PATH)
endfunction

function! UnsetTransientAt(file_path,index)
    let file_info = s:_getFileInfo()
    if !has_key(file_info,a:file_path)
      :return 0
    endif
    if !has_key(file_info[a:file_path],s:_TRANSIENT_INDEX)
      :return 0
    endif
  :unlet file_info[a:file_path][s:_TRANSIENT_INDEX]
  :call s:_setFileInfo(file_info)
endfunction

function! IsTransientAt(file_path,index)
    let file_path = CleanFilePath(a:file_path)
    let file_info = s:_getFileInfo()
    if !has_key(file_info,file_path)
        return 0
    endif
    let file_info = file_info[file_path]
    if !has_key(file_info,s:_TRANSIENT_INDEX)
        return 0
    endif
    return file_info[s:_TRANSIENT_INDEX] == a:index
endfunction

function! GetPinnedIndex(file_path)
    let file_path = CleanFilePath(a:file_path)
    let file_info = s:_getFileInfo()
    if !has_key(file_info,file_path)
        return -1
    endif
    let file_info = file_info[file_path]
    if !has_key(file_info,s:_PINNED_INDEX)
        return -1
    endif
    return file_info[s:_PINNED_INDEX]
endfunction

"TODO use GetPinnedIndex instead
function! IsPinnedAt(file_path,index)
    let file_path = CleanFilePath(a:file_path)
    let file_info = s:_getFileInfo()
    if !has_key(file_info,file_path)
        return 0
    endif
    let file_info = file_info[file_path]
    if !has_key(file_info,s:_PINNED_INDEX)
        return 0
    endif
    return file_info[s:_PINNED_INDEX] == a:index
endfunction

function! SetPinned(index)
  :let file_path = GetFilePath()
  :let file_path = CleanFilePath(file_path)
  :let file_info = s:_getFileInfo()
  if !has_key(file_info, file_path)
    :let file_info[file_path] = {}
  endif
  :let file_info[file_path][s:_PINNED_INDEX] = a:index
  :call s:_setFileInfo(file_info)
  :call ColorBackground()
endfunction





