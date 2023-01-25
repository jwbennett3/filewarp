

function! VisualMode()
if exists('b:vmode')
  :let b:vmode = !b:vmode
else
  :let b:vmode=1
endif
if b:vmode
  ":call UpdateCursor()
  :let pos=getpos(".")
  :let b:vx=pos[2]
  :let b:vy=pos[1]
  :exe 'norm! v'
else
  :call setpos('.',[0]+[b:vy,b:vx]+[0])
  :call SetCursor()
endif
endfunction

function! ChangeSelection()
:let b:vmode=0
:exe 'norm! `<v`>c'
if !CursorIsAtBeginningOfLine()
  :exe 'norm! l'
endif
:startinsert
endfunction


function! VisualSelect()
  if exists('b:vmode')
    :let pos=getpos(".")
    if pos[2]<b:vx
     :let x=b:vx-1
    else
      :let x=b:vx
    endif
    :call setpos('.',[0]+[b:vy,x]+[0])
    :norm! v
    :call setpos('.',pos)
    :call g:SetCursor()
  endif
endfunction

function! VNavHoriz()
  :let pos=getpos(".")
  if pos[2]<=b:vx
    :let x=b:vx-1
  else
    :let x=b:vx
  endif
  :call setpos('.',[0]+[b:vy,x]+[0])
  :norm! v
  :call setpos('.',pos)
endfunction

function! VNavVert()
  :let pos=getpos(".")
  :call setpos('.',[0]+[b:vy,b:vx]+[0])
  :norm! v
  :call setpos('.',pos)
endfunction

"---------------------------- word
function! VNavHorizWord()
  :let pos=getpos(".")
  if pos[2]<=b:vx
    :let x=b:vx-1
    ":let x=pos[2]-1
  else
    ":let x=pos[2]
    :let x=b:vx
  endif
  :let y=pos[1]
  :call setpos('.',[0]+[b:vy,x]+[0])
  :norm! v
  :call setpos('.',pos)
  ":call setpos('.',[0]+[y,x]+[0])
endfunction

function! VNavDownWord()

if &ft == "java"
    ":exe 'norm! /\/\/\*\/\/\/<CR>gn<ESC>:call SetCursorR()<CR>'
    ":call g:VisualSelect()
    ":return
    :call PageDown()
    :call VisualSelect()
  else
    :exe 'norm! 25j'
  endif
endfunction

function VNavUpWord()
  if &ft == "java"
    :exe 'norm! /\/\/\*\/\/\/<CR>gn<ESC>:call SetCursorR()<CR>'
    :call VisualSelect()
    :return
  else
    :exe 'norm! 25k'
  endif
endfunction


function SelectWord()
:let b:vmode=1
  while GetCharUnderCursor() ==# " " && GetCurrX()!=1
    :sil exe 'norm! h'
  endwhile
  :let pos=getpos(".")
  :let b:vx=pos[2]
  :let b:vy=pos[1]
endfunction

function Reselect()
  :let b:vmode=1
  :let pos=getpos(".")
  :let b:vx=pos[2]
  :let b:vy=pos[1]
endfunction


"========================================== right
"---------------------------- single char
function! VNavLeftR()
  :call InitR()
  :call UpdateCursorR()
  :call VNavHoriz()
  :call SetCursorR()
  :call NavLeftR()
endfunction

function! VNavDownR()
  :call InitR()
  :call VNavVert()
  :call SetCursorR()
  :call NavDownR()
endfunction

function! VNavUpR()
  :call InitR()
  :call VNavVert()
  :call SetCursorR()
  :call NavUpR()
  :call UpdateCursorR()
endfunction

function! VNavRightR()
  :call InitR()
  :call UpdateCursorR()
  :call NavRightR()
  :call SetCursorR()
  :call VNavHoriz()
endfunction
"---------------------------- word
function! VNavLeftWordR()
  ":norm! b
  :exe 'norm! h'
  if IsSpace(GetCharUnderCursor())
    :call NavToPrevNonWhite()
  else
    :norm! b
  endif
  :call VNavHorizWord()
  :call SetCursorR()
endfunction

function! VNavDownWordR()
  :call VNavDownWord()
  :call SetCursorR()
  :call VisualSelect()
endfunction

function! VNavUpWordR()
  :call VNavUpWord()
  :call SetCursorR()
  :call VisualSelect()
endfunction

function! VNavRightWordR()
  ":norm! lel
  :exe 'norm! l'
  if IsSpace(GetCharUnderCursor())
    :call NavToNextNonWhite()
  else
    :exe 'norm! elh'
  endif
  :call VNavHorizWord()
  :call SetCursorR()
endfunction
"---------------------------- end line
function! VNavBeginningLineR()
  :call NavBeginningLineR()
  :call SetCursorR()
  :call VisualSelect()
endfunction

function! VNavEndLineR()
  :call NavEndLineR()
  :call SetCursorR()
  :call VisualSelect()
endfunction

function! VNavBeginningDocR()
  :norm! gg
  :call SetCursorR()
  :call VisualSelect()
endfunction

function! VNavEndDocR()
  :norm! G
  :call SetCursorR()
  :call VisualSelect()
endfunction

"========================================== left
"---------------------------- single char
function! VNavLeftL()
  :callUpdateCursorL()
  :call VNavHoriz()
  :call SetCursorL()
  :call NavLeftL()
endfunction

function! VNavDownL()
  :call VNavVert()
  :call SetCursorL()
  :call NavDownL()
endfunction

function! VNavUpL()
  :call VNavVert()
  :call SetCursorL()
  :call NavUpL()
endfunction

function! VNavRightL()
  :call UpdateCursorL()
  :call VNavHoriz()
  :call SetCursorL()
  :call NavRightL()
endfunction
"---------------------------- word
function! VNavLeftWordL()
  :norm! b
  :call VNavHorizWord()
  :call SetCursorL()
endfunction

function! VNavDownWordR()
  :call VNavDownWord()
  :call SetCursorR()
  :call VisualSelect()
endfunction

function! VNavUpWordL()
  :call VNavUpWord()
  :call SetCursorL()
  :call VisualSelect()
endfunction

function! VNavRightWordL()
  :norm! lel
  :call VNavHorizWord()
  :call SetCursorL()
endfunction
"---------------------------- end line
function! VNavBeginningLineL()
  :call NavBeginningLineL()
  :call SetCursorL()
  :call VisualSelect()
endfunction

function! VNavEndLineL()
  :call NavEndLineL()
  :call SetCursorL()
  :call VisualSelect()
endfunction

function! VNavBeginningDocL()
  :norm! gg
  :call SetCursorL()
  :call VisualSelect()
endfunction

function! VNavEndDocL()
  :norm! G
  :call SetCursorL()
  :call VisualSelect()
endfunction








