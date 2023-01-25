

"function! ExitTerminalMode(direction)
function! ExitTerminalMode(...)
  :colorscheme delek
  ":if a:direction == 'top'
    :exe 'norm! gg'
  "else
    ":exe 'norm! G'
  "endif
  :call SetCursor()
endfunction


function! SetInsertMode()
  ":set noinsertmode
  ":tnoremap <silent> <A-Space> <F4>
  ":tnoremap <Space> <Space>
  ":tnoremap <C-e> <C-\><C-n>:call SplitRight()<CR>
  ":tnoremap <C-Space> <C-Space>
  :tnoremap <C-u> <C-u>
  :tnoremap <C-l> <C-l>
  :tnoremap <C-n> <C-n>
  :tnoremap <C-e> <C-e>
  :tnoremap <C-o> <C-o>

  :tnoremap <Space> <Space>

  :tnoremap O O
  ":tnoremap <LocalLeader>q <LocalLeader>q
  :tnoremap <LocalLeader>i <LocalLeader>i
  :tnoremap 8 8

  :tnoremap N N
  :tnoremap E E
  :tnoremap B B
  :tnoremap <LocalLeader>n <LocalLeader>n
  :tnoremap <LocalLeader>e <LocalLeader>e

  :tnoremap q q
  :tnoremap w w
  :tnoremap f f
  :tnoremap p p
  :tnoremap g g
  :tnoremap j j
  :tnoremap l l
  :tnoremap u u
  :tnoremap y y
  :tnoremap a a
  :tnoremap r r
  :tnoremap s s
  :tnoremap t t
  :tnoremap d d
  :tnoremap h h
  :tnoremap n n
  :tnoremap e e
  :tnoremap i i
  :tnoremap o o
  :tnoremap z z
  :tnoremap x x
  :tnoremap c c
  :tnoremap v v
  :tnoremap b b
  :tnoremap k k
  :tnoremap m m

  :tnoremap Q Q
  :tnoremap W W
  :tnoremap F F
  :tnoremap P P
  :tnoremap G G
  :tnoremap J J
  :tnoremap L L
  :tnoremap U U
  :tnoremap Y Y
  :tnoremap A A
  :tnoremap R R
  :tnoremap S S
  :tnoremap T T
  :tnoremap D D
  :tnoremap H H
  :tnoremap N N
  :tnoremap E E
  :tnoremap I I
  :tnoremap O O
  :tnoremap Z Z
  :tnoremap X X
  :tnoremap C C
  :tnoremap V V
  :tnoremap B B
  :tnoremap K K
  :tnoremap M M


  :tnoremap ä ä
  :tnoremap å å
  :tnoremap ã ã
  :tnoremap ø ø
  :tnoremap ð ð
  :tnoremap þ þ
  :tnoremap ‘ ‘
  :tnoremap ’ ’
  :tnoremap ł ł
  :tnoremap æ æ
  :tnoremap đ đ
  :tnoremap ç ç
  :tnoremap œ œ
  :tnoremap ħ ħ

endfunction

function! FloatCmd(cmd_str,...)
  :let w = '1.0'
  :let h = '1.0'
  ":let w = '0.7'
  ":let h = '0.7'
  :let title = ''
  :let $on_exit = ""
    if a:0 >0
      :let opts = a:1

      if has_key(opts, 'w')
        :let w = string(opts['w'])
      endif

      if has_key(opts, 'h')
        :let h = string(opts['h'])
      endif

      if has_key(opts, 'title')
        :let title = opts['title']
      endif

      if has_key(opts, 'on_exit')
        :let $on_exit = opts['on_exit']
      endif
    endif
    if title ==# ''
      :exe 'FloatermNew --width='.w.' --height='.h.' '.a:cmd_str
    else
      :exe 'FloatermNew --title='.title.' --width='.w.' --height='.h.' '.a:cmd_str
    endif
    "lua require('FTerm').scratch({ cmd = "'".a:cmd_str."'" })
    ":exe 'lua require("FTerm").run('.a:cmd_str.')'
    ":exe 'lua require("FTerm").run('.cmd_str.')'
endfunction



"function! SetTerminalExitBindings(direction)
  ":tnoremap h <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>
  ":tnoremap n <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>
  ":tnoremap e <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>
  ":tnoremap i <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>

  ":tnoremap H <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>
  ":tnoremap N <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>
  ":tnoremap E <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>
  ":tnoremap I <C-\><C-n>:call ExitTerminalMode(a:direction)<CR>

  ":tnoremap d <C-\><C-n>:call ExitTerminalMode()<CR>:q!<CR>

  ":tnoremap h <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap n <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap e <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap i <C-\><C-n>:call ExitTerminalMode()<CR>

  ":tnoremap H <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap N <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap E <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap I <C-\><C-n>:call ExitTerminalMode()<CR>

  ":tnoremap n <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap e <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap i <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap o <C-\><C-n>:call ExitTerminalMode()<CR>

  ":tnoremap N <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap E <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap I <C-\><C-n>:call ExitTerminalMode()<CR>
  ":tnoremap O <C-\><C-n>:call ExitTerminalMode()<CR>

"endfunction
