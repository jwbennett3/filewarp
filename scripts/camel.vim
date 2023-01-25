
function! CamelForward()
   :exe 'norm! l'
  :let pos=getpos('.')
  :let i=pos[2]
  :let x = GetCurrX()
  if IsUpper(GetCharUnderCursor())
    :let curr_case = 'u'
  else
    :let curr_case = 'l'
  endif
  while i<col("$")
    :let last_case = curr_case
    :let n=char2nr(getline('.')[i])
    :let i+=1
    if !IsAlpha(n)
      :break
    endif
    if IsUpper(n)
      :let curr_case = 'u'
    else
      :let curr_case = 'l'
    endif
    "if last_case != curr_case
    if last_case == 'l' && curr_case == 'u'
      :break
    endif
  endwhile
  if b:ac == "r"
    :let b:xr=i
    :call UpdateCursorR()
  endif
  if b:ac == "l"
    :let b:xl=i
    :call UpdateCursorL()
  endif
  if CursorIsAtEndOfLine()
    :call NavRight()
  endif
endfunction


function! CamelBackward()
  exe 'norm! h'
  :let pos=getpos('.')
  :let i=pos[2]-2
  :let x = GetCurrX()
  if IsUpper(GetCharUnderCursor())
    :let curr_case = 'u'
  else
    :let curr_case = 'l'
 endif

  while i>0
    :let last_case = curr_case
    :let n=char2nr(getline('.')[i])
    if !IsAlpha(n)
      :break
    endif
    if IsUpper(n)
      :let curr_case = 'u'
    else
      :let curr_case = 'l'
    endif
    if last_case == 'l' && curr_case == 'u'
      :break
    endif
    :let i-=1
  endwhile
  if b:ac == "r"
    :let b:xr=i+1
    :call UpdateCursorR()
  endif
  if b:ac == "l"
    :let b:xl=i+1
    :call UpdateCursorL()
  endif
  ":echo ''.x.' '.GetCurrX()
  if IsSpace(GetCharUnderCursor())
    if x==GetCurrX()+1
    else
      :call NavRight()
    endif
  endif
endfunction

"function! CamelDelete()
  ":let pos=getpos('.')
  ":let i=pos[2]
  "while i<col("$")
    ":let n=char2nr(getline('.')[i])
    ":let i+=1
    ":norm! x
    "if n>32 && n<97 || n==95 || IsSpace(n)
      ":break
    "endif
  "endwhile
"endfunction


"function! CamelBackspace()
  ":let pos=getpos('.')
  ":let i=pos[2]-1
"":let i=pos[2]
  ":let x=i
  ":let c=0
  "while i>1
    ":let n=char2nr(getline('.')[i])
    "if IsSymbolOrCaps(n)
      ":break
    "endif
    ":let i-=1
    ":let c+=1
  "endwhile
  "while c>0
    ":norm! dh
    ":let c-=1
  "endwhile
  ":call SetCursor()
"endfunction

function CamelDelete()
  :call DeleteTo(0,["call CamelForward()"],"call SetCursor()")
endfunction

function CamelBackspace()
  :call DeleteTo(1,["call CamelBackward()"],"call SetCursor()")
endfunction






