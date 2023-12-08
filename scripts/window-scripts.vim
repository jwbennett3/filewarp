
function GetMaxIndex()
  :let hostname = system("echo -n $HOSTNAME")
  if hostname == "shenobi"
    :return 1
  endif
  if system('echo -n $context') == 'home'
    :return 8
  else
    :return 5
  endif
endfunction

function OpenFileForEditing(path,same_win,line,col)
  ":let path = CleanFilePath(a:path)
  :let path = a:path
  if empty(glob(path))
    :echo a:path.' does not exist'
    :return
  endif
  :let max_index = GetMaxIndex()
  :let pinned_index = GetPinnedIndex(path)
  if exists('$INDEX')
    if pinned_index !=# -1
      :let new_index = pinned_index
    elseif a:same_win ==# '1'
      :let new_index = $INDEX
    elseif $INDEX >=# max_index
      :let new_index = $INDEX - 1
    else
      :let new_index = $INDEX + 1
    endif
  :call SetSelectedEditorIndex(new_index)
  :sil exe '!focusActiveEditor_r'
  :sil exe '!editorFlipTo $(getSelectedEditorIndex) 1'

  :sil exe '!addRecentFile '.path.' 0'
  if new_index ==# $INDEX
    ":bw!
    :sil exe 'edit '.path
    ":sleep 1000m
    ":source $NVIMHOME/init.vim
    :call PromoteTab()
    :call SetCaretPos(a:line, a:col)
    :exe 'norm! zv'
    :call SetCursor()
    :call SetBufferCount(GetNumberOfOpenBuffers())
    :BufferPin
    :BufferPin
  else
    :sil exe '!sendCommandToVim /tmp/vim'.string(new_index).' call OpenFileForEditing\(\"'.path.'\",1,'.a:line.','.a:col.'\)'
    "(theory) if you just call OpenFileForEditing() there is a weird loading problem
    ":sil exe '!sendCommandToVim /tmp/vim'.new_index.' "edit '.a:path.'"'
    ":sil exe '!sendCommandToVim /tmp/vim'.new_index.' "call PromoteTab()"'
    ":sil exe '!sendCommandToVim /tmp/vim'.new_index.' call SetCaretPos('a:line.','.a:col.')"'
    ":sil exe '!sendCommandToVim /tmp/vim'.new_index.' call SetCursor() | norm\! zv"'
    ":let cmd = '!index='.string(new_index).' sendCommandToVim "norm\! zv"'
    ":sil exe cmd
    ":sil exe '!sendCommandToVim /tmp/vim'.new_index.' "call SetBufferCount(GetNumberOfOpenBuffers())"'
    ":sil exe '!sendCommandToVim("blast")'

  endif
  else

  endif
endfunction

function OpenFile(path,same_win,line,col)
  :let max_index = GetMaxIndex()
  :let pinned_index = GetPinnedIndex(a:path)

  if pinned_index !=# -1
    :let new_index = pinned_index
  elseif a:same_win ==# '1'
    :let new_index = $INDEX
  elseif $INDEX >=# max_index
    :let new_index = $INDEX - 1
  else
    :let new_index = $INDEX + 1
  endif
  :call SetSelectedEditorIndex(new_index)
  :sil exe '!focusActiveEditor_r'
  :sil exe '!editorFlipTo $(getSelectedEditorIndex) 1'

  :sil exe '!addRecentFile '.a:path.' 0'
  if new_index ==# $INDEX
    :sil exe 'edit '.a:path
    :call SetCaretPos(a:line, a:col)
    :exe 'norm! zv'
    :call SetCursor()
    :call SetBufferCount(GetNumberOfOpenBuffers())
  else
    "TODO should probably just send call OpenFileForEditing()
    ":sil exe '!index='.string(new_index).' sendCommandToVim "edit '.a:path.'"'
    ":sil exe '!index='.string(new_index).' sendCommandToVim "call SetCaretPos('a:line.','.a:col.')"'
    ":sil exe '!index='.string(new_index).' sendCommandToVim "call SetCursor() | norm\! zv"'
    ":let cmd = '!index='.string(new_index).' sendCommandToVim "norm\! zv"'
    ":sil exe cmd
    ":sil exe '!index='.string(new_index).' sendCommandToVim "call SetBufferCount(GetNumberOfOpenBuffers())"'
    :sil exe '!sendCommandToVim /tmp/vim'.string(new_index).' call OpenFile\(\"'.a:path.'\",1,'.a:line.','.a:col.'\)'
  endif
endfunction

function ColorBackground()
 call AddBreakpointsToBuffer()
  if IsDebugBuffer()
      :hi ColorColumn ctermbg=21 guibg=#0000ff
      :exe 'hi Normal ctermbg=189 guibg=#effaeb'
      :set scrolloff=999
      ":set nocursorline
      :return
  endif
  :hi ColorColumn ctermbg=224
  :let file_path=GetFilePath()
  :let l:color = 230
  :let gui_color = '#ffffe6'
  if IsTransientAt(file_path, $INDEX)
    :let l:color = 195
  endif
  if IsPinnedAt(file_path, $INDEX)
    :let l:color = 7
    :let gui_color = '#E5E5E5'
  endif
  :exe 'hi Normal ctermbg='.l:color.' guibg='.gui_color
endfunction

function EditDeclaration()
  while GetCharUnderCursor() ==# " " || GetCurrX()==1
    :sil exe 'norm! h'
  endwhile

  :let x = GetCurrX()
  :let y = GetCurrY()
  :let called_from_path=GetFilePath()
  :let word = expand('<cword>')
  :let $line = 1
  :let $col = 1
  if &filetype ==# "vim"
    :sil exe '!setTagReg '.word
    :let items = split(Read('/tmp/tag'))
    if len(items) != 3
      :echom 'tag not found'
      :return
    endif
    :let $file_path=items[0]
    :let $col=items[1]
    :let $line=items[2]
    :let coc = 0
  else
    :let path = GetFilePath()
    :silent call CocAction("jumpDefinition")
    if x ==# GetCurrX() && y ==# GetCurrY() && path ==# GetFilePath()
      :exe 'norm! gg'
      :call SearchForStringF(word)
      :call SetCursor()
      :return
    endif
    :let $line=getpos('.')[1]
    :let $col=getpos('.')[2]
    :let $file_path=GetFilePath()
    :let coc = 1
  endif
  if called_from_path != $file_path
    if coc
      :bd!
    endif
    :call OpenFileForEditing($file_path, 0, $line, $col)
    :call SetCursor()
  else
    :call SetCaretPos($line, $col)
    :call SetCursor()
  endif
endfunction

function ReadDeclaration()
    :let called_from_path=GetFilePath()
    :silent call CocAction("jumpDefinition")
    :sleep 300m
    :let $line=getpos('.')[1]
    :let $col=getpos('.')[2]
    :let $file_path=GetFilePath()
    if called_from_path != $file_path
      :silent exec "!openFileForReading server$INDEX False $file_path $line $col &"
      :bd!
    else
      :call SetCursor()
    endif
endfunction

function GotoImplementation()
  :let called_from_path=GetFilePath()
  :silent call CocAction("jumpImplementation")
  :sleep 500m
  :let $line=getpos('.')[1]
  :let $col=getpos('.')[2]
  :let $file_path=GetFilePath()
  if called_from_path != $file_path
    :silent exec "!openFileForEditing $INDEX $file_path $line $col"
    :bd!
  else
    :call SetCursor()
  endif
endfunction

function MoveToRightVim()
  :let $file_path=GetFilePath()
  :BufferDelete
  :call Run("moveToRightVim $file_path")
endfunction

function! MoveToLeftVim()
  :let $file_path=GetFilePath()
  :BufferDelete
  :call Run("moveToLeftVim $file_path")
endfunction

function MoveToIndexVim(index)
   let index = a:index
   if $context ==# "home"
      "if index==4
         "let index=0
      "endif
      "if index==5
         "let index=1
      "endif
      "if index==6
         "let index=3
      "endif
      "if index==7
         "let index=4
      "endif
      "if index==8
         "let index=5
      "endif
  else
    "if index >=5
       "let index-=3
    "endif
  endif
  :let file_path=GetFilePath()
  ":bd!
  :BufferDelete
  :call Run('moveToIndexVim '.file_path.' '.index)
  :call Run('xdotool key ctrl+shift+a')
endfunction

"let w:last_focus_lost=localtime()
function FocusLost()
  :let file_path=GetFilePath()
  if IsTransientAt(file_path, $INDEX) && !IsPinnedAt(file_path,$INDEX)
    :call UnsetTransientAt(file_path,$INDEX)
    ":sleep 1000m

    ":bwipeout! | edit #1 | bprev
    :bwipeout!

    ":bd!
    ":sleep 1000m
    ":bprev
    ":sleep 1000m
    ":bnext
  endif

  :call ColorBackground()

"else
"endif
endfunction

function CloseBuffer()
  "if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
  "checking if there is more than one buffer open
  if len(getbufinfo({'buflisted':1})) > 1
    "if closing undotree
    :let file_path = GetFilePath()
    "there's more than one window open
    if winnr('$') > 2
      ":sil exe 'norm! ZZ'
      :sil exe 'norm! ZZ'
    else
      ":bwipeout!
      :BufferDelete
    endif
    :call RemoveFromEditor($INDEX, file_path)
  endif
endfunction

function NameWindow()
  :let $file_path = GetFilePath()
  :let cmd_str = ''
  :silent !registerVimWindow $INDEX &
  for f in GetSessionFiles($INDEX)
    ""if IsPinnedAt(f,$INDEX)
      :exe 'edit' f
      :BufferPin
    ""else
     " ":call RemoveFromEditor($INDEX,f)
    ""endif
  endfor
  return cmd_str
endfunction

function PromoteTab()
  :let file_path = GetFilePath()
  ":exe "norm! \<C-w>k"
  ":let top_path = GetFilePath()
  ":exe "norm! \<C-w>j"
  ":let bottom_path = GetFilePath()
  ":let top_is_pinned = GetPinnedIndex(top_path) != -1
  ":let bottom_is_pinned = GetPinnedIndex(bottom_path) != -1
  :let file_is_pinned = GetPinnedIndex(file_path) != -1
  "if top_path !=# bottom_path
    ":bw!
    ":bw!
    "if top_path ==# file_path
      ":mkview! 1
      ":exe 'edit '. bottom_path
      ":loadview 1
      ":exe 'split '.file_path
      "if bottom_is_pinned
        ":call MoveToFront($INDEX,bottom_path)
        ":call MoveToFront($INDEX,top_path)
      "endif
    "else
      ":mkview! 1
      ":exe 'edit '.top_path
      ":loadview 1
      ":exe 'split '.file_path
      ":call MoveToFront($INDEX,top_path)
      ":call MoveToFront($INDEX,file_path)
    "endif
  "else
    if file_is_pinned
      :call MoveToFront($INDEX,file_path)
      :BufferPin
    endif
    ":mkview! 1
    ":bw!
    ":exe 'edit '.file_path
    ":loadview 1
  "endif
  ":let g:airline_section_c = GetFilePath()
  ":AirlineRefresh
endfunction

function GotoPin()
  :let $file_path = GetFilePath()
  :let pinned_index = GetPinnedIndex($file_path)
  if pinned_index == -1
    :let min_index = 0
    :let min_opened_files = 999
    :let i = 0
    while i<GetMaxOpenedEditors()
      :let count = GetBufferCount(i)
      :if count < min_opened_files
        :let min_index = i
        :let min_opened_files = count
      endif
      :let i += 1
    endwhile
    :let pinned_index = min_index
    :call SetPinned(pinned_index)
    :call UnsetTransientAt($file_path, pinned_index)
  endif
  if pinned_index == $INDEX
    :call ColorBackground()
    :call PromoteTab()
    :BufferPin
  else
    if !IsTransientAt($file_path,$INDEX)
      :bwipeout!
    endif
    :call OpenFileForEditing($file_path, 1, 1, 1)
  endif
endfunction

function ForcePin()
  :let $file_path = GetFilePath()
  :call SetPinned($INDEX)
  :call ColorBackground()
  :call PromoteTab()
  :BufferPin
endfunction

function SendCommandToVim(cmd,server,called_from)
  if type(a:called_from) == type(0) && a:called_from == $INDEX
    :sil exe a:cmd
  else
    if type(a:server) == type(0)
      :let server_name = '/tmp/vim'.string(a:server)
    else
      :let server_name = a:server
    endif
      ":sil exe '!servername='.server_name.' sendCommandToVim "'.a:cmd.'"'
      :sil exe '!sendCommandToVim '.server_name.' "'.a:cmd.'"'
  endif
endfunction
"Deprecated instead use SendCommandToVimAsync2
function SendCommandToVimAsync(cmd,server,called_from)
  if type(a:called_from) == type(0) && a:called_from == $INDEX
    :sil exe a:cmd
  else
    if type(a:server) == type(0)
      :let server_name = '/tmp/vim'.string(a:server)
    else
      :let server_name = a:server
    endif
      ":sil exe '!servername='.server_name.' sendCommandToVim "'.a:cmd.'" &'
      :sil exe '!sendCommandToVim '.server_name.' "'.a:cmd.'" &'
  endif
endfunction


