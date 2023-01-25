:hi left  ctermbg=144 ctermfg=238
function! MarkLeft(x,y)
  :call UnmarkLeft()
  if b:yr != b:yl
    :let b:lrm = matchaddpos("left_row",[[a:y]])
  endif
  :let b:lm = matchaddpos("left",[[a:y,a:x]])
endfunction

function! UnmarkLeft()
  if exists('b:lm')
   try
    :call matchdelete(b:lm)
   catch
      :call clearmatches()
    endt
  endif
  if exists('b:lrm')
   try
    :call matchdelete(b:lrm)
   catch
      :call clearmatches()
   endt
  endif
endfunction

function! InitL()
  if !exists('b:il')
    if @s
      let b:yl=str2nr(@s)
    else
      :let b:yl=1
      :let @s=b:yl
    endif
    if b:yl >= line('$')
      :let b:yl = 1
      :let @s=b:yl
    endif

    if @t
      let b:xl=str2nr(@t)
    else
      :let b:xl=1
      :let @t=b:xl
    endif
    if CoordIsBeyondEndOfLine(b:xl,b:yl)
      :let b:xl=1
      :let @t=b:xl
    endif

    if !exists('b:ac')
      :let b:ac="l"
    endif
    :let b:il=1
  endif
endfunction

function! UpdateCursorL()
  :set scrolloff=25
  :call InitL()
  "if CoordIsBeyondEndOfLine(b:xl,b:yl)
    "let b:xl = col([b:yl,"$"])-1
    "if b:xl == 0
      "let b:xl=1
    "endif
    ":let @t=b:xl
  "endif
  ":call setpos('.',[0]+[b:yl,b:xl]+[0])
  "if !exists('g:vscode') && &modifiable
    ":call UnmarkLeft()
    "if exists('b:xr') && exists('b:yr')
      ":call MarkRight(b:xr,b:yr)
      "try
        "call UpdateLeftActiveHl()
      "catch
      "endt
    "endif
  "endif
  :let b:ac="l"
 try
   ":exe 'norm! zv'
 catch
   :
 endt
endfunction

function! SetCursorL()
  :let pos=getpos(".")
  :let b:xl=pos[2]
  :let b:yl=pos[1]
  :let @t=b:xl
  :let @s=b:yl
  :let b:ac="l"
  try
    :call UpdateLeftActiveHl()
  catch
  endt
endfunction

function! NavVertL()
  if CoordIsBeyondEndOfLine(b:xl,b:yl) && !LineIsOnlySpaces(b:yl) && b:xl != 1
    :call UpdateCursorL()
    :call NavRightL()
  else
    :call UpdateCursorL()
  endif
endfunction

function! NavUpTrimL()
  if &modifiable
    :call InitR()
    if CoordIsAtEndOfLine(b:xl, b:yl) && b:xl!=1 && IsSpace(GetCharAt(b:xl,b:yl))
      :call RemoveTrailingWhiteSpace()
      :call NavUpL()
      :call NavEndLineL()
    else
      :call NavUpL()
      :call RemoveTrailingWhiteSpace()
      :call NavVertL()
    endif
  else
    :call NavUpL()
  endif
endfunction

function! NavDownTrimL()
  if &modifiable
    :call InitL()
    if CoordIsAtEndOfLine(b:xl, b:yl) && b:xl!=1 && IsSpace(GetCharAt(b:xl,b:yl))
      :call RemoveTrailingWhiteSpace()
      :call NavDownL()
      :call NavEndLineL()
    else
      :call NavDownL()
      :call RemoveTrailingWhiteSpace()
      :call NavVertL()
    endif
  else
    :call NavDownL()
  endif

endfunction
"---------------------------- single char

function! NavRightL()
  "if &modifiable
    ":call InitL()
    "if CoordIsAtEndOfLine(b:xl,b:yl)
      "if LineIsOnlySpaces(b:yl) && CursorIsAtBeginningOfLine()
        ":call AppendSpace()
        ":let b:xl+=1
      "endif
        ":call AppendSpace()
        ":exe 'norm! l'
      "endif
      ":let b:xl+=1
      ":let @t=b:xl
      :call UpdateCursorL()
  "else
    ":norm! l
  "endif
  :sil exe 'norm! l'
endfunction

function! NavLeftL()
  "if &modifiable
    "if !LineIsOnlySpaces(b:yl)
      ":call RemoveTrailingWhiteSpace()
    "endif
    ":call InitL()
    "if b:xl>1
      ":let b:xl-=1
      ":let @t=b:xl
    "endif
    ":call UpdateCursorL()
  "else
    ":norm! h
  "endif
  :sil exe 'norm! h'
endfunction

function! NavUpL()
  "if &modifiable
    ":call InitL()
    "if b:yl>1
      ":let b:yl-=1
      ":let @s=b:yl
    "endif
  "else
    ":norm! k
  "endif
  :sil exe 'norm! k'
endfunction

function! NavDownL()
  "if &modifiable
    ":call g:InitL()
    ":let b:yl+=1
    ":let @s=b:yl
    "if b:xl > col([b:yl,"$"])
      ":let b:xl=col([b:yl,"$"])
      ":let @t=b:xl
    "endif
    "if at the bottom of the document make space
    "if CursorIsOnLastLineOfBuffer()
      ":norm! o
      ":call SetCursorL()
    "endif
    ":call UpdateCursorL()
  "else
    ":norm! j
  "endif
  :sil exe 'norm! j'
endfunction

"---------------------------- word
function! NavLeftWordL()
 if &modifiable
    :call RemoveTrailingWhiteSpace()
    :call InitL()
    :call UpdateCursorL()
    if LineIsOnlySpaces(b:yl)
      :return
    endif
    :exe 'norm! h'
    if IsSpace(GetCharUnderCursor())
      if CursorIsAtFirstNonWhite()
        :exe 'norm! 0'
        :call SetCursorL()
        :return
      endif
      :call NavToPrevNonWhite()
      :exe 'norm! l'
    else
      :exe 'norm! b'
    endif
    :call SetCursorL()
  else
    :exe 'norm! b'
  endif
endfunction

function! NavRightWordL()
  if &modifiable
    :call InitL()
    :call UpdateCursorL()
    if LineIsOnlySpaces(b:yl)
      :call MatchRightIndent()
      :return
    endif
    if IsSpace(GetCharUnderCursor())
      :call NavToNextNonWhite()
    else
      :exe 'norm! el'
    endif
    :call SetCursorL()
    if CoordIsAtEndOfLine(b:xl,b:yl)
      :call AppendSpace()
      :exe 'norm! l'
    endif
    :call SetCursorL()
  else
    :exe 'norm! lel'
  endif
endfunction
"---------------------------- end line
function! NavEndLineL()
  if &modifiable
    :call InitL()
    :call UpdateCursorL()
    if LineIsOnlySpaces(b:yl)
      :call MatchRightIndent()
      :return
    endif

    :exe 'norm! $'
    :call SetCursorL()
    if CoordIsAtEndOfLine(b:xl,b:yl)
      :call AppendSpace()
      :exe 'norm! l'
    endif
    :call SetCursorL()
  endif
endfunction

function! NavBeginningLineL()
  if &modifiable
    :call InitL()
    :call UpdateCursorL()
    if CursorIsAtFirstNonWhite()
      :exe 'norm! 0'
    else
      :exe 'norm! ^'
    endif
    :call SetCursorL()
  else
    :exe 'norm! 0'
  endif
endfunction


function! NavBeginningDocL()
  if &modifiable
    :call InitL()
    :silent call RemoveTrailingWhiteSpace()
  endif
  :norm! gg
  :call SetCursorL()
endfunction

function! NavEndDocL()
  if &modifiable
    :call InitL()
    :silent call RemoveTrailingWhiteSpace()
  endif
  :norm! G
  :call SetCursorL()
endfunction

