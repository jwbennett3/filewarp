

function! AltCopyTo(pre_copy,...)
"TODO
endfunction



function! CopyTo(direction,pre_copy,...)
  :let scrolloff_orig = &scrolloff
  :set scrolloff=0
  try
    :let @b=@+
    :let x = GetCurrX()
    :let y = GetCurrY()
    :exe 'norm! mj'
    :call Eval(a:pre_copy)
    :exe 'norm! mb'
    if a:direction == 1
      :exe 'norm! `j'
      :exe 'norm! "+y`b'
    else
    :exe 'norm! "+y`j'
    endif
    :exe 'norm! `b'
    :call Eval(a:000)
  finally
    :let &scrolloff = scrolloff_orig
  endt
endfunction

"function! CopyBlock()
  "if !exists('$copy_reg')
    ":let $copy_reg = '+'
  "endif
  ":call GotoOppositeSymbolThen('norm! "'.$copy_reg.'y`j','norm! "'.$copy_reg.'y`j')
"endfunction


function! CopyToMark()
  :let @b=@+
  :sleep 120m
  :exe 'norm! "+y`j'
endfunction

function! VCopyPrepend()
  :norm! `<"by`>
  :let @+ = @b . "\n" . @+
  :let b:vmode=0
endfunction

function! VCopyAppend()
  :norm! `<"by`>
  :let @+ .= "\n"
  :let @+ .= @b
  :let b:vmode=0
endfunction

function! VCopy()
  :let g:x=GetCurrX()
  :let g:y=GetCurrY()
  :exe 'norm! `<v`>"+y'
  :exe 'norm! `<'
  :let g:lx=GetCurrX()
  :let g:ly=GetCurrY()
  :exe 'norm! `>'
  :let rx=GetCurrX()
  :let ry=GetCurrY()
  if g:x == g:lx && g:y == g:ly
    :exe 'norm! `>'
  else
    :exe 'norm! `<'
  endif
  :call UpdateCursor()
endfunction



function! CopyPrependLine()
  :norm! "byy
  :let @+ = @b . @+
endfunction

function! CopyAppendLine()
  :norm! "byy
  :let @+ .= "\n"
  :let @+ .= @b
endfunction


function CopyToLineUp()
  :sil exe 'norm! j0'
  :call CopyTo(1,["call NavSearchVert('r',1)","norm! 0"])
endfunction

