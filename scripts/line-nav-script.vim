function! s:GetCharWithTimeout()
  :let n=getchar(0)
  :let count=0
  while n == 0 && count < 20
    :let n=getchar(0)
    :let count+=1
    :sleep 10m
  endwhile
  :return n
endfunction

function! s:GetChar()
  :let n1=s:GetCharWithTimeout()
  if n1 == 0
    return 0
  else
  :let c1=nr2char(n1)
  if n1>31 && n1<65
    :let @j=c1
    if n1 == 32
      :let @j="\\s"
    endif
   if n1 == 46
      :let @j="\\."
    endif
  else
    :let c2=nr2char(s:GetCharWithTimeout())
    :let c3=nr2char(s:GetCharWithTimeout())
    :let @j=c1.c2.c3
  endif
    :let @/=@j
    :return 1
  endif
endfunction


function! VNavForward()
  if IsBiSymbol(GetCharUnderCursor())
    :call GotoOppositeSymbol()
    :exe 'norm! mb'
    :call SetCursor()
    :exe 'norm! `<v`b'
    return
  endif
  if s:GetChar()
    :norm /j
  else
    :exe 'norm! n'
  endif
  :exe 'norm! hmb'
  :call SetCursor()
  :exe 'norm! `<v`b'
endfunction


function! NavRightForward()
  :call g:UpdateCursorR()
  if !CursorIsAtBeginningOfLine()
    :exe 'norm! h'
    if IsBiSymbol(GetCharUnderCursor())
      :call GotoOppositeSymbol()
      :call g:SetCursorR()
      return
    else
      :exe 'norm! l'
    endif
  endif
  if IsBiSymbol(GetCharUnderCursor())
    :call GotoOppositeSymbol()
    :call g:SetCursorR()
    :return
  endif
  :call s:GetChar()
  :call g:SearchForStringF(@j)
  :call g:SetCursorR()
endfunction

function! NavRightBackward()
  :call g:UpdateCursorR()
  if g:IsBiSymbol(g:GetCharUnderCursor())
    :exe 'norm! %'
    :call g:SetCursorR()
    :return
  endif
  if s:GetChar()
    :call g:SearchForStringB(@j)
    :norm ml
  else
    :norm! Nml
  endif
  :call g:SetCursorR()
endfunction

function! NavLeftForward()
  :call UpdateCursorL()
  if !CursorIsAtBeginningOfLine()
    :exe 'norm! h'
    if IsBiSymbol(GetCharUnderCursor())
      :call GotoOppositeSymbol()
      :call SetCursorL()
      return
    else
      :exe 'norm! l'
    endif
  endif
  if IsBiSymbol(GetCharUnderCursor())
    :exe 'norm! %'
    :call SetCursorL()
    :return
  endif
 if s:GetChar()
    :norm /j
  else
    :norm! n
  endif
  :call SetCursorL()
endfunction


function! g:NavLeftBackward()
  :call g:UpdateCursorL()
  if g:IsBiSymbol(g:GetCharUnderCursor())
    :exe 'norm! %'
    :call g:SetCursorL()
    :return
  endif
  if s:GetChar()
    :norm ?j
    :norm ms
  else
    :norm! N
  endif
  :call g:SetCursorL()
endfunction

