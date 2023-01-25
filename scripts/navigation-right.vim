:hi right  ctermbg=137 ctermfg=238

function! MarkRight(x,y)
  :call UnmarkRight()
  if b:yr != b:yl
    :let b:rrm = matchaddpos("right_row",[[a:y]])
  endif
  :let b:rm = matchaddpos("right",[[a:y,a:x]])
endfunction

function! UnmarkRight()
  if exists('b:rm')
   try
    :call matchdelete(b:rm)
   catch
      :call clearmatches()
    endt
  endif
  if exists('b:rrm')
   try
    :call matchdelete(b:rrm)
   catch
      :call clearmatches()
   endt
  endif
endfunction

function! InitR()
  if !exists('b:ir')
    if @e
      let b:yr=str2nr(@e)
    else
      :let b:yr=1
      :let @e=b:yr
    endif
    if b:yr >= line('$')
      :let b:yr = 1
      :let @e=b:yr
    endif

    if @i
        let b:xr=str2nr(@i)
    else
      :let b:xr=1
      :let @i=b:xr
    endif
    if CoordIsBeyondEndOfLine(b:xr,b:yr)
      :let b:xr=1
      :let @i=b:xr
    endif

    if !exists('b:ac')
      :let b:ac="r"
    endif
    :let b:ir=1
  endif
endfunction

function! UpdateCursorR()
  ":set scrolloff=25
  call InitR()
  if CoordIsBeyondEndOfLine(b:xr,b:yr)
    let b:xr = col([b:yr,"$"])-1
    if b:xr == 0
      let b:xr=1
    endif
    :let @i=b:xr
  endif
  :call setpos('.',[0]+[b:yr,b:xr]+[0])
  if &modifiable
    try
      :call UnmarkRight()
    catch
    endt
    if exists('b:xl') && exists('b:yl')
      try
        :call MarkLeft(b:xl,b:yl)
      catch
      endt
      try
        :call UpdateRightActiveHl()
      catch
      endt
    endif
  endif
  :let b:ac="r"
  try
    ":exe 'norm! zv'
  catch
  endt
endfunction

function! SetCursorR()
  :let pos=getpos(".")
  :let hand = 'r'
  if !exists('b:x'.hand) || !exists('b:y'.hand) || substitute(execute('echo b:x'.hand),'\n','','g') != pos[2] || substitute(execute('echo b:y'.hand),'\n','','g') != pos[1]
    :doautocmd User CaretMoved
    :doautocmd User RightCaretMoved
  endif

  :let b:xr=pos[2]
  :let b:yr=pos[1]
  :let @i=b:xr
  :let @e=b:yr
  :let b:ac="r"
  "try
    ":call UpdateRightActiveHl()
  "catch
  "endt
endfunction

function! NavVertR()
  if CoordIsBeyondEndOfLine(b:xr,b:yr) && !LineIsOnlySpaces(b:yr) && b:xr != 1
    :call UpdateCursorR()
    :call NavRightR()
  else
    :call UpdateCursorR()
  endif
endfunction

function! NavUpTrimR()
  if &modifiable
    :call InitR()
    if CoordIsAtEndOfLine(b:xr, b:yr) && b:xr!=1 && IsSpace(GetCharAt(b:xr,b:yr))
      :call RemoveTrailingWhiteSpace()
      :call NavUpR()
      :call NavEndLineR()
    else
      :call NavUpR()
      :call RemoveTrailingWhiteSpace()
      :call NavVertR()
    endif
  else
    :call NavUpR()
  endif
endfunction

function! NavDownTrimR()
  if &modifiable
    :call InitR()
    if CoordIsAtEndOfLine(b:xr, b:yr) && b:xr!=1 && IsSpace(GetCharAt(b:xr,b:yr))
      :call RemoveTrailingWhiteSpace()
      :call NavDownR()
      :call NavEndLineR()
    else
      :call NavDownR()
      :call RemoveTrailingWhiteSpace()
      :call NavVertR()
    endif
  else
    :call NavDownR()
  endif
endfunction
"---------------------------- single char

function! NavRightR()
  if &modifiable
    :call InitR()
    if CoordIsAtEndOfLine(b:xr,b:yr)
      if LineIsOnlySpaces(b:yr) && CursorIsAtBeginningOfLine()
        :call AppendSpace()
        :let b:xr+=1
      endif
        :call AppendSpace()
        :exe 'norm! l'
      endif
      :let b:xr+=1
      :let @i=b:xr
      :call UpdateCursorR()
  else
    :norm! l
  endif
endfunction

function! NavLeftR()
  if &modifiable
    if !LineIsOnlySpaces(b:yr)
      :call RemoveTrailingWhiteSpace()
    endif
    :call InitR()
    if b:xr>1
      :let b:xr-=1
      :let @i=b:xr
    endif
    :call UpdateCursorR()
  else
    :norm! h
  endif
endfunction

function! NavUpR()
  if &modifiable
    :call InitR()
    if b:yr>1
      :let b:yr-=1
      :let @e=b:yr
    endif
  else
    :norm! k
  endif
  :doautocmd User CaretMoved
  :doautocmd User RightCaretMoved
endfunction

function! NavDownR()
  if &modifiable
    :call InitR()
    :let b:yr+=1
    :let @e=b:yr
    if b:xr > col([b:yr,"$"])
      :let b:xr=col([b:yr,"$"])
      :let @i=b:xr
    endif
    "if at the bottom of the document make space
    if CursorIsOnLastLineOfBuffer()
      :norm! o
      :call SetCursorR()
    endif
    :call UpdateCursorR()
  else
    :norm! j
  endif
  :doautocmd User CaretMoved
  :doautocmd User RightCaretMoved
endfunction
"---------------------------- word
function! NavLeftWordR()
 if &modifiable
    :call RemoveTrailingWhiteSpace()
    :call InitR()
    :call UpdateCursorR()
    if LineIsOnlySpaces(b:yr)
      :return
    endif
    :exe 'norm! h'
    if IsSpace(GetCharUnderCursor())
      if CursorIsAtFirstNonWhite()
        :exe 'norm! 0'
        :call SetCursorR()
        :return
      endif
      :call NavToPrevNonWhite()
      :exe 'norm! l'
    else
      :exe 'norm! b'
    endif
    :call SetCursorR()
  else
    :exe 'norm! b'
  endif
endfunction

function! NavRightWordR()
  if &modifiable
    :call InitR()
    :call UpdateCursorR()
    if LineIsOnlySpaces(b:yr)
      :call MatchRightIndent()
      :return
    endif
    if IsSpace(GetCharUnderCursor())
      :call NavToNextNonWhite()
    else
      :exe 'norm! el'
    endif
    :call SetCursorR()
    if CoordIsAtEndOfLine(b:xr,b:yr)
      :call AppendSpace()
      :exe 'norm! l'
    endif
    :call SetCursorR()
  else
    :exe 'norm! lel'
  endif
endfunction
"---------------------------- end line
function! NavEndLineR()
  if &modifiable
    :call InitR()
    :call UpdateCursorR()
    if LineIsOnlySpaces(b:yr)
      :call MatchRightIndent()
      :return
    endif
    :exe 'norm! $'
    :call SetCursorR()
    if CoordIsAtEndOfLine(b:xr,b:yr)
      :call AppendSpace()
      :exe 'norm! l'
    endif
    :call SetCursorR()
  else
    :exe 'norm! $'
  endif
endfunction

function! NavBeginningLineR()
  if &modifiable
    :call InitR()
    :call UpdateCursorR()
    if CursorIsAtFirstNonWhite()
      :exe 'norm! 0'
    else
      :exe 'norm! ^'
    endif
    :call SetCursorR()
  else
    :exe 'norm! 0'
  endif
endfunction


function! NavBeginningDocR()
  if &modifiable
    :call InitR()
    :silent call RemoveTrailingWhiteSpace()
  endif
  :norm! gg
  :call SetCursorR()
endfunction

function! NavEndDocR()
  if &modifiable
    :call InitR()
    :silent call RemoveTrailingWhiteSpace()
  endif
  :norm! G
  :call SetCursorR()
endfunction




