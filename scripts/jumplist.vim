

let s:_JUMPLIST_PATH='/data/cache/jumplist.json'
let s:_JUMPS='jumps'
let s:_LOCAL_JUMPS='local_jumps'
let s:_PATH='path'
let s:_LINE='line'
let s:_COL='col'
let s:_CURR_INDEX='curr_index'
let s:_LOCAL_INDEX='local_index'

let s:_MAX_JUMPS=20
"let s:_MAX_JUMPS=5

function s:_getJumplist()
 let jumplist = Load(s:_JUMPLIST_PATH)
  if type(jumplist) != type({}) || !has_key(jumplist,s:_JUMPS) || !has_key(jumplist,s:_LOCAL_JUMPS) || !has_key(jumplist,s:_CURR_INDEX) || !has_key(jumplist,s:_LOCAL_INDEX)
    :let ret = {}
    :let ret[s:_JUMPS] = []
    :let ret[s:_CURR_INDEX] = -1
    :let ret[s:_LOCAL_JUMPS] = []
    :let ret[s:_LOCAL_INDEX] = -1
    :return ret
  endif
  :return jumplist
endfunction

function s:_setJumplist(jumplist)
  let jumplist=a:jumplist
  if type(jumplist) != type({})
    :call ShowStatusMessage('something fucking up jumps')
    :return
  endif
  if !has_key(jumplist,s:_JUMPS) || !has_key(jumplist,s:_LOCAL_JUMPS) || !has_key(jumplist,s:_CURR_INDEX) || !has_key(jumplist,s:_LOCAL_INDEX)
    :return
  endif
   call Save(a:jumplist,s:_JUMPLIST_PATH)
endfunction

function s:_getCurrIndex()
  :let jumplist = s:_getJumplist()
  if has_key(jumplist,s:_CURR_INDEX)
    :return jumplist[s:_CURR_INDEX]
  endif
  :return 0
endfunction

function s:_setCurrIndex(index)
  :let jumplist = s:_getJumplist()
  try
    :let jumplist[s:_CURR_INDEX] = a:index
    :call s:_setJumplist(jumplist)
  catch
  endt
endfunction

function s:_getJumpInfo(index)
  :let jumplist = s:_getJumplist()
  :return jumplist[s:_JUMPS][a:index]
endfunction

function ClearLocalJumps()
  :let jumplist = s:_getJumplist()
  if len(jumplist[s:_LOCAL_JUMPS]) > 0
    :let jump_path = GetFilePath()
    :let jump_x = jumplist[s:_LOCAL_JUMPS][0][s:_COL]
    :let jump_y = jumplist[s:_LOCAL_JUMPS][0][s:_LINE]
    :let results =  s:_addJump(s:_JUMPS, s:_CURR_INDEX, jump_path, jump_y, jump_x)
    ":call s:_setJumplist(results[0])
    ":call AddJump(jump_path,jump_y,jump_x)
    :let found = results[0]
    :let new_idx = results[1]
    :let jumplist = results[2]
    if !found
      :call insert(jumplist[s:_JUMPS], {"path":jump_path,"line":jump_y,"col":jump_x},new_idx)
      :let jumplist[s:_CURR_INDEX] +=1
    endif
  endif
  "if len(jumplist[s:_LOCAL_JUMPS]) >0
    ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
  "endif
  try
    :let jumplist[s:_LOCAL_JUMPS] = []
    :call s:_setJumplist(jumplist)
  catch
  endt
endfunction

function s:_addJump(list_key,index_key,file_path,line,col)
  :let jumplist = s:_getJumplist()

  if !has_key(jumplist,a:list_key)
    :let jumplist[a:list_key] = []
  endif

  if !has_key(jumplist,a:index_key)
    :let jumplist[a:index_key] = 0
  endif

  :let idx = 0
  :let found = 0
  while idx < len(jumplist[a:list_key])
    let jump_info = jumplist[a:list_key][idx]
    if jump_info[s:_PATH] == a:file_path &&
    \  jump_info[s:_LINE]==a:line &&
    \  jump_info[s:_COL]==a:col
      :let found = 1
      :let new_idx = jumplist[a:index_key]
      if idx == jumplist[a:index_key]
      else
        :call remove(jumplist[a:list_key],idx)
        :call insert(
                   \ jumplist[a:list_key]
                   \, { "path":a:file_path
                   \  , "line":a:line
                   \  , "col":a:col
                   \  }
                   \, jumplist[a:index_key]
                   \)
        "if idx < jumplist[a:index_key]
          ":let idx = jumplist[a:index_key]-1
        "endif
      endif
      :break
    endif
    :let idx+=1
  endwhile
  "if found
    ":let new_idx = idx
  "else
    :let new_idx = jumplist[a:index_key]
  "endif
  "if new_idx >= len(jumplist[a:list_key])
    "let new_idx=len(jumplist[a:list_key]) -1
  "endif
  "if new_idx < 0
    ":let new_idx = 0
  "endif
  :return [found,new_idx,jumplist]
endfunction

function AddJump(file_path,line,col)
  "try
  if  a:file_path ==# '/cache/jumplist.json'
  \|| a:file_path ==# '/data/cloud/cache/jumplist.json'
  \|| a:file_path ==#'/config/scripts/ide/dummies/vd0'
  \|| StringStartsWith(a:file_path,'term:')
      :return
  endif
  :
  "::silent exe '!echo "file_path: '.string(a:file_path).'" >> /tmp/deb'
  :let results = s:_addJump(s:_JUMPS, s:_CURR_INDEX, a:file_path, a:line, a:col)

  "::silent exe '!echo "file_path: '.string(a:file_path).'" >> /tmp/deb'
  "::silent exe '!echo "line: '.string(a:line).'" >> /tmp/deb'
  "::silent exe '!echo "col: '.string(a:col).'" >> /tmp/deb'
  :let found = results[0]
  :let new_idx = results[1]
  :let jumplist = results[2]
  "::silent exe '!echo "found: '.string(found).'" >> /tmp/deb'
  :let curr_index = jumplist[s:_CURR_INDEX]
  if curr_index >= len(jumplist[s:_JUMPS])
    :let curr_index = len(jumplist[s:_JUMPS]) -1
  endif

  if curr_index < 0
    :let curr_index = 0
  endif

  ":let curr_jump = 0
  "try
    ":let curr_jump = jumplist[s:_JUMPS][curr_index]
  "catch
  "endt

  "if type(curr_jump) ==# type({}) && !found &&  abs(a:line - curr_jump[s:_LINE]) < ScreenHeight()
    ":let local_results = s:_addJump(s:_LOCAL_JUMPS, s:_LOCAL_INDEX, a:file_path, a:line, a:col)
    ":let found = local_results[0]
    ":let local_index = local_results[1]
    ":let jumplist = local_results[2]
    "if !found
      ":call insert(jumplist[s:_LOCAL_JUMPS], {"path":a:file_path,"line":a:line,"col":a:col},local_index)
    "endif
    ":let jumplist[s:_LOCAL_INDEX] = local_index
  "else
    if !found
      if curr_index == len(jumplist[s:_JUMPS])-1
        :call insert(jumplist[s:_JUMPS], {"path":a:file_path,"line":a:line,"col":a:col},curr_index+1)
        if len(jumplist[s:_JUMPS]) > s:_MAX_JUMPS
          :call remove(jumplist[s:_JUMPS],0)
        else
          :let curr_index += 1
        endif
      else
        :call insert(jumplist[s:_JUMPS], {"path":a:file_path,"line":a:line,"col":a:col},curr_index+1)
        if len(jumplist[s:_JUMPS]) > s:_MAX_JUMPS
          :call remove(jumplist[s:_JUMPS],len(jumplist[s:_JUMPS])-1)
        endif
        :let curr_index += 1
      endif
      ":call insert(jumplist[s:_JUMPS], {"path":a:file_path,"line":a:line,"col":a:col},new_idx+1)
        ":let jumplist[s:_CURR_INDEX] += 1
    ":let jumplist[s:_CURR_INDEX] = new_idx
  "endif
      ":let rm_idx = curr_index == len(jumplist[s:_JUMPS])-2?0:len(jumplist[s:_JUMPS])-1
      ":let rm_idx = curr_index == 0? len(jumplist[s:_JUMPS])-1:0
      "if len(jumplist[s:_JUMPS]) > s:_MAX_JUMPS
        "if curr_index < len(jumplist[s:_JUMPS]) -2
          ":let jumplist[s:_CURR_INDEX] += 1
        "endif
        ":call remove(jumplist[s:_JUMPS],rm_idx)
        ":let jumplist[s:_CURR_INDEX] -= 1
      "else
        ":let jumplist[s:_CURR_INDEX] += 1
      "endif
    endif
  :let jumplist[s:_CURR_INDEX] = curr_index
  :call s:_setJumplist(jumplist)
  "catch
  "endt
endfunction

function JumpBack()
  :let jumplist = s:_getJumplist()
  if len(jumplist[s:_LOCAL_JUMPS]) > 0
    ":let local_index = jumplist[s:_LOCAL_INDEX]
    "if local_index <= 0
      "if len(jumplist[s:_LOCAL_JUMPS]) > 0
        ":let jump_path = GetFilePath()
        ":let jump_x = jumplist[s:_LOCAL_JUMPS][0][s:_COL]
        ":let jump_y = jumplist[s:_LOCAL_JUMPS][0][s:_LINE]
        ":call AddJump(jump_path,jump_y,jump_x)
        ":let results =  s:_addJump(s:_JUMPS, s:_CURR_INDEX, jump_path, jump_y, jump_x)
        ":call s:_setJumplist(results[0])
        ":let found = results[0]
        ":let new_idx = results[1]
        ":let jumplist = results[2]
        "if !found
          ":call insert(jumplist[s:_JUMPS], {"path":jump_path,"line":jump_y,"col":jump_x},new_idx)
          ":let jumplist[s:_CURR_INDEX] +=1
        "endif
      "endif

      ":let jumplist[s:_LOCAL_JUMPS] = []
      ":call s:_setJumplist(jumplist)
      ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
      ":return JumpBack()
    "else
      ":let x = GetCurrX()
      ":let y = GetCurrY()
      ":let jump_x = jumplist[s:_LOCAL_JUMPS][jumplist[s:_LOCAL_INDEX]][s:_COL]
      ":let jump_y = jumplist[s:_LOCAL_JUMPS][jumplist[s:_LOCAL_INDEX]][s:_LINE]
      "if x ==# jump_x && y == jump_y
        ":let local_index -= 1
        ":let jumplist[s:_LOCAL_INDEX] = local_index
        ":call s:_setJumplist(jumplist)
      "endif
      ":let jump =  jumplist[s:_LOCAL_JUMPS][local_index]
      "if jump[s:_PATH] != GetFilePath()
        ":let jumplist[s:_LOCAL_JUMPS] = []
        ":call s:_setJumplist(jumplist)
      "endif
      ":return jump
      ":return jumplist[s:_LOCAL_JUMPS][local_index]
    "endif
    :return {}
  else
    if len(jumplist[s:_JUMPS]) == 0
      :return {}
    endif
    :let idx = s:_getCurrIndex()
    if idx < 0
      :let idx = 0
      :let jumplist[s:_CURR_INDEX] = idx
      :call s:_setJumplist(jumplist)
    endif
    if idx >= len(jumplist[s:_JUMPS])
      :let idx = len(jumplist[s:_JUMPS]) -1
      :let jumplist[s:_CURR_INDEX] = idx
      :call s:_setJumplist(jumplist)
    endif
    :let path = GetFilePath()
    :let x = GetCurrX()
    :let y = GetCurrY()
    :let jump_path = jumplist[s:_JUMPS][jumplist[s:_CURR_INDEX ]][s:_PATH]
    :let jump_x = jumplist[s:_JUMPS][jumplist[s:_CURR_INDEX ]][s:_COL]
    :let jump_y = jumplist[s:_JUMPS][jumplist[s:_CURR_INDEX ]][s:_LINE]
    if idx !=0 && path ==# jump_path && x ==# jump_x && y == jump_y
      :let idx -= 1
      :let jumplist[s:_CURR_INDEX] = idx
      :call s:_setJumplist(jumplist)
    endif
   :return jumplist[s:_JUMPS][idx]
  endif
endfunction

function JumpForward()
  :let jumplist = s:_getJumplist()
  if len(jumplist[s:_LOCAL_JUMPS]) > 0
    ":let local_index = jumplist[s:_LOCAL_INDEX]
    "if local_index >= len(jumplist[s:_LOCAL_JUMPS])-1
      ":let jumplist[s:_LOCAL_JUMPS] = []
      ":let jumplist[s:_LOCAL_INDEX] = -1
      ":call s:_setJumplist(jumplist)
      ":return JumpForward()
    "else
      ":let local_index += 1
      ":let jumplist[s:_LOCAL_INDEX] = local_index
      ":call s:_setJumplist(jumplist)
      ":let jump =  jumplist[s:_LOCAL_JUMPS][local_index]
      "if jump[s:_PATH] != GetFilePath()
        ":let jumplist[s:_LOCAL_JUMPS] = []
        ":call s:_setJumplist(jumplist)
      "endif
      ":return jump
    "endif
    :return {}
  else
    :let idx = s:_getCurrIndex()
    if idx ==# len(jumplist[s:_JUMPS])-1
      :return {}
    endif

    if idx < 0
      :let idx = 0
      :let jumplist[s:_CURR_INDEX] = idx
      :call s:_setJumplist(jumplist)
      :return {}
    endif
    if idx >= len(jumplist[s:_JUMPS])
      :let idx = len(jumplist[s:_JUMPS]) -1
      :let jumplist[s:_CURR_INDEX] = idx
      :call s:_setJumplist(jumplist)
      :return {}
    endif
    :let idx += 1
    :call s:_setCurrIndex(idx)
    :return jumplist[s:_JUMPS][idx]
  endif
endfunction

function JumpCursorBack()
  ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
  :let jump_back = JumpBack()
  if jump_back == {}
    :return
  endif
  if GetFilePath() == jump_back[s:_PATH]
    :let b:jumplist_disabled = 1
    :call SetCaretPos(jump_back[s:_LINE],jump_back[s:_COL])
    :let b:jumplist_disabled = 0
    :exe 'norm! zv'
    :set scrolloff=25
  else
    :call OpenFile(jump_back[s:_PATH], 0, jump_back[s:_LINE], jump_back[s:_COL])
  endif
endfunction

function JumpCursorForward()
  ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
  :let jump_back = JumpForward()
  if jump_back == {}
    :return
  endif
  if GetFilePath() == jump_back[s:_PATH]
    :let b:jumplist_disabled = 1
    :call SetCaretPos(jump_back[s:_LINE],jump_back[s:_COL])
    :let b:jumplist_disabled = 0
    :exe 'norm! zv'
    :set scrolloff=25
  else
    :call OpenFile(jump_back[s:_PATH], 0, jump_back[s:_LINE], jump_back[s:_COL])
  endif
endfunction

function AddCurrLocationToJumps()
  "::silent exe '!echo "file_path:" >> /tmp/deb'
  try
    if !exists('b:jumplist_disabled') || !b:jumplist_disabled
      :call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
    endif
  catch
  endt
endfunction
"===============================================================
:nnoremap <C-n> :call JumpCursorBack()<CR>:call SetCursorR()<CR>
:nnoremap <C-o> :call JumpCursorForward()<CR>:call SetCursorR()<CR>

:nnoremap <C-a> :call JumpCursorBack()<CR>:call SetCursorL()<CR>
:nnoremap <C-t> :call JumpCursorForward()<CR>:call SetCursorL()<CR>



