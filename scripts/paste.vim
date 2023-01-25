

function! Paste()
  :let pos=getpos('.')
  if CursorIsAtBeginningOfLine()
    "try
      ":undojoin | exe 'norm! i '
    "catch
      ":exe 'norm! i '
    "endt
    :exe 'norm! "+P'
    ":norm! 0
    ":undojoin | exe 'norm! x'
    ":let b:xr=1
    ":let @i=1
    :call UpdateCursor()
  else
    :exe 'norm! mjh"+p`j:call UpdateCursor()<CR>'
  endif
endfunction

function! AltPaste()
  :let pos=getpos('.')
  if CursorIsAtBeginningOfLine()
    try
      :undojoin | exe 'norm! i '
    catch
      :exe 'norm! i '
    endt
    :exe 'norm! "rp'
    :norm! 0
    :undojoin | exe 'norm! x'
    :let b:xr=1
    :let @i=1
    :call UpdateCursorR()
  else
    :exe 'norm! mjh"rp`j:call UpdateCursor()<CR>'
  endif
endfunction

function! PasteInto()
  :norm! `<
  :let pos=getpos('.')
  if CursorIsAtBeginningOfLine()
    try
      :undojoin | exe 'norm! i '
    catch
      :exe 'norm! i '
    endt
    :exe 'norm! gvc'
    :exe 'norm! "+p'
    :norm! 0
    :undojoin | exe 'norm! x'
  else
    :exe 'norm! gvdh'
    :let c = GetCharUnderCursor()
    if IsSpace(c)
      :exe 'norm! "+p`<:call UpdateCursor()<CR>'
    else
      :exe 'norm! "+p`<:call UpdateCursor()<CR>'
    endif
  endif
  :let b:vmode=0
endfunction

function! AltPasteInto()
  :norm! `<
  :let pos=getpos('.')
  if CursorIsAtBeginningOfLine()
    try
      :undojoin | exe 'norm! i '
    catch
      :exe 'norm! i '
    endt
    :exe 'norm! gvc'
    :exe 'norm! "rp'
    :norm! 0
    :undojoin | exe 'norm! x'
  else
    :exe 'norm! gvbh'
    :exe 'norm! "rp`<:call UpdateCursor()<CR>'
  endif
endfunction

