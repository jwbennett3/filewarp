
function! CutTo(direction,pre_cut,...)
  :call UnsetScrollLimit()
  :let @b=@+
  :exe 'norm! mj'
  :call Eval(a:pre_cut)
  :exe 'norm! mb'
  if a:direction == 1
    :exe 'norm! `j'
    :exe 'norm! d`b'
  else
    :exe 'norm! d`j'
  endif

  :let @+=@"
  :call Eval(a:000)
  :call SetScrollLimit()
endfunction

function! CutBlock()
  if !exists('$copy_reg')
    :let $copy_reg = '+'
  endif
  :call GotoOppositeSymbolThen('norm! mb"'.$copy_reg.'y`jd`b','norm! "'.$copy_reg.'y`<v`>d')
endfunction



function! CutToMark()
  :let @b=@+
  :sleep 100m
  :exe 'norm! d`j'
  :let @+=@"
endfunction

function! CutForward()
  "this looks like a bug

  ":exe 'norm mj'
  :exe 'norm mj'
  if !CursorIsAtBeginningOfLine()
    :exe 'norm! h'
    if IsBiSymbol(GetCharUnderCursor())
      :call GotoOppositeSymbol()
      :exe 'norm! "+y`jd`>'
      return
    else
      :exe 'norm! l'
    endif
  endif
  if IsBiSymbol(GetCharUnderCursor())
    :exe 'norm! v'
    :call GotoOppositeSymbol()
    :exe 'norm! "+y`jD`>'
  else
    :let c1=g:PromptChar()
    if g:IsSymbol(c1)
      :call g:SearchForStringF(c1)
      :call CutToMark()
    else
      if c1 == "n"
        :let c2=g:PromptChar()
        if g:IsSymbol(c2)
          :norm! v
          :call g:SearchForStringF(c2)
          :call CutToMark()
        else
          :call g:SearchForStringF(c1.c2)
          :call CutToMark()
        endif
      else
        if c1 == "c"
          :exe 'norm! "+yl'
          :exe 'norm! dl'
        else
          :let c2=g:PromptChar()
          :call g:SearchForStringF(c1.c2)
          :call CutToMark()
        endif
      endif
    endif
  endif
endfunction

function! CutBackward()
  :exe 'norm mj'
  :let c1=g:PromptChar()
  if g:IsSymbol(c1)
    :norm! v
    :call g:SearchForStringB(c1)
    :norm! l
    :call CutToMark()
  else
    if c1 == "e"
      :let c2=g:PromptChar()
      if g:IsSymbol(c2)
        :call g:SearchForStringB(c2)
        :call CutToMark()
      else
        :call g:SearchForStringB(c1.c2)
        :call CutToMark()
      endif
    else
      if c1 == "c"
        :exe 'norm! "+yh'
        :exe 'norm! x'
      else
        :let c2=g:PromptChar()
        :norm! v
        :call g:SearchForStringB(c1.c2)
        :call CutToMark()
      endif
    endif
  endif
endfunction


function CutToLineUp()
  :sil exe 'norm! j0'
  :call CutTo(1,["call NavSearchVert('r',1)","norm! k","call AppendSpace()","norm! $"],"call UpdateCursor()")
endfunction
