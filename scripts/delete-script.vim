

function! DeleteTo(direction,pre_delete,...)
  :call UnsetScrollLimit()
  :exe 'norm! mj'
  :call Eval(a:pre_delete)
  :exe 'norm! mb'
  if a:direction == 1
    :exe 'norm! `j'
    :exe 'norm! d`b'
  else
    :exe 'norm! d`j'
  endif
  :call Eval(a:000)
  :call SetScrollLimit()
endfunction

function! DeleteBlock()
  :call GotoOppositeSymbolThen('norm! d`j','norm! d')
endfunction


function! DeleteToMark()
  :let @b=@+
  :sleep 50m
  :exe 'norm! d`j'
endfunction


function! DeleteCharForward()
  if CursorIsAtEndOfLine() && IsSpace(GetCharUnderCursor())
    :norm! xgJ
  else
    :norm! x
    :call SetCursor()
    if CursorIsAtEndOfLine() && !IsSpace(GetCharUnderCursor())
      :call NavRight()
    endif
  endif
endfunction

function! DeleteCharBackward()
  "if CursorIsAtEndOfLine() && IsSpace(GetCharUnderCursor())
  "else
    :norm! hx
  "endif
  :call SetCursor()
endfunction


function! DeleteWordForward()
  if CursorIsAtEndOfLine() && IsSpace(GetCharUnderCursor())
    :norm! xgJ
  else
    if IsSpace(GetCharUnderCursor())
      :exe 'norm! dw'
    else
      :exe 'norm! de'
    endif
    if CursorIsAtEndOfLine() && IsSpace(GetCharUnderCursor())
      :call g:SetCursor()
      :call g:NavRight()
      :exe 'norm! i '
    endif
  endif
endfunction

function! DeleteWordBackward()
  :exe 'norm! mj'
  :exe 'norm! h'
  if IsSpace(GetCharUnderCursor())
    :exe 'norm! bel'
    :exe 'norm! d`j'
  else
    :exe 'norm! ldb'
  endif
  :call SetCursor()
endfunction

function! DeleteToEndOfLine()
  :sil exe 'norm! d$'
  :call SetCursor()
endfunction

function DeleteToLineUp()
  :sil exe 'norm! j0'
  :call DeleteTo(1,["call NavSearchVert('r',1)","norm! k","call AppendSpace()","norm! $"],"call UpdateCursor()")
endfunction

"function! DeleteForward()
  ":exe 'norm! mj'
  "if !CursorIsAtBeginningOfLine()
    ":exe 'norm! h'
    "if IsBiSymbol(GetCharUnderCursor())
      ":call GotoOppositeSymbol()
      ":exe 'norm! d`j'
      "return
    "else
      ":exe 'norm! l'
    "endif
  "endif
  "if g:IsBiSymbol(g:GetCharUnderCursor())
    ":exe 'norm! v'
    ":call GotoOppositeSymbol()
    ":exe 'norm! d`j'
  "else
    ":let n1=g:GetCharWithTimeout()
    ":let c1=nr2char(n1)
    ":let g:tc1=c1
    "if g:IsSymbol(c1)
      ":call g:SearchForStringF(c1)
      ":call DeleteToMark()
    "else
      "if n1 == 0
      ":let g:t=c1
        ":call g:SearchForStringF(@j)
        ":call DeleteToMark()
      "else
        "if c1 == "n"
          ":let c2=g:PromptChar()
          "if g:IsSymbol(c2)
            ":norm! v
            ":call g:SearchForStringF(c2)
            ":call DeleteToMark()
          "else
            ":let c2=g:PromptChar()
            ":let g:tc2=c2
            ":call g:SearchForStringF(c1.c2)
            ":call DeleteToMark()
          "endif
        "else
          "":let c2=nr2char(g:GetCharWithTimeout())
          ":let c2=g:PromptChar()
          ":call g:SearchForStringF(c1.c2)
          ":call DeleteToMark()
        "endif
      "endif
    "endif
  "endif
"endfunction


"function! DeleteBackward()
  ":exe 'norm mj'
  ":let n1=GetCharWithTimeout()
  ":let c1=nr2char(n1)
  "if IsSymbol(c1)
    ":call SearchForStringB(c1)
    ":call DeleteToMark()
  "else
    "if n1 == 0
      ":call g:SearchForStringB(@j)
      ":call DeleteToMark()
    "else
      "if c1 == "n"
        ":let c2=g:PromptChar()
        "if g:IsSymbol(c2)
          ":norm! v
          ":call g:SearchForStringB(c2)
          ":call DeleteToMark()
        "else
          ":let c2=g:PromptChar()
          ":call g:SearchForStringB(c1.c2)
          ":call DeleteToMark()
        "endif
      "else
        ":let c2=g:PromptChar()
        ":call g:SearchForStringB(c1.c2)
        ":call DeleteToMark()
      "endif
    "endif
  "endif
"endfunction


