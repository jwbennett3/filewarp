
"from https://stackoverflow.com/questions/10534130/how-do-you-increase-a-number-directly-under-the-cursor
function! IncrementChar()
  :let c = g:GetCharUnderCursor()
  :let g:y=c
  if g:IsAlpha(c)
    let char = "\<C-a>"
    let back = ""
    let pattern = &nrformats =~ 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
    call search(pattern, 'cw' . back)
    execute 'normal! ' . v:count1 . char
    silent! call repeat#set(":\<C-u>call AddSubtract('" .char. "', '" .back. "')\<CR>")
  else
    :let c=GetCharUnderCursor()
    :let n=str2nr(c)+1
    :call SetCharUnderCursor(string(n))
  endif
endfunction

function! DecrementChar()
  :let c = g:GetCharUnderCursor()
  :let g:y=c
  if g:IsAlpha(c)
   :let g:s=9
  let char = "\<C-x>"
  let back = ""
  let pattern = &nrformats =~ 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
  call search(pattern, 'cw' . back)
  execute 'normal! ' . v:count1 . char
  silent! call repeat#set(":\<C-u>call AddSubtract('" .char. "', '" .back. "')\<CR>")
  else
   :let c=g:GetCharUnderCursor()
   :let n=str2nr(c)-1
   if n == -1
     :let n=9
   endif
   :call g:SetCharUnderCursor(string(n))
  endif
endfunction

function! IncrementNum()
  :lua require"dial".cmd.increment_normal(1)
endfunction

function! DecrementNum()
  :lua require"dial".cmd.increment_normal(-1)
endfunction

function! MoveLineUp()
  if CursorIsOnFirstLineOfBuffer()
    :return
  endif
  if CursorIsOnLastLineOfBuffer()
    :exe 'norm! ddP'
  else
    :exe 'norm! ddkP'
  endif
  if b:ac == 'r'
    :let b:yr=b:yr-1
    :let @e=b:yr
  else
    :let b:yl=b:yl-1
    :let @s=b:yl
  endif
  :call UpdateCursor()
endfunction

function! MoveLineDown()
  if CursorIsOnLastLineOfBuffer()
    :exe 'norm! o'
    :exe 'norm! k'
  endif
:exe 'norm! ddp'
  if b:ac == 'r'
    :let b:yr=b:yr+1
    :let @e=b:yr
  else
    :let b:yl=b:yl+1
    :let @s=b:yl
  endif
  :call UpdateCursor()
endfunction


function! CopyLineUp()
  if CursorIsOnFirstLineOfBuffer()
    :return
  endif
  if CursorIsOnLastLineOfBuffer()
    :exe 'norm! ddP'
  else
    :exe 'norm! ddkP'
  endif
  if b:ac == 'r'
    :let b:yr=b:yr-1
    :let @e=b:yr
  else
    :let b:yl=b:yl-1
    :let @s=b:yl
  endif
  :call UpdateCursor()
endfunction

function! CopyLineDown()
  if CursorIsOnLastLineOfBuffer()
    :exe 'norm! o'
    :exe 'norm! k'
  endif
  try
  :mkview! 1
  catch
  endt
  :exe 'norm! ^yykpj'
  :try
  :loadview 1
  :catch
  :endt
  if b:ac == 'r'
    :let b:yr=b:yr+1
    :let @e=b:yr
  else
    :let b:yl=b:yl+1
    :let @s=b:yl
  endif
  :call UpdateCursor()
  :set scrolloff=25
endfunction



function NewLineUp(hand)
  if ScreenCheck(a:hand)
    :return
  endif

  if a:hand == 'r'
    :call UpdateCursorR()
  endif
  if a:hand == 'l'
    :call UpdateCursorL()
  endif
  :let line = getline('.')
  try
    ":mkview! 1
    ":sil exe 'norm! "jyydd'
    ":sil exe "norm! i\<CR>"
    ":sil exe 'norm! "jp'
    :undojoin | call setline('.', '') | call append(line('.') -1, '') | call setline('.', line)
    ":loadview 1
  catch
    ":mkview! 1
    :call setline('.', '') | call append(line('.') -1, '') | call setline('.', line)
    ":loadview 1
  endt

  if a:hand == 'r' ||   a:hand == 'l'
    :call UpdateCursor()
  endif
endfunction
"Rename NewLineDown
function NewlineDown(hand)
  if ScreenCheck(a:hand)
    :return
  endif
  if a:hand == 'r'
    :call UpdateCursorR()
  endif
  if a:hand == 'l'
    :call UpdateCursorL()
  endif

  try
    :undojoin | :exe 'norm! $a'
  catch
    :exe 'norm! $a'
  endt
  :call SetCursor()
endfunction


function! CommentTo(direction,pre_delete,...)
  :call UnsetScrollLimit()
  :let y = GetCurrY()
  :call Eval(a:pre_delete)
  :exe 'norm! mb'
  if a:direction == 0
    :let i= GetCurrY()
    while i >= y
      :call NERDComment('n','toggle')
      :exe 'norm! k'
      :let i-=1
    endwhile
  else
    :let i= GetCurrY()
    while i <= y
      :call NERDComment('n','toggle')
      :exe 'norm! j'
      :let i+=1
    endwhile
  endif
  :exe 'norm! `b'
  :call Eval(a:000)
  :call SetScrollLimit()
endfunction

function! GhostTo(direction,pre_delete,...)
  :let y = GetCurrY()
  :call Eval(a:pre_delete)
  :exe 'norm! mb'
  :let @c=''
  if a:direction == 0
    :let i= GetCurrY()
    while i >= y
      :norm! "byy
      :let @c = @b . @c
      :call NERDComment('n','toggle')
      :exe 'norm! k'
      :let i-=1
    endwhile
  else
    :let i= GetCurrY()
    while i <= y
      :norm! "byy
      :let @c .= @b
      :call NERDComment('n','toggle')
      :exe 'norm! j'
      :let i+=1
    endwhile
  endif
  :exe 'norm! `b'
  :exe 'norm! "cp'
  :exe 'norm! `b'
  :call Eval(a:000)
endfunction


function! TabTo(tab_direction,direction,pre_delete,...)
  :let y = GetCurrY()
  :exe 'norm! mj'
  :call Eval(a:pre_delete)
  :exe 'norm! mb'
  if a:direction == 0
    :let j= GetCurrY()
    while j >= y
      if a:tab_direction == 0
        :exe 'norm! 0v$>'
      else
        :exe 'norm! 0v$<'
      endif
      :exe 'norm! k'
      :let j-=1
    endwhile
  else
    :let j= GetCurrY()
    while j <= y
      if a:tab_direction == 0
        :exe 'norm! 0v$>'
      else
        :exe 'norm! 0v$<'
      endif
      :exe 'norm! j'
      :let j+=1
    endwhile
  endif
  :exe 'norm! `b'
  :call Eval(a:000)
endfunction

function! MacroTo(direction,pre,...)
  :let x = GetCurrX()
  :let y = GetCurrY()
  :call Eval(a:pre)
  :exe 'norm! mb'
  if a:direction == 0
    :let j= GetCurrY()
    while j >= y
      :call SetCaretPos(j,x)
      :exe 'norm! @q'
      :let j-=1
    endwhile
  else
    :let j= GetCurrY()
    while j <= y
      :exe 'norm! @q'
      :call SetCaretPos(j,x)
      :let j+=1
    endwhile
  endif
  :exe 'norm! `b'
  :call Eval(a:000)
endfunction

function! InvertSymbol()
  :let char = GetCharUnderCursor()
  if IsAlpha(char)
    "toggle case
    :exe 'norm! v~'
    :return
  endif
  if char == "+"
    :let new_char = "-"
  endif
  if char == "-"
    :let new_char = "+"
  endif
  if char == "["
    :let new_char = "]"
  endif
  if char == "]"
    :let new_char = "["
  endif
  if char == "{"
    :let new_char = "}"
  endif
  if char == "}"
    :let new_char = "{"
  endif
  if char == "("
    :let new_char = ")"
  endif
  if char == ")"
    :let new_char = "("
  endif
  if char == "<"
    :let new_char = ">"
  endif
  if char == ">"
    :let new_char = "<"
  endif
  if char == "0"
    :let new_char = "1"
  endif
  if char == "1"
    :let new_char = "0"
  endif
  if char == '"'
    :let new_char = "'"
  endif
  if char == "'"
    :let new_char = '"'
  endif


  :call SetCharUnderCursor(new_char)
endfunction


function BreakQuote()
  :let line = getline('.')
  :let x = GetCurrX()
  while x >= 0
    if line[x] == "'"
      :sil exe "norm! i'..'"
      :sil exe "norm! h"
      :break
    endif
    if line[x] == '"'
      :sil exe 'norm! i".."'
      :sil exe "norm! h"
      :break
    endif
    :let x -= 1
  endwhile
endfunction

"============================================================ bindings

":nnoremap ð :ISwapWith<CR>
":nnoremap ’ :ISwapWith<CR>
"move line up/down
":nnoremap <C-s> :call MoveLineUp()<CR>
":nnoremap <C-r> :call MoveLineDown()<CR>

":nnoremap <LocalLeader>, :call CopyLineDown()<CR>



":inoremap <C-s> <ESC>^ddkkpmlmsi
":inoremap <C-r> <ESC>^ddpmlmsi

"newline up/down
":nnoremap <silent> <A-e> :call NewlineDown('r')<CR>
":nnoremap <silent> <A-i> :call NewLineUp('r')<CR>

":inoremap <silent> <expr> <A-e> pumvisible()? "\<PageDown>":"\<ESC>$a\<CR>\<ESC>:call SetCursorR()\<CR>i"
":inoremap <silent> <expr> <A-i> pumvisible()? "\<PageUp>":"\<ESC>0i\<CR>\<ESC>k:call SetCursorR()\<CR>i"


"alt r,s
":nnoremap <silent> þ :call NewlineDown('l')<CR>
":nnoremap <silent> ‘ :call NewLineUp('l')<CR>

":inoremap <silent> þ <ESC>:call UpdateCursorL()<CR>$a<CR><ESC>:call SetCursorL()<CR>i
":inoremap <silent> ’ <ESC>:call UpdateCursorL()<CR>:call NewLineUp()<CR>i

"nnoremap <LocalLeader>k :call InvertSymbol()<CR>
"vnoremap <LocalLeader>k ~

":nnoremap <silent> j :call IncrementChar()<CR>
":vnoremap <silent> j <ESC>:call IncrementChar()<CR>
":nnoremap <silent> J :call DecrementChar()<CR>
":vnoremap <silent> J <ESC>:call DecrementChar()<CR>

":nnoremap <silent> <C-j> :call IncrementNum()<CR>
":vnoremap <silent> <C-j> <ESC>:call IncrementNum()<CR>
":nnoremap <silent> <A-S-j> :call DecrementNum()<CR>
":vnoremap <silent> <A-S-j> <ESC>:call DecrementNum()<CR>


":nnoremap <A-'> :call BreakQuote()<CR>
":nnoremap <Space>' :call BreakQuote()<CR>
":inoremap <A-'> <ESC>:call BreakQuote()<CR>i

"---------------------------------------------- comment
":nnoremap me :call CommentTo(0,["call NavSearchVert('r',0)","call SetCursor()"])<CR>
":nnoremap mi :call CommentTo(1,["call NavSearchVert('r',1)","call NavUpTrim()"])<CR>

":nnoremap mr :call CommentTo(0,["call NavSearchVert('l',0)","call NavDownTrim()"])<CR>
":nnoremap ms :call CommentTo(1,["call NavSearchVert('l',1)","call NavUpTrim()"])<CR>

":nnoremap <silent> mme :call Goto(["call NavSearchVert('n',0)"],["norm! 0","call CommentTo(0,['call NavSearchVert(\"n\",0)'],'call UpdateCursor()')"])<CR>
":nnoremap <silent> mmi :call Goto(["call NavSearchVert('n',1)"],["norm! j0","call CommentTo(1,['call NavSearchVert(\"n\",1)','norm! 0'])","call UpdateCursor()"])<CR>
":nnoremap <silent> mmi :call Goto(["norm! mc","call NavSearchVert('r',1)"],["norm! 0","call CommentTo(0,['call NavSearchVert(\"r\",0)'])","norm! `c","call SetCursor()"])<CR>
":nnoremap <silent> mmr :call Goto(["call NavSearchVert('n',0)"],["norm! 0","call CommentTo(0,['call NavSearchVert(\"n\",0)'],'call UpdateCursor()')"])<CR>
":nnoremap <silent> mms :call Goto(["call NavSearchVert('n',1)"],["norm! j0","call CommentTo(1,['call NavSearchVert(\"n\",1)','norm! 0'])","call UpdateCursor()"])<CR>


":nnoremap mm<Space> :call Goto(["call NavSearchVert('n',2)"],['call CommentLineDown()'])<CR>
":nnoremap mmm :call CommentFile()<CR>
":nnoremap MMM :call UncommentFile()<CR>
"---------------------------------------------- ghost
":nnoremap lme :call GhostTo(0,["call NavSearchVert('r',0)","call NavDownTrim()"])<CR>
":nnoremap lmi :call GhostTo(1,["call NavSearchVert('r',1)","call NavUpTrim()","call SetCursor()"])<CR>

":nnoremap lmr :call GhostTo(0,["call NavSearchVert('l',0)","call NavDownTrim()"])<CR>
":nnoremap lms :call GhostTo(1,["call NavSearchVert('l',1)","call NavUpTrim()","call SetCursor()"])<CR>

":nnoremap <silent> lmme :call Goto(["call NavSearchVert('r',0)"],["norm! 0","call GhostTo(0,['call NavSearchVert(\"r\",0)'])"])<CR>
":nnoremap <silent> lmmi :call Goto(["call NavSearchVert('r',1)"],["norm! 0","call GhostTo(1,['call NavSearchVert(\"r\",1)'])"])<CR>

":nnoremap <silent> lmmr :call Goto(["call NavSearchVert('l',0)"],["norm! 0","call GhostTo(0,['call NavSearchVert(\"l\",0)'])"])<CR>
":nnoremap <silent> lmms :call Goto(["call NavSearchVert('l',1)"],["norm! 0","call GhostTo(1,['call NavSearchVert(\"l\",1)'])"])<CR>
"---------------------------------------------- tab
":inoremap <F12><ESC>
":nnoremap <Tab>n :call TabTo(1,0,["call NavSearchVert('r',0)","call NavDownTrim()"],"norm! `j","call SetCursor()")<CR>
":nnoremap <Tab>e :call TabTo(0,0,["call NavSearchVert('r',0)","call NavDownTrim()"])<CR>
":nnoremap <Tab>i :call TabTo(0,1,["call NavSearchVert('r',1)","call NavUpTrim()"])<CR>
":nnoremap <Tab>o :call TabTo(0,0,["call NavSearchVert('r',0)"],"norm! `j","call SetCursor()")<CR>

":nnoremap <Tab>a :call TabTo(1,0,["call NavSearchVert('l',0)","call NavDownTrim()"],"norm! `j")<CR>
":nnoremap <Tab>r :call TabTo(0,0,["call NavSearchVert('l',0)","call NavDownTrim()"])<CR>
":nnoremap <Tab>s :call TabTo(0,1,["call NavSearchVert('l',1)","call NavUpTrim()"])<CR>
":nnoremap <Tab>t :call TabTo(0,0,["call NavSearchVert('l',0)","call NavDownTrim()"],"norm! `j")<CR>

":nnoremap <Tab><Tab>n :call Goto(["call NavSearchVert('n',2)"],["norm! 0","call TabTo(1,0,['call NavSearchVert(\"n\",2)'],'call UpdateCursor()')"])<CR>
":nnoremap <Tab><Tab>e :call Goto(["call NavSearchVert('n',0)"],["norm! 0","call TabTo(0,0,['call NavSearchVert(\"n\",0)'],'call UpdateCursor()')"])<CR>
":nnoremap <Tab><Tab>i :call Goto(["call NavSearchVert('n',1)"],["norm! j0","call TabTo(0,1,['call NavSearchVert(\"n\",1)','norm! 0'])","call UpdateCursor()"])<CR>
":nnoremap <Tab><Tab>o :call Goto(["call NavSearchVert('n',2)"],["norm! 0","call TabTo(0,0,['call NavSearchVert(\"n\",2)'],'call UpdateCursor()')"])<CR>

":nnoremap <Tab><Tab>a :call Goto(["call NavSearchVert('n',2)"],["norm! 0","call TabTo(1,0,['call NavSearchVert(\"n\",2)'],'call UpdateCursor()')"])<CR>
":nnoremap <Tab><Tab>r :call Goto(["call NavSearchVert('n',0)"],["norm! 0","call TabTo(0,0,['call NavSearchVert(\"n\",0)'],'call UpdateCursor()')"])<CR>
":nnoremap <Tab><Tab>s :call Goto(["call NavSearchVert('n',1)"],["norm! j0","call TabTo(0,1,['call NavSearchVert(\"n\",1)','norm! 0'])","call UpdateCursor()"])<CR>
":nnoremap <Tab><Tab>t :call Goto(["call NavSearchVert('n',2)"],["norm! 0","call TabTo(0,0,['call NavSearchVert(\"n\",2)'],'call UpdateCursor()')"])<CR>


":nnoremap <Tab><Tab><Space> :call Goto(["call NavSearchVert('n',2)"],["exe 'norm! 0v$>'","call UpdateCursor()"])<CR>
":nnoremap <S-Tab><S-Tab><Space> :call Goto(["call NavSearchVert('n',2)"],["exe 'norm! 0v$<'","call UpdateCursor()"])<CR>

 "-------------------------------------------------
 ":nnoremap h<Space>q :call MacroTo(0,["call NavSearchVert('r',0)"],"call SetCursor()")<CR>


":vnoremap <Tab> >`<v`>
":vnoremap <S-Tab> <`<v`>

