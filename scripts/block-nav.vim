let g:debug = 1

function! CountTokens(start_tokens,end_tokens,end_to_start_token_map,max_token_length)
  :let token_diffs = {}
  :let x = 0
  :let y = 1

  while y <= GetNumLinesInBuffer()
    while x < GetLastRowX(y)
      :let token = TokenIsAt(x, y, a:max_token_length, a:start_tokens)
      if token  != ""
        if !has_key(token_diffs, token)
          :let token_diffs[token] = 0
          :
        endif
        if token_diffs[token] >= 0
          :let token_diffs[token] += 1
        endif
      else
        :let token = TokenIsAt(x, y, a:max_token_length, a:end_tokens)
        if token  != ""
          :let token = a:end_to_start_token_map[token]
          if !has_key(token_diffs, token)
            :let token_diffs[token] = 0
          endif
          :let token_diffs[token] -= 1
        endif
      endif
      :let x+=1
    endwhile
    :let y+=1
    :let x = 0
  endwhile
:return token_diffs
endfunction

function! TokenIsAt(x,y,max_token_length,token_list)
  :let line = getline(a:y)
  :let i = 1
  while i<=a:max_token_length
    :let idx = index(a:token_list,line[a:x-i:a:x])
    if idx != -1
      :return a:token_list[idx]
    endif
    :let i += 1
  endwhile
  return ""
endfunction

function! FindPairs()
  if &ft == "help"
    :return
  endif
if &ft == "python"
  :let y = 1
  :let prev_indent_level = -1
  :let indent_level = GetIndentLevel(y)
  :let indices = []
  :let start_stack = []
      ":D  start_stack,y,GetNumLinesInBuffer()
  while y <= GetNumLinesInBuffer()
      ":D y,indent_level%&shiftwidth
    if indent_level%&shiftwidth==0
      :let level = indent_level/&shiftwidth
      :let last_char = getline(y)[GetLastRowX(y)-1]
      ":D last_char
      "if prev_indent_level != -1 && indent_level > prev_indent_level || level == 0
      if prev_indent_level != -1 && indent_level > prev_indent_level
        :let start_stack += [[level,prev_indent_level,y-1]]
        ":let start_stack += [[level,prev_indent_level,y]]
        ":D "indent",y,start_stack
      endif
      "if prev_indent_level != -1 && indent_level < prev_indent_level && last_char != ":" && last_char != ")"
      if prev_indent_level != -1 && indent_level < prev_indent_level
        if len(start_stack) >0
          :let count = (prev_indent_level-indent_level)/&shiftwidth
          while count > 0
            if len(start_stack) >0
                :let popped =  Pop(start_stack)
                :let indices += [[popped[0],"_",popped[1],popped[2],"_",GetLastRowX(y),y-1]]
            endif
            :let count -= 1
          endwhile
          ":D "dedent",y,start_stack
        endif
      endif
    endif
    :let y += 1
    :let prev_indent_level = indent_level
    :let indent_level = GetIndentLevel(y)
  endwhile
  :let indices = sort(sort(indices,{a,b->a[2]>b[2]}),{a,b->a[3]>b[3]})

  :call Save(indices, '/tmp/bnav')
  :return indices
endif

if  &ft == "" || &ft == "text"
  :let y = 1
  :let indices = []
  :let prev_y = -1
  while y <= GetNumLinesInBuffer()
    if LineIsOnlySpaces(y) && !LineIsOnlySpaces(y-1)
      :let indices += [[0,"_",1,prev_y,"_",1,y-1]]
      :let prev_y = y
    else
    endif
  :let y += 1
  endwhile
  :return indices
endif

  :let end_to_start_token_map = {}
  :let start_to_end_token_map = {}
  :let start_token_list = ['{',"for ","function!","while ","if ","try","augroup"]
  :let end_token_list = ['}',"endfor","endfunction","endwhile","endif","endt","END"]
  :let max_token_length = 1
  for token in start_token_list
    if len(token) > max_token_length
      :let max_token_length = len(token)
    endif
  endfor
  for token in end_token_list
    if len(token) > max_token_length
      :let max_token_length = len(token)
    endif
  endfor
  :let i = 0
  while i < len(start_token_list)
    :let start_to_end_token_map[start_token_list[i]] = end_token_list[i]
    :let end_to_start_token_map[end_token_list[i]] = start_token_list[i]
    :let i += 1
  endwhile

  :let token_diffs = CountTokens(start_token_list, end_token_list, end_to_start_token_map,max_token_length)

  "remove invalid tokens
  for start_token in keys(token_diffs)
    :let count = token_diffs[start_token]
    if count < 0
      :let end_token = start_to_end_token_map[start_token]
      :let idx = index(end_token_list,end_token)
      :call remove(end_token_list, idx)

      :let idx = index(start_token_list,start_token)
      :call remove(start_token_list, idx)
    endif
  endfor
  :let token_stack = []
  :let indices = []
    ":D token_diffs

  :let x = 0
  :let y = 1
  while y <= GetNumLinesInBuffer()
    while x <  GetLastRowX(y)
      :let token = TokenIsAt(x, y, max_token_length, start_token_list)
      if token  != ""
        :let token_stack += [[token,x,y]]
      else
        :let token = TokenIsAt(x, y, max_token_length, end_token_list)
      ":D  x, y, max_token_length, start_token_list,token, token_stack
        if token  != ""
          if len(token_stack)>0 && end_to_start_token_map[token] == LastValue(token_stack)[0]
            :let popped = Pop(token_stack)
            :let level = len(token_stack)+1
            :let start_token = popped[0]
            :let start_x = popped[1]
            :let start_y = popped[2]

            :let end_token = token
            :let end_x = x
            :let end_y = y
            :let start_x += 1
            :let end_x += 1
            :let indices += [[level,start_token,start_x,start_y,end_token,end_x,end_y]]
          else
            ":let suppossed_token = end_to_start_token_map[char]
            ":D token, end_to_start_token_map

            :let suppossed_token = end_to_start_token_map[token]
            ":D suppossed_token
            if has_key(token_diffs, token) && token_diffs[suppossed_token] == 0
              :let popped = Pop(token_stack)
              :let curr_token = popped[0]
              while curr_token != suppossed_token
                :let token_diffs[curr_token] -=1
                :let popped = Pop(token_stack)
                :let curr_token = popped[0]
              endwhile
              :let level = len(token_stack)+1
              :let start_token = popped[0]
              :let start_x = popped[1]
              :let start_y = popped[2]

              :let end_token = token
              :let end_x = x
              :let end_y = y

              "if start_x == 0
                ":let start_x = 1
              "endif
              "if end_x == 0
                ":let end_x = 1
              "endif
              :let start_x += 1
              :let end_x += 1
              :let indices += [[level,start_token,start_x,start_y,end_token,end_x,end_y]]
            else
              if len(token_stack)>0
              :let token_stack_last_token = LastValue(token_stack)[0]
              if token_diffs[token_stack_last_token] == 0
              ":try
                ":D "sent",token_diffs,token
                if !has_key(token_diffs,token)
                  :let token_diffs[end_to_start_token_map[token]] =1
                else
                  :let token_diffs[end_to_start_token_map[token]] +=1
                endif
                ":catch
                ":endt
              else
                :call Pop(token_stack)
                :let token_diffs[token_stack_last_token] -=1
              endif
              endif
            endif
          endif
        endif
      endif
      :let x+=1
    endwhile
    :let y+=1
    :let x = 0
  endwhile
  :let ret = sort(sort(indices,{a,b->a[2]>b[2]}),{a,b->a[3]>b[3]})
  :call Save({'pairs':ret}, '/cache/ide/folds/'.GetFilePath())
  :return ret
endfunction


function! GetFoldStates()
  :let b:open_folds = []
  :for pair in b:pairs
    :let start_y = pair[3]
    if foldclosed(start_y) == -1
      :let b:open_folds += [1]
    else
      :let b:open_folds += [0]
    endif
  endfor
endfunction

function OpenFold(y)
  try
    :exe string(a:y).','.string(a:y).'foldopen'
    :return 1
  catch
    :return 0
  endt
endfunction

function CloseFold(y)
  try
    :exe string(a:y).','.string(a:y).'foldclose'
    :return 1
  catch
    :return 0
  endt
endfunction


function FoldRegion(start_y,end_y)
  :exe string(a:start_y).','.string(a:end_y).'fold'
endfunction

function! MakeFolds(...)
  ":let b:pairs = FindPairs()
  :let loaded = Load('/cache/ide/folds/'.GetFilePath())
  if !has_key(loaded,'pairs')
    :return
  endif
  :let b:pairs = loaded['pairs']

  ":D b:pairs
  :call GetFoldStates()
  :set nofoldenable
  :exe 'norm! zE'
  :let i = 0
  for pair in b:pairs
    :let start_x = pair[2]
    :let start_y = pair[3]
    :let end_x = pair[5]
    :let end_y = pair[6]
    :exe string(start_y).','.string(end_y).'fold'
    if b:open_folds[i]
      :exe string(start_y).','.string(start_y).'foldopen'
    endif
    :let i += 1
  endfor
  :set foldenable
endfunction

function! GetCurrLevel()
  :let index = GetPairBetweenIndex()
  ":D index
  if type(index) == type([])
    :let index = index[1]
    if index < len(b:pairs)
      :return b:pairs[index][0]-1
    else
      :return 0
    endif
  else
    :return b:pairs[index][0]
  endif
endfunction


function! IsBetween(x,y,x1,y1,x2,y2)
  ":D a:x,a:y,a:x1,a:y1,a:x2,a:y2
  if a:y > a:y1 && a:y < a:y2
    :return 1
  endif
  if a:y == a:y1
    if a:y == a:y2
      :return a:x > a:x1  && a:x < a:x2
    else
      :return a:x > a:x1
    endif
  endif
  if a:y == a:y2
    if a:y == a:y2
      :return a:x > a:x1  && a:x < a:x2
    else
      :return a:x <= a:x2
    endif
  endif
  :return 0
endfunction

function! GetPairBetweenIndex()
  :let x = GetCurrX()
  :let y = GetCurrY()
  :let max_depth = -1
  :let curr_index = -1
  :let i = 0
  for pair in b:pairs
    :let depth = pair[0]
    :let x1 = pair[2]
    :let y1 = pair[3]
    :let x2 = pair[5]
    :let y2 = pair[6]
    if IsBetween(x, y, x1, y1, x2, y2) && depth > max_depth
      :let max_depth = depth
      :let curr_index = i
    endif
    :let i += 1
  endfor
  ":D "curr_index",curr_index
  if curr_index == -1
    :let i = 0
    for pair in b:pairs
      :let curr_depth = pair[0]
      :let curr_x = pair[2]
      :let curr_y = pair[3]
      if curr_y == y && curr_x > x || curr_y > y && curr_depth == 1
        :let curr_index = [i-1,i]
        :break
      endif
      :let i += 1
    endfor
    ":D "here",curr_index,len(curr_index)
    if type(curr_index) == type([])
      :return curr_index
    else
      :return [len(b:pairs)-1,len(b:pairs)]
    endif
  else
    :return curr_index
  endif
endfunction

function! BlockNavIn()
  :let y = GetCurrY()
  :let x = GetCurrX()
  :let level = GetCurrLevel()

  :let curr_index = GetPairBetweenIndex()
  if type(curr_index) == type([])
    :let index = curr_index[1]
    ":D curr_index
    if index >= len(b:pairs)
      :let goto = [x,y]
    else
      :let goto = [b:pairs[index][2],b:pairs[index][3]]
    endif
  else
    :let pairs_filtered = filter(copy(b:pairs[curr_index:]), {_,x->x[0]==level+1})
    if len(pairs_filtered) == 0
      :let goto = [b:pairs[curr_index][5],b:pairs[curr_index][6]]
    else
      :let found = 0
      for pair in pairs_filtered
        :let curr_x = pair[2]
        :let curr_y = pair[3]
        if curr_y>y || curr_y==y && curr_x>=x
          :let found = 1
          :break
        endif
      endfor
      ":silent exe '!echo '.string(pairs_filtered).' >> /tmp/deb'
      if found
        :let goto = [curr_x,curr_y]
      else
        :let goto = [b:pairs[curr_index][5],b:pairs[curr_index][6]]
      endif
    endif
  endif

  :call SetCaretPos(goto[1], goto[0])
  :call SetCursor()
  :call NavRight()
  :call SetCursor()
  try
    :silent exe 'norm! zo'
  catch
  endt
endfunction

function! BlockNavOut()
  :let level = GetCurrLevel()

  :let curr_index = GetPairBetweenIndex()
  if type(curr_index) == type([])
    :let index = curr_index[0]
    if type(index) == type([])
      :let goto = [GetCurrX(),GetCurrY()]
    else
      :let pair = b:pairs[index]
      :let start_token = pair[1]
      :let start_x = pair[2]
      :let start_y = pair[3]

      if len(start_token)>1
        :let start_x-=len(start_token)-1
      endif

      :let goto = [start_x,start_y]
    endif
  else
      :let pair = b:pairs[curr_index]
      :let start_token = pair[1]
      :let start_x = pair[2]
      :let start_y = pair[3]

      if len(start_token)>1
        :let start_x-=len(start_token)-1
      endif
      :let goto = [start_x,start_y]
  endif

  :call SetCaretPos(goto[1], goto[0])
  :call SetCursor()
  :try
    :silent exe 'norm! zc'
  catch
  endt
endfunction
"=============================================================== nav funcs
function! BlockNavDown()
  :let x = GetCurrX()
  :let y = GetCurrY()
  :let level = GetCurrLevel()
  :let pairs_filtered = filter(copy(b:pairs), {_,x->x[0]==level+1})
  :let goto = [x,y]
  if len(pairs_filtered) == 0 && level == 0
    :let index = GetPairBetweenIndex()[1]
    if index < len(b:pairs)
      :let goto = [b:pairs[index][2],b:pairs[index][3]]
    endif
  else
    for pair in pairs_filtered
      :let start_token = pair[1]
      :let start_x = pair[2]
      :let start_y = pair[3]
      if len(start_token)>1
        :let start_x-=len(start_token)-1
      endif
      if start_y > y
        :let goto = [start_x,start_y]
        :break
      endif
  endfor
  endif
  :call SetCaretPos(goto[1], goto[0])
  :call SetCursor()
endfunction

function! BlockNavUp()
  :let x = GetCurrX()
  :let y = GetCurrY()
  :let level = GetCurrLevel()
  :let pairs_filtered = filter(copy(b:pairs), {_,x->x[0]==level+1})
  :let goto = [x,y]
  if len(pairs_filtered) == 0 && level == 0
    :let index = GetPairBetweenIndex()[1]
    if index < len(b:pairs)
      :let goto = [b:pairs[index][2],b:pairs[index][3]]
    endif
  else
    for pair in reverse(pairs_filtered)
      :let start_token = pair[1]
      :let start_x = pair[2]
      :let start_y = pair[3]
      if len(start_token)>1
        :let start_x-=len(start_token)-1
      endif
      if start_y < y
        :let goto = [start_x,start_y]
        :break
      endif
    endfor
  endif
  :call SetCaretPos(goto[1], goto[0])
  :call SetCursor()
endfunction

function! BlockNavTop()
  :let prev_x = -1
  :let prev_y = -1
  :let x = GetCurrX()
  :let y = GetCurrY()
  while  !(x == prev_x && y==prev_y)
    :let prev_x = x
    :let prev_y = y

    :call BlockNavUp()
    :let x = GetCurrX()
    :let y = GetCurrY()
  endwhile
endfunction

function! BlockNavBottom()
  :let prev_x = -1
  :let prev_y = -1
  :let x = GetCurrX()
  :let y = GetCurrY()
  while  !(x == prev_x && y==prev_y)
    :let prev_x = x
    :let prev_y = y

    :call BlockNavDown()
    :let x = GetCurrX()
    :let y = GetCurrY()
  endwhile
endfunction

function! BlockNavRoot()
  while GetCurrLevel() != 0
    :call BlockNavOut()
  endwhile
endfunction

function! BlockNavLeaf()
  if foldclosed(GetCurrY()) == -1
    :let prev_level = -1
    :let level = GetCurrLevel()
    while level > prev_level
      :let prev_level = level
      :call BlockNavIn()
      :let level = GetCurrLevel()
    endwhile
  else
    :exe 'norm! zO'
  endif
endfunction

function! FoldAll()
  :call BlockNavRoot()
  :try
    :exe "1,".GetNumLinesInBuffer()."foldclose!"
  catch
  endt
endfunction

function! UnfoldAllBelow()
  :call BlockNavRoot()
  :try
    :exe string(GetCurrY())",".GetNumLinesInBuffer()."foldopen!"
  catch
  endt
endfunction

function! FoldText()
  :let i = 1
  :let spaces = ''
  while i < GetLastRowX(v:foldstart)
    if !IsSpace(GetCharAt(i, v:foldstart))
      :break
    endif
    :let i += 1
    :let spaces .= ' '
  endwhile
  :return  spaces.">".getline(v:foldstart)[i-1:len(getline(v:foldstart))]
  ":return  spaces.getline(v:foldstart)[i-1:len(getline(v:foldstart))]
endfunction
set foldtext=FoldText()


function UpdateFolds(channel, msg, event)
  :D "ser"
  :let g:ss=88
  :doautocmd User FoldsUpdated
endfunction

function s:_dbgOutHandler(channel, msg, event)
 ":let g:last_dbg_out = a:msg
  "call writefile(a:msg, $HOME.'/.jdb.vim.log', 'a')
  :sil exe '!touch /cache/ide/folds/config/stem/vim/nvim/scripts/persistence.vim'
endfunction

function s:_dbgErrHandler(channel, msg, event)
endfunction

function s:_dbgExitHandler(channel, msg, event)
  :let g:ss=98
  :sil exe '!touch /cache/ide/folds/config/stem/vim/nvim/scripts/exit'
endfunction


function Dummy()
  :sil exe '!touch /cache/ide/folds/config/stem/vim/nvim/scripts/exit'
  :call jobstart('sendCommandToVim "call FindPairs()" &',{})
endfunction

function DoFindPairs()
  ":call jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()"',{'on_exit':{->execute('doautocmd User FoldsUpdated')}})
  let callbacks = {
    \ 'on_stdout': function('s:_dbgOutHandler'),
    \ 'on_stderr': function('s:_dbgErrHandler'),
    \ 'on_exit': function('s:_dbgExitHandler'),
    \ 'detach': 1
    \ }
  ":call jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()"',{'on_exit':function('UpdateFolds')})
  ":let id =  jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()"; sendCommandToVim "call ShowStatusMessage("srien")',callbacks)
  ":let id =  jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()"; sendCommandToVim "echo 999"',callbacks)
  ":let id =  jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()"; sendCommandToVim "echo 999"',{})
  ":let id =  jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()" || echo done',callbacks)
  ":let id =  jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()"',callbacks)
  ":let id =  jobstart('sendCommandToVim "call Dummy()" &',{})
  ":let id =  jobstart('nvim -es '.GetFilePath().' -c "call FindPairs()"',callbacks)
endfunction

augroup BlockNav


au!
  "autocmd CursorHold * let b:pairs = FindPairs()
  "autocmd InsertLeave * let b:pairs = FindPairs()
  "autocmd  TextChanged * let b:pairs = FindPairs()
  "autocmd  BufWritePost,BufRead,FileReadPost * call MakeFolds()
  "autocmd  TextChangedI, BufRead * call MakeFolds()
  "autocmd  FocusGained,InsertLeave,BufRead * call MakeFolds()

  "autocmd  SourcePre,VimEnter,BufRead,InsertLeave * call MakeFolds()
 "autocmd  SourcePost,VimEnter,BufRead,TextChanged * call timer_start(100, 'MakeFolds')
  "autocmd  SourcePost,VimEnter,BufRead,TextChanged * call MakeFolds()


 "autocmd TextChanged * call timer_start(100, 'MakeFolds') "autocmd TextChanged * call timer_start(100, 'MakeFolds')
 "autocmd FileReadPost * call MakeFolds() "autocmd CursorHold * call MakeFolds() "autocmd CursorHold * mkview autocmd
 "CursorHold * call FindPairs() "autocmd BufWinLeave *.* mkview "autocmd BufReadPost *.* silent loadview | call MakeFolds()
 "autocmd BufReadPost *.* silent loadview
"autocmd BufWinLeave * if expand("%") != "" | mkview | endif
"autocmd BufWinEnter * if expand("%") != "" | silent loadview | endif

"autocmd BufWinLeave * try | silent mkview | catch | endt
"autocmd BufWinEnter * try | silent loadview | catch | endt
augroup END
nnoremap h<Space>f :call MakeFolds()<CR>


"=============================================================== nav funcs2
function! BlockNavOut2()
try
  :exe 'norm! [z'
  :exe 'norm! zc'
  :exe 'norm! k0'
catch
endt
:call SetCursor()
":call AddLocationToJumps()
endfunction

function! BlockNavDown2()
  :exe 'norm! zj'
  :call SetCursor()
endfunction


function! BlockNavUp2()
  :exe 'norm! zk'
  :call SetCursor()
  ":let y = GetCurrY()
  ":exe 'norm! [z'
  "while GetCurrY() != y
    ":let y = GetCurrY()
    ":exe 'norm! [z'
  "endwhile
  ":exe 'norm! zkzj'
  ":call SetCursor()
endfunction


function! BlockNavIn2()
  if foldclosed(GetCurrY()) != -1
    if OpenFold(GetCurrY())
      :return
    endif
  endif
  :exe 'norm! zj'
  :call OpenFold(GetCurrY())
  :IndentBlanklineRefresh
endfunction

"------------------------------------------------- local leader
function! BlockNavRoot2()
  try
    :exe 'norm! zC'
    :exe 'norm! k0'
  catch
  endt
  :call SetCursor()
endfunction

function BlockNavBottom2()
  if GetCurrX() == 1 && !OpenFold(GetCurrY())
    :exe 'norm! G'
    :return
  endif
  :let y = GetCurrY()
  :exe 'norm! ]z'
  while GetCurrY() != y
    :let y = GetCurrY()
    :exe 'norm! ]z'
  endwhile
  :exe 'norm! j'
endfunction

function BlockNavTop2()
  if GetCurrX() == 1 && !OpenFold(GetCurrY())
    :exe 'norm! gg'
    :return
  endif
  :let y = GetCurrY()
  :exe 'norm! [z'
  while GetCurrY() != y
    :let y = GetCurrY()
    :exe 'norm! [z'
  endwhile
  :exe 'norm! k'
endfunction


function! BlockNavLeaf2()
  if foldclosed(GetCurrY()) != -1
    if OpenFold(GetCurrY())
      try
        :exe 'norm! zc'
        :exe 'norm! zO'
      catch
      endt
      return
    endif
  endif
  :exe 'norm! zj'
  try
    :exe 'norm! zO'
  catch
  endt
  :IndentBlanklineRefresh
endfunction
"------------------------------------------------- leader
function! FoldAll2()
  :exe 'norm! zM'
endfunction

function UnfoldAllBelow2()
  :let y = GetCurrY()
  try
    :exe 'norm! zO'
  catch
  endt
  :exe 'norm! zj'
  while GetCurrY() != y
    :let y = GetCurrY()
    :exe 'norm! zO'
    :exe 'norm! zj'
  endwhile
  :call UpdateCursor()
 :IndentBlanklineRefresh
endfunction

