let mapleader = "dd"
let maplocalleader = "d"

set shada="NONE"

let g:python3_host_prog="/usr/bin/python"
"source /usr/bin/plug.vim
"call plug#begin('/inst/vim-extensions')
"Plug 'voldikss/vim-floaterm'      "floating terminal window
"call plug#end()
set rtp+=/usr/bin/vim-floaterm
source /usr/bin/vim-floaterm/plugin/floaterm.vim

let $NVIMHOME="/usr/bin"
source $NVIMHOME/lib.vim
source $NVIMHOME/lib2.vim

let g:floaterm_autoclose=2
let g:floaterm_borderchars=""
let g:floaterm_title=""

:mapclear! <buffer>
:set timeoutlen=200

function QuitFromMain()
  "all of these are needed .. not sure why
  :q!
  :q!
  :q!
endfunction

function! ProjTreeFromTerminal(curr_dir,mode)
  :enew
  :call HideVimMode()
  :set laststatus=0
  :let $panel='left'
  :let $LEFT_PID=$MYPID
  :let $curr_dir = a:curr_dir
  :let $mode = a:mode
  :sil exe "!setAbsDir $MYPID $curr_dir"
  :let $cmd_str = "on_enter='. changeDirectory' on_up='. navupr' on_open='' getList $MYPID | on_exit='$on_exit_nav' fzfnav2 '$MYPID' '$curr_dir' '$mode'"
  :let $on_exit = 'Quit'
  :let options = "{'on_exit':'Quit'}"
  :set statusline=$curr_dir
  :call FloatCmd('nvim -u $NVIMHOME/nav.vim -c "call termopen(\"'.$cmd_str.'\",'.options.')"')
endfunction


source $NVIMHOME/scripts/explorer-script.vim
source $NVIMHOME/scripts/terminal-lib.vim
source $NVIMHOME/scripts/persistence.vim


augroup nav2
  au!
    autocmd TermClose * call QuitFromMain()
augroup END
:mapclear!
:let g:skip_post = 1


