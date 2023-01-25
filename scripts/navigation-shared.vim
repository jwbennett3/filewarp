

function! Goto(get_there,then)
  :call UnsetScrollLimit()
  :call Eval(a:get_there)
  :call Eval(a:then)
  :call SetScrollLimit()
endfunction

function! GotoWord(...)
  :let g:EasyMotion_keys = g:word_keys
  :silent call EasyMotion#WB(0,2)
  :exe 'norm! "jye'
  :let @/=@j
  :exe 'norm! viw'
  :call Eval(a:000)
endfunction

function! GotoOppositeSymbolThen(inside,outside)
  :exe 'norm! mj'
  if CursorIsAtBeginningOfLine()
    :exe 'norm! v'
    :call GotoOppositeSymbol()
    :call Eval([a:outside])
  else
    :exe 'norm! h'
    if IsBiSymbol(GetCharUnderCursor())
      :call GotoOppositeSymbol()
      :call Eval([a:inside])
      return
    else
      :exe 'norm! l'
      if IsBiSymbol(GetCharUnderCursor())
        :exe 'norm! v'
        :call GotoOppositeSymbol()
        :call Eval([a:outside])
       endif
    endif
  endif
endfunction

function! OtherHand()
  if  b:ac == 'r'
    :return 'l'
  else
    :return 'l'
  endif
endfunction

function! ScreenCheck(hand)
  "if a:hand != 'n'
    "if a:hand == 'r'
      ":let cursor_y = b:yr
      "if cursor_y > LastScreenY() || cursor_y < FirstScreenY()
        ":call UpdateCursorR()
        ":return 1
      "endif
    "else
      ":let cursor_y = b:yl
      "if cursor_y > LastScreenY() || cursor_y < FirstScreenY()
        ":call UpdateCursorL()
        ":return 1
      "endif
    "endif
  "endif
  :return 0
endfunction

function! NavToNextNonWhite()
  :let line = getline('.')
  :let x = getpos('.')[2]-1
  if !IsSpace(line[x])
    :exe 'norm! l'
  endif
  while IsSpace(line[x])
    let x+=1
    :exe 'norm! l'
  endwhile
endfunction

function! NavToPrevNonWhite()
  :let line = getline('.')
  :let x = getpos('.')[2]-1
  if !IsSpace(line[x])
    :exe 'norm! h'
  endif
  while IsSpace(line[x])
    let x-=1
    :exe 'norm! h'
  endwhile
endfunction

function! LineIsOnlySpaces(...)
  if a:0>0
    :let y=a:1
  else
    :let y=GetCurrY()
  endif
  ":let y=a:y
  :let line = getline(y)
  :let i=0
  while i<len(line)
    if !IsSpace(line[i])
      :return 0
    endif
    :let i=i+1
  endwhile
  :return 1
endfunction

function! CursorIsAtFirstNonWhite()
  :let line = getline(GetCurrY())
  :let i=0
  while i<len(line)
    if !IsSpace(line[i])
      :let i=i+1
      :break
    endif
    :let i=i+1
  endwhile
  :return i == GetCurrX()
endfunction

function! CoordIsJustBeyondEndOfLine(x,y)
  :let num_cols = col([a:y,"$"])-1
  if num_cols == 0
    return a:x == 2
  else
    return a:x == num_cols +1
  endif
endfunction

function! CoordIsBeyondEndOfLine(x,y)
  :let num_cols = col([a:y,"$"])-1
  if num_cols == 0
    return a:x > 1
  else
    return a:x > num_cols
  endif
endfunction

function! CursorIsOnFirstLineOfBuffer()
  let pos = getpos('.')
  return pos[1] == 1
endfunction

function! CursorIsOnLastLineOfBuffer()
  let pos = getpos('.')
  return pos[1] == line('$')
endfunction




"Deprecated should no longer be needed once block nav is perfected
function PageDown()
  "vim is in diff mode
  if &diff
    :exe 'norm! ]c'
    :return
  endif
  if &ft == "java"
    :call SearchForStringF('\/\/\*\/\/\/')
    :norm! gn
    :return
  else
  if &ft == "cpp"
    :call SearchForStringF('public\s\|private\s\|void\s\|class\s\|int\s\|boolean\s')
    :norm! gn
    :return
  else
  if &ft == "python"
    "try
      ":call g:SearchForStringF('def\s\|class\s')
      ":exe 'norm! gnv'
    "catch
      ":norm! 
    "endt
    :norm! 
    :return
  else
    if exists('g:vscode')
      :norm! 25j
      :return
    else
      :norm! 
      :return
    endif
  endif
  endif
  endif
endfunction

function! PageUp()
  if &diff
    ":exe 'norm! [c'
    return
  endif
  if &ft == "java"
    :call SearchForStringB('\/\/\*\/\/\/')
    :norm! gN
  else
  if &ft == "cpp"
    :call SearchForStringB('public\s\|private\s\|void\s\|class\s\|int\s\|boolean\s')
    :norm! gN
  else
  if &ft == "python"
    try
      :call SearchForStringB('def\s\|class\s')
      :norm! gn
    catch
      :norm! 
    endt
  else
    if exists('g:vscode')
      :norm! 25k
    else
      :norm! 
    endif
  endif
  endif
  endif
endfunction


function! UpdateCursor(...)
  if a:0 > 0
    :let b:ac = a:000[0]
  endif
  if !exists('b:ac')
    :let b:ac='r'
  endif
  if b:ac == "r"
    :call UpdateCursorR()
  endif
  if b:ac == "l"
    :call UpdateCursorL()
  endif
endfunction



function! NavLeft()
  if b:ac == "r"
    :call NavLeftR()
  endif
  if b:ac == "l"
    :call NavLeftL()
  endif
endfunction


function! NavRight()
  if b:ac == "r"
    :call NavRightR()
  endif
  if b:ac == "l"
    :call g:NavRightL()
  endif
endfunction


function! NavDown()
  if b:ac == "r"
    :call NavDownR()
  endif
  if b:ac == "l"
    :call NavDownL()
  endif
endfunction

function! NavUp()
  if b:ac == "r"
    :call NavUpR()
  endif
  if b:ac == "l"
    :call NavUpL()
  endif
endfunction

function! NavUpTrim()
  if b:ac == "r"
    :call NavUpTrimR()
  endif
  if b:ac == "l"
    :call NavUpTrimL()
  endif
endfunction

function! NavDownTrim()
  if b:ac == "r"
    :call NavDownTrimR()
  endif
  if b:ac == "l"
    :call NavDownTrimL()
  endif
endfunction

function! NavLeftWord()
  if b:ac == "r"
    :call NavLeftWordR()
  endif
  if b:ac == "l"
    :call NavLeftWordL()
  endif
endfunction

function! NavRightWord()
  if b:ac == "r"
    :call NavRightWordR()
  endif
  if b:ac == "l"
    :call NavRightWordL()
  endif
endfunction



function! SetCursor(...)
  if a:0 > 0
    :let b:ac = a:000[0]
  endif

  if exists('b:ac')
    if b:ac == "r"
      :call SetCursorR()
    endif
    if b:ac == "l"
      :call SetCursorL()
    endif
  else
    let b:ac = "r"
    :call SetCursorR()
  endif
endfunction

function! SetCursorAndJump()
  :call SetCursor()
  ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
endfunction
"Deprecated instead use
function! SetCursorRAndJump()
  :call SetCursorR()
  ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
endfunction
"Deprecated instead use
function! SetCursorLAndJump()
  :call SetCursorL()
  ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
endfunction

