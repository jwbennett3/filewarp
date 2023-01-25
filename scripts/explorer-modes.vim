
"function ExitEasyMotion()
  ":let $on_exit = 'OpenOnExit'
  "::silent exe '!echo '.string(11111).' >> /tmp/deb'
"endfunction


function! SetEasyMotion()
  :let $on_exit = ''
  ":tnoremap q <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>q
  ":tnoremap w <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>w
  ":tnoremap f <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>f
  ":tnoremap p <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>p
  ":tnoremap g <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>g
  ":tnoremap j <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>j
  ":tnoremap l <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>l
  ":tnoremap u <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>u
  ":tnoremap y <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>y
  ":tnoremap a <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>a
  ":tnoremap r <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>r
  ":tnoremap s <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>s
  ":tnoremap t <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>t
  ":tnoremap d <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>d
  ":tnoremap h <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>h
  ":tnoremap n <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>n
  ":tnoremap e <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>e
  ":tnoremap i <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>i
  ":tnoremap o <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>o
  ":tnoremap z <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>z
  ":tnoremap x <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>x
  ":tnoremap c <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>c
  ":tnoremap v <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>v
  ":tnoremap b <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>b
  ":tnoremap k <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>k
  ":tnoremap m <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>m

  ":tnoremap Q <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>Q
  ":tnoremap W <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>W
  ":tnoremap F <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>F
  ":tnoremap P <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>p
  ":tnoremap G <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>G
  ":tnoremap J <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>J
  ":tnoremap L <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>L
  ":tnoremap U <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>U
  ":tnoremap Y <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>Y
  ":tnoremap A <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>A
  ":tnoremap R <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>R
  ":tnoremap S <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>S
  ":tnoremap T <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>T
  ":tnoremap D <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>D
  ":tnoremap H <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>H
  ":tnoremap N <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>N
  ":tnoremap E <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>E
  ":tnoremap I <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>I
  ":tnoremap O <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>O
  ":tnoremap Z <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>Z
  ":tnoremap X <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>X
  ":tnoremap C <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>C
  ":tnoremap V <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>V
  ":tnoremap B <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>B
  ":tnoremap K <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>K
  ":tnoremap M <C-\><C-n>:let $on_exit = 'ExitEasyMotion'<CR>:set noinsertmode<CR>:call BackToNormal()<CR>M

  :tnoremap q <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>q
  :tnoremap w <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>w
  :tnoremap f <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>f
  :tnoremap p <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>p
  :tnoremap g <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>g
  :tnoremap j <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>j
  :tnoremap l <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>l
  :tnoremap u <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>u
  :tnoremap y <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>y
  :tnoremap a <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>a
  :tnoremap r <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>r
  :tnoremap s <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>s
  :tnoremap t <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>t
  :tnoremap d <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>d
  :tnoremap h <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>h
  :tnoremap n <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>n
  :tnoremap e <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>e
  :tnoremap i <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>i
  :tnoremap o <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>o
  :tnoremap z <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>z
  :tnoremap x <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>x
  :tnoremap c <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>c
  :tnoremap v <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>v
  :tnoremap b <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>b
  :tnoremap k <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>k
  :tnoremap m <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>m

  :tnoremap Q <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>Q
  :tnoremap W <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>W
  :tnoremap F <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>F
  :tnoremap P <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>p
  :tnoremap G <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>G
  :tnoremap J <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>J
  :tnoremap L <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>L
  :tnoremap U <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>U
  :tnoremap Y <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>Y
  :tnoremap A <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>A
  :tnoremap R <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>R
  :tnoremap S <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>S
  :tnoremap T <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>T
  :tnoremap D <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>D
  :tnoremap H <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>H
  :tnoremap N <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>N
  :tnoremap E <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>E
  :tnoremap I <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>I
  :tnoremap O <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>O
  :tnoremap Z <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>Z
  :tnoremap X <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>X
  :tnoremap C <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>C
  :tnoremap V <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>V
  :tnoremap B <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>B
  :tnoremap K <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>K
  :tnoremap M <C-\><C-n>:set noinsertmode<CR>:call BackToNormal()<CR>M
endfunction

function! SetNormalMode()
  ":tnoremap <C-q> <C-\><C-N>:let $panel='left'<CR><C-w>h:silent !xdotool key F6<CR>:startinsert<CR>
  ":tnoremap <C-q> <C-\><C-N>:let $panel='left'<CR><C-w>h:call feedkeys("\<F6>"):startinsert<CR>
  :tnoremap <C-q> <C-\><C-N>:set noinsertmode<CR><C-w>h:call SetCurrPanelToLeft()<CR>:set insertmode<CR>
  ":tnoremap <C-p> <C-\><C-N>:let $panel='right'<CR><C-w>l:silent !xdotool key F6<CR>:startinsert<CR>
  ":tnoremap <C-p> <C-\><C-N>:let $panel='right'<CR><C-w>l:call feedkeys("\<F6>"):startinsert<CR>

  :tnoremap <C-p> <C-\><C-N>:set noinsertmode<CR><C-w>l:call SetCurrPanelToRight()<CR>:set insertmode<CR>

  ":tnoremap <C-p> <C-\><C-N><C-w>l:call SetCurrPanelToRight()<CR>
  ":tnoremap <C-p> <C-w>l<C-\><C-N>:call SetCurrPanelToRight()<CR>

  ":tnoremap <C-p> <C-\><C-N><C-w>l:call SetCurrPanelToRight()<CR>

  :tnoremap <silent> <A-Space> <F4>
  :nnoremap 11 <C-w>h
  :nnoremap 12 <C-w>l
  :nnoremap 13 <F6>
  :nnoremap 14 <A-u>

  :tnoremap <A-S-c> <A-c>
  :tnoremap <C-A-n> <C-\><C-n>:call SplitParent()<CR>
  if $num_panes != 2
    :tnoremap <C-A-e> <A-u><C-\><C-n>:call RecentDirsThenNavSplit()<CR>
  endif
  :tnoremap <C-e> <C-\><C-n>:call RecentDirsThenNav()<CR>
  :tnoremap <C-A-o> <C-\><C-n>:call SplitChild()<CR>
  :tnoremap <Space> <C-\><C-n>:set noinsertmode<CR>:call SetInsertMode()<CR>:set insertmode<CR><f11>
  :tnoremap <C-Space> <C-\><C-n>:set noinsertmode<CR>:call SetNormalMode()<CR>:set insertmode<CR><f10>

  :tnoremap <C-u> <A-u><C-\><C-n>:call TogglePreview()<CR>
  :tnoremap <C-A-u> <A-u><C-\><C-n>:call PreviewOff()<CR>
  :tnoremap <C-l> <A-l>
  :tnoremap <C-d> <A-d>


  if $GVIM
    :tnoremap <ESC> di<Return>
    :tnoremap <LocalLeader>q di<Return>
    :tnoremap <Leader>q di<Return>
  else
    :tnoremap <Leader>q <C-\><C-n>:set noinsertmode<CR>:call FQuitNav()<CR>
    :tnoremap <LocalLeader>q <C-\><C-n>:set noinsertmode<CR>:call QuitNav()<CR>
  endif

  :tnoremap <LocalLeader>i <C-\><C-n>:set noinsertmode<CR>:call SetInsertMode()<CR>:set insertmode<CR><C-A-i>

  :tnoremap <f5> <f5>

  :tnoremap q <Nop>
  :tnoremap w <C-\><C-n>:call WatchDir()<CR>
  :tnoremap <C-w> <A-w>
  :tnoremap p <F6><C-\><C-n>:call CpRename()<CR>
  :tnoremap P <F6><C-\><C-n>:call Rename()<CR>
  :tnoremap <silent> g <C-\><C-n>:call ToggleConsole()<CR>
  :tnoremap j <Nop>
  :tnoremap l <C-\><C-n>:call CpTransfer()<CR>
  :tnoremap u <Nop>
  :tnoremap y <Nop>
  "not working
  :tnoremap a <C-\><C-N>:set noinsertmode<CR><C-w>l<C-n><CR>:set insertmode<CR>
  :tnoremap r <C-R>
  ":tnoremap R <C-A-R>
  :tnoremap Þ <C-A-R>
  :tnoremap s <C-s>
  ":tnoremap S <C-A-s>
  :tnoremap “ <C-A-s>
  :tnoremap t <Nop>
  :tnoremap d <Nop>
  :tnoremap h <Nop>
  ":tnoremap n <C-\><C-n>:sil call GoUp()<CR>
  :tnoremap n <C-n><C-\><C-n>:sil call timer_start(100, 'UpdatePath')<CR>
  ":tnoremap n <C-n>
  :tnoremap e <C-e>
  :tnoremap i <C-i>
  :tnoremap o <C-o><C-\><C-n>:sil call timer_start(100, 'UpdatePath')<CR>
  ":tnoremap o <C-o>
  :tnoremap <C-o> <C-\><C-n>:set noinsertmode<CR>:call SetEasyMotion()<CR>:set insertmode<CR><C-h>
  :tnoremap E <C-\><C-n>:set noinsertmode<CR>:call SetEasyMotion()<CR>:set insertmode<CR><C-h>
  :tnoremap I <C-\><C-n>:set noinsertmode<CR>:call SetEasyMotion()<CR>:set insertmode<CR><C-h>
  ":tnoremap z <F7>
  :tnoremap z <Nop>
  :tnoremap x <Nop>
  :tnoremap c <C-\><C-n>:call MvTransfer()<CR>
  :tnoremap v <Nop>
  :tnoremap <C-b> <A-b>
  :tnoremap b <C-b>
  :tnoremap B <C-A-b>
  :tnoremap <C-k> <C-d>
  :tnoremap <C-A-k> <C-\><C-n>:call NewDir()<CR>
  :tnoremap <A-S-o> <C-\><C-n>:call NewDirCd()<CR>
  :tnoremap K <C-\><C-n>:call NewFile()<CR>
  :tnoremap k <C-\><C-n>:call NewFileType()<CR>
  :tnoremap m <F7><C-\><C-n>:set noinsertmode<CR>:call Perms()<CR>
  :tnoremap ; <F7><C-\><C-n>:call Counts()<CR>

  ":tnoremap E <A-e>
  :tnoremap <A-S-E> <A-e>
  ":tnoremap I <A-i>
  :tnoremap <A-S-I> <A-i>
  :tnoremap <LocalLeader>e <C-A-e>
  :tnoremap <LocalLeader>i <C-A-i>

  :tnoremap <A-q> q
  :tnoremap <A-w> w
  :tnoremap <A-f> f
  :tnoremap <A-p> p
  "dead key
  ":tnoremap <A-g> g
  :tnoremap ö g
  :tnoremap <A-j> j
  :tnoremap <A-l> l
  :tnoremap <A-u> u
  :tnoremap <A-y> y
  :tnoremap <A-a> a
  :tnoremap <A-r> r
  :tnoremap <A-s> s
  :tnoremap <A-t> t
  :tnoremap <A-d> d
  :tnoremap <A-h> h
  :tnoremap <A-n> n
  :tnoremap <A-e> e
  :tnoremap <A-i> i
  :tnoremap <A-o> o
  :tnoremap <A-z> z
  :tnoremap <A-x> x
  :tnoremap <A-c> c
  :tnoremap <A-v> v
  :tnoremap <A-b> b
  :tnoremap <A-k> k
  :tnoremap <A-m> m
  :tnoremap <A-.> .

  :tnoremap ä q
  :tnoremap å w
  :tnoremap ã f
  :tnoremap ø p
  :tnoremap ð a
  :tnoremap þ r
  :tnoremap ‘ s
  :tnoremap ’ t
  :tnoremap ł d
  :tnoremap æ z
  :tnoremap đ x
  :tnoremap ç c
  :tnoremap œ v
  :tnoremap ħ b
endfunction

