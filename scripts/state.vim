
let s:_STATE_PATH="/cache/state.json"

let s:_SELECTED_EDITOR_INDEX_R = "selected_editor_index_r"
let s:_SELECTED_EDITOR_TYPE_R = "selected_editor_type_r"
let s:_SELECTED_EDITOR_TYPES_R = "selected_editor_types_r"

let s:_BUFFER_COUNTS = "buffer_counts"

let s:_OPENED_EDITORS = "opened_editors"


function! s:_getState()
   :let state = Load(s:_STATE_PATH)
   if !has_key(state,s:_OPENED_EDITORS)
     :let state[s:_OPENED_EDITORS] = {}
   endif
   :return state
endfunction

function! GetState()
   :let state = Load(s:_STATE_PATH)
   if !has_key(state,s:_OPENED_EDITORS)
     :let state[s:_OPENED_EDITORS] = {}
   endif
   :return state
endfunction

function! s:_setState(state)
    call Save(a:state,s:_STATE_PATH)
endfunction

function! GetMaxOpenedEditors()
  if GetMachineName() == "shenobi"
    return 4
  endif
  if $context == "work"
    return 6
  endif
  return 9
endfunction

function! GetSessionFiles(editor_index)
  let state = s:_getState()
  if !has_key(state,s:_OPENED_EDITORS)
     let state[s:_OPENED_EDITORS] = {}
  endif
  if !has_key(state[s:_OPENED_EDITORS],a:editor_index)
     let state[s:_OPENED_EDITORS][a:editor_index] = []
  endif
  return s:_getState()[s:_OPENED_EDITORS][a:editor_index]
endfunction

function GetFirstFile(editor_index)
  :let files= GetSessionFiles(a:editor_index)
  :return len(files) > 0? files[len(files)-1] : ""
endfunction

function! SetSelectedEditorIndex(index)
  :let state = s:_getState()
  :let state[s:_SELECTED_EDITOR_INDEX_R] = str2nr(a:index)
  :call s:_setState(state)
endfunction

function! RemoveFromEditor(editor_index,path)
  :let path = CleanFilePath(a:path)
  :let state = s:_getState()
  if !has_key(state,s:_OPENED_EDITORS)
    :return
  endif
  if !has_key(state[s:_OPENED_EDITORS],a:editor_index)
    :return
  endif
  :let files = state[s:_OPENED_EDITORS][a:editor_index]
  :let i=0
  :let found=0
  for f in files
    if f == path
      :let found=1
      :break
    endif
    :let i+=1
    endfor
  if found
   :unlet state[s:_OPENED_EDITORS][a:editor_index][i]
  endif
  :call s:_setState(state)
endfunction

function! MoveToFront(editor_index,path)
  :let path = CleanFilePath(a:path)
  :call RemoveFromEditor(a:editor_index, path)
  :let state = s:_getState()
  if !has_key(state,s:_OPENED_EDITORS)
     let state[s:_OPENED_EDITORS] = {}
  endif
  if !has_key(state[s:_OPENED_EDITORS],a:editor_index)
     let state[s:_OPENED_EDITORS][a:editor_index] = []
  endif
  :call add(state[s:_OPENED_EDITORS][a:editor_index], path)
  while len(state[s:_OPENED_EDITORS][a:editor_index]) > GetMaxOpenedEditors()
    :unlet state[s:_OPENED_EDITORS][a:editor_index][0]
  endwhile
  :call s:_setState(state)
endfunction

function SelectedEditorTypeIsJetbrains()
    let state = s:_getState()
    return state[s:_SELECTED_EDITOR_TYPE_R] == "jetbrains"
endfunction

function GetBufferCount(index)
  :let state = s:_getState()
  if !has_key(state,s:_BUFFER_COUNTS) || !has_key(state[s:_BUFFER_COUNTS],a:index)
    :return 0
  else
    :return state[s:_BUFFER_COUNTS][a:index]
  endif
endfunction

function SetBufferCount(count)
  :let state = s:_getState()
  if !has_key(state,s:_BUFFER_COUNTS)
     let state[s:_BUFFER_COUNTS] = {}
  endif
  :let state[s:_BUFFER_COUNTS][$INDEX] = a:count
  :call s:_setState(state)
endfunction

