

function SetNavigationBindings(mode)
"#########################################################################
if a:mode ==# 'readonly'
":nnoremap f :set noreadonly<CR>:call SetReadOnly()<CR>

:nnoremap <ESC> <Nop>

:noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(g:comfortable_motion_mouse_impulse_multiplier * winheight(0) * 2)<CR>
:noremap <silent> <ScrollWheelUp> :call comfortable_motion#flick(g:comfortable_motion_mouse_impulse_multiplier * winheight(0) * -2)<CR>

"=============================================================== right
"horizontal scroll
:nnoremap <silent> n :exe 'norm! '.string(float2nr(round(winwidth(0)*0.25))).'zh'<CR>
:nnoremap <silent> e :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
:nnoremap <silent> i :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
:nnoremap <silent> o :exe 'norm! '.string(float2nr(round(winwidth(0)*0.25))).'zl'<CR>



"------------------------------------------------- easymotion
":nnoremap <silent> N <C-w>l<C-w>j:call NavSearchRightRFinal()<CR>
":nnoremap <silent> E <C-w>l<C-w>j:call NavSearchDownRFinal()<CR>
":nnoremap <silent> I <C-w>l<C-w>j:call NavSearchUpRFinal()<CR>
":nnoremap <silent> O <C-w>l<C-w>j:call NavSearchLeftRFinal()<CR>

":nnoremap N :call NavSearchHoriz('r',1)<CR>
":nnoremap E :call NavSearchVert('r',0)<CR>
":nnoremap I :call NavSearchVert('r',1)<CR>
":nnoremap O :call NavSearchHoriz('r',0)<CR>
"-------------------------------------------------


":nnoremap <A-S-n> h
:nnoremap <silent> <A-S-e> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 10)<CR>
:nnoremap <silent> <A-S-i> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -10)<CR>
":nnoremap <A-S-o> l

"=============================================================== left
:nnoremap a h
:nnoremap r j
:nnoremap s k
:nnoremap t l


:nnoremap <silent> <LocalLeader>e :call comfortable_motion#flick(GetNumLinesInBuffer()*7)<CR>
:nnoremap <silent> <LocalLeader>i :call comfortable_motion#flick(GetNumLinesInBuffer()*-7)<CR>


":nnoremap e <C-d>
":nnoremap i <C-u>

"horizontal scroll

":nnoremap <LocalLeader>n 0
":nnoremap <LocalLeader>o :exe 'norm! '.GetMaxWidth().'zl'<CR>

:nnoremap <LocalLeader>n 0
:nnoremap <LocalLeader>o :exe 'norm! '.GetMaxWidth().'zl'<CR>


:nnoremap <Space> <Nop>
"#########################################################################
elseif a:mode ==# 'readwrite'
:nnoremap <Space>f :set readonly<CR>:call SetReadOnly()<CR>
:nnoremap <ESC> <Nop>

:nnoremap <silent> <Space><Insert> :call IMatchIndent()<CR>i
:nnoremap <silent> <Insert><Space> :call IMatchIndent()<CR>i
:nnoremap p r
"=============================================================== line nav
":nnoremap <silent> f :call NavRightForward()<CR>
"=============================================================== right

"------------------------------------------------- block
":nnoremap <silent> n <c-w>l<c-w>j:call BlockNavOutRFinal()<CR>
":nnoremap <silent> e <C-w>l<C-w>j:call BlockNavDownRFinal()<CR>
":nnoremap <silent> i <C-w>l<C-w>j:call BlockNavUpRFinal()<CR>
":nnoremap <silent> o <C-w>l<C-w>j:call BlockNavInRFinal()<CR>

":nnoremap <silent> <LocalLeader>n <c-w>l<c-w>j:call BlockNavRootRFinal()<CR>
":nnoremap <silent> <LocalLeader>e <C-w>l<C-w>j:call BlockNavBottonRFinal()<CR>
":nnoremap <silent> <LocalLeader>i <C-w>l<C-w>j:call BlockNavTopRFinal()<CR>
":nnoremap <silent> <LocalLeader>o <C-w>l<C-w>j:call BlockNavLeafRFinal()<CR>

":nnoremap <silent> <Leader>n <c-w>l<c-w>j:call FoldAll2()<CR>
":nnoremap <silent> <Leader>e <C-w>l<C-w>j:call NavEndDocR()<CR>
":nnoremap <silent> <Leader>i <C-w>l<C-w>j:call NavBeginningDocR()<CR>
":nnoremap <silent> <Leader>o <C-w>l<C-w>j:call UnfoldAllBelow2()<CR>


"------------------------------------------------- easymotion

":nnoremap <silent> N <C-w>l<C-w>j:call NavSearchRightRFinal()<CR>
":nnoremap <silent> E <C-w>l<C-w>j:call NavSearchDownRFinal()<CR>
":nnoremap <silent> I <C-w>l<C-w>j:call NavSearchUpRFinal()<CR>
":nnoremap <silent> O <C-w>l<C-w>j:call NavSearchLeftRFinal()<CR>

"------------------------------------------------- word
":nnoremap <silent> <A-S-n> <c-w>l<c-w>j:silent call NavLeftWordRFinal()<CR>

":nnoremap <silent> <A-S-e> <C-w>l<C-w>j:let b:jumplist_disabled = 1<CR>::let b:jumplist_disabled = 0<CR>:call SetCursorR()<CR>
":nnoremap <silent> <A-S-i> <C-w>l<C-w>j:let b:jumplist_disabled = 1<CR>:let b:jumplist_disabled = 0<CR>call SetCursorR()<CR>

":nnoremap <silent> <A-S-e> <C-w>l<C-w>j:call SetCursorR()<CR>
":nnoremap <silent> <A-S-i> <C-w>l<C-w>j:call SetCursorR()<CR>

":nnoremap <silent> <A-S-o> <C-w>l<C-w>j:call NavRightWordRFinal()<CR>

":inoremap <silent> <A-S-n> <ESC><c-w>l<c-w>j:silent call NavLeftWordRFinal()<CR>i
":inoremap <silent> <A-S-e> <ESC><C-w>l<C-w>j:call SetCursorR()<CR>i
":inoremap <silent> <A-S-i> <ESC><C-w>l<C-w>j:call SetCursorR()<CR>i
":inoremap <silent> <A-S-o> <ESC><C-w>l<C-w>j:call NavRightWordRFinal()<CR>i



"------------------------------------------------- end line
":nnoremap <silent> DN <C-w>l<C-w>j:call NavBeginningLineRFinal()<CR>
"TODO these two probably aren't needed anymore
":nnoremap <silent> DE <C-w>l<C-w>j:call NavEndDocR()<CR>:call SetCursorRAndJump()<CR>
":nnoremap <silent> DI <C-w>l<C-w>j:call NavBeginningDocR()<CR>:call SetCursorRAndJump()<CR>
:nnoremap <silent> DE :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 5)<CR>
:nnoremap <silent> DI :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -5)<CR>
":nnoremap <silent> DO <C-w>l<C-w>j:call NavEndLineRFinal()<CR>

":nnoremap <silent> DDN 0:call SetCursorR()<CR>
":nnoremap <silent> DDO :call UpdateCursorR()<CR>g_a

"=============================================================== left
"------------------------------------------------- block
":nnoremap <silent> a <c-w>h<c-w>k:call BlockNavOutLFinal()<CR>
":nnoremap <silent> r <C-w>h<C-w>k:call BlockNavDownLFinal()<CR>
":nnoremap <silent> s <C-w>h<C-w>k:call BlockNavUpLFinal()<CR>
":nnoremap <silent> t <C-w>h<C-w>k:call BlockNavInLFinal()<CR>

":nnoremap <silent> <LocalLeader>a <c-w>h<c-w>k:call BlockNavRootLFinal()<CR>
":nnoremap <silent> <LocalLeader>r <C-w>h<C-w>k:call BlockNavBottonLFinal()<CR>
":nnoremap <silent> <LocalLeader>s <C-w>h<C-w>k:call BlockNavTopLFinal()<CR>
":nnoremap <silent> <LocalLeader>t <C-w>h<C-w>k:call BlockNavLeafLFinal()<CR>

":nnoremap <silent> <Leader>a <c-w>h<c-w>k:call FoldAll2()<CR>
":nnoremap <silent> <Leader>r <C-w>h<C-w>k:call NavEndDocL()<CR>
":nnoremap <silent> <Leader>s <C-w>h<C-w>k:call NavBeginningDocL()<CR>
":nnoremap <silent> <Leader>t <C-w>h<C-w>k:call UnfoldAllBelow2()<CR>

"------------------------------------------------- easymotion
":nnoremap <silent> A <C-w>h<C-w>k:silent call NavSearchHoriz('l',1)<CR>
":nnoremap <silent> R <C-w>h<C-w>k:silent call NavSearchVert('l',0)<CR>
":nnoremap <silent> S <C-w>h<C-w>k:silent call NavSearchVert('l',1)<CR>
":nnoremap <silent> T <C-w>h<C-w>k:silent call NavSearchHoriz('l',0)<CR>

"------------------------------------------------- word
":nnoremap <silent> Ð :call NavLeftWordL()<CR>
":nnoremap <silent> Þ <C-w>h<C-w>k:call SetCursorL()<CR>
":nnoremap <silent> “ <C-w>h<C-w>k:call SetCursorL()<CR>
":nnoremap <silent> ” :call NavRightWordL()<CR>

":inoremap <silent> Ð <ESC>:call NavLeftWordL()<CR>i
":inoremap <silent> Þ <ESC><C-w>h<C-w>k:call SetCursorL()<CR>i
":inoremap <silent> “ <ESC><C-w>h<C-w>k:call SetCursorL()<CR>i
":inoremap <silent> ” <ESC>:call NavRightWordL()<CR>i


"------------------------------------------------- end line
":nnoremap <silent> HA :call NavBeginningLineL()<CR>:call SetCursorLAndJump()<CR>
:nnoremap <silent> HR :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 5)<CR>
:nnoremap <silent> HS :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -5)<CR>
":nnoremap <silent> HT :call NavEndLineL()<CR>:call SetCursorLAndJump()<CR>

:nnoremap HHA 0:call SetCursorL()<CR>
:nnoremap HHT :call UpdateCursorL()<CR>g_a

"#########################################################################
elseif a:mode ==# 'debug'
:nnoremap <ESC> :<C-u>call StopDebugging()<CR>


:nnoremap n :call SendDbgCmd('stepOut()')<CR>
:nnoremap e :call SendDbgCmd('stepOver()')<CR>
:nnoremap i :call SendDbgCmd('popStack()')<CR>

:nnoremap o :call SendDbgCmd('stepInto()')<CR>

:nnoremap <C-n> :call SendDbgCmd('callStackDown()')<CR>
:nnoremap <C-o> :call SendDbgCmd('callStackUp()')<CR>

:nnoremap p :call SendDbgCmd('resume()')<CR>
:nnoremap f :sil !showCallStack &<CR>

":nnoremap a <Nop>
":nnoremap r <Nop>
":nnoremap s <Nop>
":nnoremap t <Nop>

":nnoremap :call FocusVars()<CR>
 :nnoremap <silent> " :sil !wmctrl -a vars<CR>
 :nnoremap <silent> O :sil !wmctrl -a vars<CR>

"#########################################################################
endif
endfunction





