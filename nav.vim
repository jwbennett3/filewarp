let mapleader = "dd"
let maplocalleader = "d"

let g:python3_host_prog="/usr/bin/python"
"source /inst/plug.vim
"call plug#begin('/inst/vim-extensions')
"Plug 'voldikss/vim-floaterm'      "floating terminal window
"call plug#end()

set rtp+=/usr/bin/vim-floaterm
source /usr/bin/vim-floaterm/plugin/floaterm.vim

set shada="NONE"
source $NVIMHOME/lib.vim
source $NVIMHOME/lib2.vim

let g:floaterm_autoclose=2
let g:floaterm_borderchars=""
let g:floaterm_title=""

:mapclear! <buffer>
:set timeoutlen=200

"--------------------------------------------------
" IPC support for vim-com RPC
"--------------------------------------------------
function! s:ProcessIpcCmd(server_address, cmd)
  if a:cmd =~# '^lua '
    let l:lua_cmd = substitute(a:cmd, '^lua ', '', '')
    try
      exe 'lua ' . l:lua_cmd
      let l:output = ''
    catch
      let l:output = v:exception
    endtry
  else
    try
      exe a:cmd
      let l:output = ''
    catch
      let l:output = v:exception
    endtry
  endif
  call writefile([l:output], a:server_address . '/output')
  call system('rm -f ' . a:server_address . '/output_lock')
endfunction

function! StartIpc()
  let g:vimcom_root = $VIMCOM_ROOT
  if g:vimcom_root ==# ''
    let g:vimcom_root = '/tmp/tmp/var/vim-com'
  endif
  let s:server_address = g:vimcom_root . '/filewarp'
  call mkdir(s:server_address, 'p')
  if exists('g:ipc_job_id')
    call jobstop(g:ipc_job_id)
  endif
  let g:ipc_job_id = jobstart(['vimSocket', s:server_address], {
    \ 'on_stdout': {_, data -> s:ProcessIpcCmd(s:server_address, data[0])},
    \ 'on_stderr': {_, data -> s:ProcessIpcCmd(s:server_address, data[0])}
    \ })
endfunction

function! OpenOnExit()
  ":call SetInsertMode()
  ":set noinsertmode
  ":let $output = Read("/tmp/output")
  ":silent !echo "" > /tmp/output
  "if $output[0] == "#"
    ":let $output = $output[1:]
  "endif
  "if ! IsFile("/tmp/kill".$MYPID) &&$output != "" && $output != $file_path && filereadable($output) && @% != ""
    ":edit $output
  "else
    ":exe 'q!'
  "endif
endfunction

function! ClearNoname()
  if $on_exit != ""
    if buffer_name() == ""
      :bd!
    endif
    :call SetInsertMode()
    :set noinsertmode
    :if $on_exit != "Exit"
      :let BuildCmd = function($on_exit)
      :let $on_exit = ""
      :call BuildCmd()
    else
      :set noinsertmode
      :let $on_exit = ""
    endif
  endif
endfunction

function! RemoveIfDoesNotExist()
  if !StringContains(buffer_name(),"term") && buffer_name() != "" && !Exists(GetFilePath())
    :bd!
  endif
endfunction


source $NVIMHOME/scripts/explorer-script.vim
source $NVIMHOME/scripts/explorer-modes.vim
source $NVIMHOME/scripts/terminal-lib.vim
source $NVIMHOME/scripts/persistence.vim

:tnoremap <Esc> <C-\><C-n>
:tnoremap ' <C-\><C-n>:
:tnoremap ! <C-\><C-n>:!
:cnoremap <Insert>e $

:cnoremap <A-e> <C-n>
:cnoremap <A-i> <C-p>

:cnoremap <C-e> <C-n>
:cnoremap <C-s> <C-p>

function Quit(...)
  :exe 'q!'
endfunction



augroup nav
  au!
    autocmd TermEnter * set insertmode
    autocmd TermOpen * startinsert
    autocmd TermLeave * call ClearNoname()
    autocmd TermLeave,BufEnter,FocusLost,FocusGained * call RemoveIfDoesNotExist()
    autocmd TermClose * if StringContains(buffer_name(),"navdown") | q! | endif
    autocmd TermClose * if StringContains(buffer_name(),"fzfnav2") | q! | endif
    autocmd TermClose * if StringContains(buffer_name(),"watch") | call feedkeys('\<CR>') | endif
augroup END
:call HideVimMode()
if $mode == "insert"
  call SetInsertMode()
else
  call SetNormalMode()
endif

let g:skip_post = 1

call UpdatePath()
if $START_IPC != ""
  call StartIpc()
endif
