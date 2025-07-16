"=============================================================== util

"old split way of getting input
"Function OpenInputWindow(cmd_str)
    ":set laststatus=0
    ":set noshowmode
    ":let total_height=winheight(0)
    ":aboveleft split
    ":exe 'resize '. (total_height *1/6)
    ":silent !touch /tmp/input_win
    ":e /tmp/input_win
    ":call termopen(a:cmd_str,{'on_exit':'CloseWindow'}) | call HideVimMode()
    ":set noinsertmode
"endfunction

function FQuitNav()
  ":call feedkeys('<C-p>')
  ":call feedkeys("\<C-w>h","n")
  ":silent !echo "" > /tmp/output
  if ! $GVIM
    :silent !touch $FILE_WARP_TMP_PATH//$LEFT_PID/killf
    :q!
    :q!
  endif
endfunction

function QuitNav()
  if ! $GVIM
    if $panel == 'right'
      :let abs_dir = Read("$FILE_WARP_TMP_PATH/".$RIGHT_PID."/abs_dir")
      :exe '!setAbsDir $LEFT_PID '.abs_dir
    else
      ":let abs_dir = Read("$FILE_WARP_TMP_PATH/".$LEFT_PID."/abs_dir")
    endif
    :silent !touch $FILE_WARP_TMP_PATH/$LEFT_PID/kill
    :q!
    :q!
  endif
endfunction

function HideVimMode()
  ":set laststatus=0
  :set noshowmode
endfunction

function BackToNormal()
  :call SetNormalMode()
  :set insertmode
endfunction

function BackToNormalAndRefresh()
  :call SetNormalMode()
  :call feedkeys("\<F6>","t")
  :set insertmode
endfunction

function GetCurrPanelId()
  if $panel == 'left'
    :return $LEFT_PID
  else
    :return $RIGHT_PID
  endif
endfunction

function TogglePreview()
  if $panel == 'left'
    :let $left_preview = !$left_preview
  else
    :let $right_preview = !$right_preview
  endif
  ":tnoremap <C-u> <C-\><C-n>:call TogglePreview()<CR>
endfunction

function PreviewOn()
  if $panel == 'left'
    :tnoremap <C-u> <Nop>
    :tnoremap <C-A-u> <A-u><C-\><C-n>:call PreviewOff()<CR>
    "if $left_preview
      ":tnoremap <C-u> <C-\><C-n>:call PreviewOn()<CR>
      ":tnoremap <C-A-u> <A-u><C-\><C-n>:call PreviewOff()<CR>
    "else
      ":tnoremap <C-A-u> <A-u><C-\><C-n>:call PreviewOff()<CR>
    "endif
    :let $left_preview = 1
  else
    if $right_preview
      :tnoremap <C-u> <C-\><C-n>:call PreviewOn()<CR>
    else
      :tnoremap <C-u> <A-u><C-\><C-n>:call PreviewOn()<CR>
    endif
    :let $right_preview = 1
  endif
endfunction

function PreviewOff()
  if $panel == 'left'
    :tnoremap <C-A-u> <Nop>
    :tnoremap <C-u> <A-u><C-\><C-n>:call PreviewOn()<CR>

    "if $left_preview
      ":tnoremap <C-A-u> <A-u><C-\><C-n>:call PreviewOff()<CR>
    "else
      ":tnoremap <C-A-u> <C-\><C-n>:call PreviewOff()<CR>
    "endif
    :let $left_preview = 0
  else
    "if $right_preview
      ":tnoremap <C-u> <C-\><C-n>:call PreviewOn()<CR>
      ":
    "else
      ":tnoremap <C-u> <A-u><C-\><C-n>:call PreviewOn()<CR>
    "endif
    ":let $right_preview = 1
  endif
endfunction

function MenuOld(on_exit,items)
  :let items = a:items
  :let $str = ""
  :let i = 0
  for item in items
    :let $str .= item
    if i < len(items)-1
      :let $str .= '\n'
    endif
    :let i += 1
  endfor
  :call FloatCmd("echo $(echo -e $str | fzf) | xargs > /tmp/selection", {'w':0.5,'h':0.5,'on_exit': a:on_exit})
  ":call FloatCmd('export selection=$(trimWhitespace $(echo -e $str | fzf)) && servername=/tmp/vim$MYPID sendCommandToVim "call WriteFileType(\"$selection\")"', {'w':0.5,'h':0.5})
endfunction

function SetInsertMode2()
  :set insertmode
  :mapclear! <buffer>
endfunction
"=============================================================== navigation
function UpdatePath(...)
    if $panel == 'left'
      :let path=system("echo `getAbsDir $LEFT_PID`")
    else
      :let path=system("echo `getAbsDir $RIGHT_PID`")
    endif
    :let max_chars =  winwidth('%')-3
    if len(string(path)) > max_chars
      :let path = "...".path[len(path)-max_chars:len(path)]
    endif
    let path = substitute(path, "/host" , "", "g")
    :exe "setlocal statusline=".path
endfunction

function ChangeDir()
  if !exists('$panel')
    :let $panel = 'left'
  endif
  :let dir = CleanFilePath(Read("/tmp/output"))
  if $panel == 'left'
    :let pid = $LEFT_PID
  else
    :let pid = $RIGHT_PID
  endif
  :silent exe '!`setAbsDir '.pid.' '.dir.'`'
  :call UpdatePath()
  :call BackToNormalAndRefresh()
endfunction




function SetCurrPanelToLeft()
  if $panel == 'left'
    :return
  endif
  :let $panel='left'
  if $left_preview
    ":tnoremap <C-u> <Nop>
    ":tnoremap <C-A-u> <A-u><C-\><C-n>:call PreviewOff()<CR>
  else
    ":tnoremap <C-A-u> <Nop>
    ":tnoremap <C-u> <A-u><C-\><C-n>:call PreviewOn()<CR>
  endif

  ":let $LEFT_PID=$MYPID
  ":let $RIGHT_PID=1
  ":let $MYPID = $RIGHT_PID
  ":call feedkeys("\<F6>","t")
  ":call feedkeys("\<C-w>l","n")
endfunction

function SetCurrPanelToRight()
  if $num_panes < 2
    :return
  endif
  if $panel == 'right'
    :return
  endif
  :let $panel='right'
  if $right_preview
    :tnoremap <C-A-e> <A-u><C-\><C-n>:call RecentDirsThenNavSplit()<CR>
    ":tnoremap <C-u> <Nop>
    ":tnoremap <C-A-u> <A-u><C-\><C-n>:call PreviewOff()<CR>
  else
    ":tnoremap <C-A-u> <Nop>
    ":tnoremap <C-u> <A-u><C-\><C-n>:call PreviewOn()<CR>
  endif

  ":let $RIGHT_PID=1
  ":let $LEFT_PID=$MYPID
  ":let $RIGHT_PID=1
  ":let $MYPID = $RIGHT_PID
  ":call feedkeys("\<F6>")
  ":call feedkeys("\<C-w>l","n")
  :call SetNormalMode()
endfunction
"=============================================================== operations
function WatchDir()
  ":let border = execute("hi FloatermBorder","silent")
  :exe "te watch -c -d -n 1 ls -GAlFt  --color=always --time-style=+'\\%I:\\%M:\\%S' `getAbsDir ".GetCurrPanelId()."`"
  :let cmd = "watch -c -d -n 1 ls -GAlFt  --color=always --time-style=+'\\%I:\\%M:\\%S' `getAbsDir ".GetCurrPanelId()."`"
  ":sil exe 'hi '.border
endfunction

function NewDir()
  :call SetInsertMode()
  :call FloatCmd("newdir", {'w':0.5,'h':0.5,'on_exit':'BackToNormalAndRefresh'})
endfunction

function NewDirCd()
  :call SetInsertMode()
  :call FloatCmd("newdircd", {'w':0.5,'h':0.5,'on_exit':'BackToNormalAndRefresh'})
endfunction

function NewFile()
  :call SetInsertMode()
  :call FloatCmd("newfile", {'w':0.5,'h':0.5,'on_exit':'BackToNormalAndRefresh'})
endfunction

function NewFileType()
  :silent !echo "" > /tmp/output
  if $context == "home"
    :let menu_items = ["java","bash","python"]
  else
    :let menu_items = ["python","bash","java"]
  endif
  :call MenuOld("WriteFileType",menu_items)
endfunction

function WriteFileType(...)
"function WriteFileType(type)
  :call SetInsertMode2()
  ":call FloatCmd("newfiletype ".a:type, {'w':0.5,'h':0.5,'on_exit':'BackToNormalAndRefresh'})
  :call FloatCmd("newfiletype ".Read("/tmp/selection"), {'w':0.5,'h':0.5,'on_exit':'BackToNormalAndRefresh'})
endfunction

function CpRename()
  :call SetInsertMode()
  :call FloatCmd("cprename", {'w':0.5,'h':0.5,'on_exit':'BackToNormalAndRefresh'})
endfunction

function Rename()
  :call SetInsertMode()
  :call FloatCmd("filewarp-rename", {'w':0.5,'h':0.5,'on_exit':'BackToNormalAndRefresh'})
endfunction

function Counts()
  :call FloatCmd("counts", {'w':0.5,'h':0.5,'on_exit':'BackToNormal'})
endfunction

"TODO Own
function Perms()
  :let g:floaterm_title=system('echo `getName '.GetCurrPanelId().'`')
  :call MenuOld("ChangePerms",["-w","+w","+x","-x","775","777"])
endfunction

function ChangePerms()
  :let g:floaterm_title=""
  :exe '!perms '.string(GetCurrPanelId()).' '.Read("/tmp/selection")
  :call BackToNormalAndRefresh()
endfunction

function RecentDirsThenNavSplit()
":set eventignore=TermClose
  :call SetInsertMode()
  :let $go_back_left=1
  :call FloatCmd('. recentDirs "" "" "0"', {"on_exit":"SplitRight","w":0.9,"h":0.9})
endfunction

function RecentDirsThenNav()
  :call SetInsertMode()
  ":call FloatCmd('. recentDirs "setAbsDir 1 " "" "0"', {"on_exit":"ChangeDir","w":0.9,"h":0.9})
  :call FloatCmd('. recentDirs "" "" "0"', {"on_exit":"ChangeDir","w":0.9,"h":0.9})
endfunction

function MvTransfer()
:silent !mvtransfer $panel
if $panel == 'left'
    :call feedkeys("\<C-p>")
    :call feedkeys("\<F6>","n")
    :call feedkeys("\<C-q>")
  else
    :call feedkeys("\<C-q>")
    :call feedkeys("\<F6>","n")
    :call feedkeys("\<C-p>")
  endif
  :startinsert
endfunction

function CpTransfer()
  ":silent !cptransfer $panel
  ":call FloatCmd("cptransfer ".$panel,{'w':65,'h':4,'on_exit':'BackToNormal'})
   :call FloatCmd("cptransfer ".$panel,{'w':65,'h':5,'on_exit':'BackToNormal'})
  ":exe 'FloatermNew --width=65 --height=10 cptransfer '.$panel

  if $panel == 'left'
    ":call feedkeys("\<C-p>\<F6>\<C-q>",'t')
    ":call feedkeys("\<C-p>",'t')
    ":call feedkeys("\<F6>","t")
    ":call feedkeys("\<C-q>",'t')
  else
    ":call feedkeys("\<C-q>")
    ":call feedkeys("\<F6>","n")
    ":call feedkeys("\<C-p>")

    ":silent !xdotool key ctrl+q
    ":silent !xdotool key F6
    ":silent !xdotool key ctrl+p
  endif
  ":startinsert
  ":exe 'norm! \<C-w>l:silent !xdotool key F6\<CR>:startinsert\<CR>'
endfunction
"=============================================================== splits
function SplitRight()
  ":set eventignore=
  if $num_panes == 2
    :let $on_exit = ''
    :call ChangeDir()
    :return
  endif
  :let $num_panes = 2
  :tnoremap <C-A-e> <C-\><C-n>:call RecentDirsThenNavSplit()<CR>

  :let total_width=winwidth(0)
  :vsplit
  :exe 'vertical resize '. (total_width *1/2)
  :exe 'norm 12'
  "messing up status paths
  ":call feedkeys("\<C-w>l","n")

  :enew
  :let $panel = 'right'
  ":let $left_dir = CleanFilePath(Read("/tmp/output"))
  :let $right_dir = CleanFilePath(Read("/tmp/output"))
  :let $on_exit = 'BackToNormal'
  :let $LEFT_PID=$MYPID
  :let $RIGHT_PID=1
  :let $MYPID = $RIGHT_PID

  :silent exe '!`setAbsDir '.$RIGHT_PID.' '.$right_dir.'`'
  :call UpdatePath()


  ":call RunTerminalCmd('ProjTree4','OpenOnExit')
  :let $cmd_str = "on_enter='. changeDirectory' on_up='. navupr' on_open='open' on_exit='open' getList $MYPID | fzfnav2 '$MYPID' '$curr_dir' 'normal'"
  :exe 'te '.$cmd_str

  :let $left_preview = 0
  :let $right_preview = 0
  :if $go_back_left
    :let $panel = 'left'
    :let $go_back_left=0
    ":call feedkeys("\<C-w>h","n")
    :exe 'norm 11'
  endif
  :let $MYPID = $LEFT_PID
  :call BackToNormal()
endfunction

function SplitChild()
  if $num_panes == 2
    :return
  endif
  :let $RIGHT_PID=1
  :silent !$(setAbsDir $RIGHT_PID $(getAbsDir $LEFT_PID)/$(getName $LEFT_PID))
  :silent !echo $(getAbsDir $RIGHT_PID) > /tmp/output
  :call SplitRight()
endfunction

function SplitParent()
  if $num_panes == 2
    :return
  endif

  ":let $RIGHT_PID=1
  ":silent !$(setAbsDir $RIGHT_PID $(getAbsDir $LEFT_PID)/$(getName $LEFT_PID))
  ":silent !echo $(getAbsDir $RIGHT_PID) > /tmp/output
  :let parent = system("dirname $(getAbsDir $LEFT_PID)")
  :let total_width=winwidth(0)
  :vsplit
  :exe 'vertical resize '. (total_width *1/2)
  ":silent !touch /tmp/right
  ":e /tmp/right
  :enew
  :let $left_dir=parent
  :let $LEFT_PID=1
  :let $RIGHT_PID=$MYPID
  :let $MYPID = $LEFT_PID
  :call RunTerminalCmd('ProjTree4','OpenOnExit')
  ":let $cmd_str = "on_enter='. changeDirectory' on_up='. navupr' on_open='open' on_exit='open' getList $MYPID | fzfnav2 '$MYPID' '$curr_dir' 'normal'"
  ":exe 'te '.$cmd_str
  ":exe 'norm 12'
  ":call feedkeys("\<C-w>l","t")
  ":let $panel='right'
  :call SetNormalMode()
  :set insertmode
endfunction
"===============================================================

function TailConsole()
  :set laststatus=0
  :set noshowmode
  :silent exe '!touch $FILE_WARP_TMP_PATH/$MYPID/console'
  ":return "tail -f $FILE_WARP_TMP_PATH/$MYPID/console"
  :return "watch -n .5 cat $FILE_WARP_TMP_PATH//$MYPID/console"
endfunction

function ToggleConsole()
  if exists('g:console_open') && g:console_open
    :call CloseConsole()
  else
    :call OpenConsole()
  endif
endfunction

function CloseConsole()
  if exists('g:console_open') && g:console_open
    :let g:console_open=0
    :exe "norm! \<C-\>\<C-N>\<C-w>j"
    :exe "close!"
    :set laststatus=0
    ":exe "set insertmode"
    :exe "norm! i"
  else
    ":exe 'set insertmode'
    :exe "norm! i"
  endif
endfunction

function OpenConsole()
  if !exists('g:console_open') || !g:console_open
    :let total_height=winheight(0)
    ":call ShowStatusMessage("srien")
    ":top split
    :belowright split
    ":split
    :exe 'resize '. (total_height *1/8)
    :enew
    ":term
    ":exe 'norm!  \<C-\>\<C-N>\<C-w>k'
    ":exe 'norm!  \<C-w>\<C-k>i'
    :call RunTerminalCmd('TailConsole','')
    :set laststatus=0
    :set noshowmode
    :exe "norm! \<C-\>\<C-N>\<C-w>ki"
    :call ShowStatusMessage("console")
    :let g:console_open=1
  else
    ":exe 'set insertmode'
    :exe "norm! i"
  endif
endfunction


function GotoRoot()
  :let pid = $LEFT_PID
  :let dir = "/"
  :silent exe '!`setAbsDir '.pid.' '.dir.'`'
  :call UpdatePath()
  :call BackToNormalAndRefresh()
endfunction


function GotoProjRoot()
  :let pid = $LEFT_PID
  :silent !echo $(getAbsDir $LEFT_PID) > /tmp/output
  :let curr_dir = CleanFilePath(Read("/tmp/output"))
  :silent exe '!getProjRootPath '.curr_dir.' > /tmp/output'
  :let proj_root = CleanFilePath(Read("/tmp/output"))
  :silent exe '!`setAbsDir '.pid.' '.proj_root.'`'
  :call UpdatePath()
  :call BackToNormalAndRefresh()
endfunction
