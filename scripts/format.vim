
function! GetIndentLevel(y)
  :let line = getline(a:y)
  :let x = 0
  while x < GetLastRowX(a:y)
    if !IsSpace(line[x])
      :break
    endif
    :let x+=1
  endwhile
  :return x
endfunction

function! MatchIndent()
  :let pos = getpos('.')
  :let x_initial = pos[2]
  :let y_initial = pos[1]

  :exe 'norm! k0'
  :let line = getline('.')
  :let x = 1
  :let quit=0
  while !quit
    if line[x] == ''
      if getpos('.')[1] == 1
          :let quit = 1
          :break
        endif
        :let x = 1
        :exe 'norm! k0'
        :let line = getline('.')
        :continue
    endif
    while IsSpace(line[x-1])
      :let x+=1
      :exe 'norm! l'
      if getpos('.')[2] == 1
        if getpos('.')[1] == 1
          :let quit = 1
          :break
        endif
        :let x = 1
        :exe 'norm! k0'
        :let line = getline('.')
      endif
    endwhile
    let quit=1
  endwhile
  :let orig_x = x
  :call setpos('.',[0]+[y_initial,x_initial]+[0])
  :exe 'norm! ^'
  :let x_curr = getpos('.')[2]
  if x_curr < x
    while x_curr < x
      :call PrependSpace()
      :let x_curr += 1
    endwhile
  endif
  if x_curr > x
    while x_curr > x
    try
      :undojoin | exe 'norm! dh'
    catch
      :exe 'norm! dh'
    endt
      :let x_curr -= 1
    endwhile
    if orig_x == 1
      try
        :undojoin | exe 'norm! dh'
      catch
        :exe 'norm! dh'
      endt
    endif
    endif
  :exe 'norm! ^'
  :call SetCursor()
endfunction

function! MatchRightIndent()
  :let pos = getpos('.')
  :let x_initial = pos[2]
  :let y_initial = pos[1]
  :let line = getline('.')
  if LineIsOnlySpaces(y_initial)
    :call setline(y_initial,"")
    :let line = ""
  endif
  if line != ""
    :return
  endif
  :exe 'norm! k0'
  :let line = getline('.')
  :let x = 1
  :let quit=0
  while !quit
    if line[x] == ''
      if getpos('.')[1] == 1
        :break
      endif
      :let x = 1
      :exe 'norm! k0'
      :let line = getline('.')
      :continue
    endif
    while IsSpace(line[x-1])
      :let x+=1
      :exe 'norm! l'
      if getpos('.')[2] == 1
        if getpos('.')[1] == 1
          :let quit = 1
          :break
        endif
        :let x = 1
        :exe 'norm! k0'
        :let line = getline('.')
      endif
    endwhile
    let quit=1
  endwhile
  :let orig_x = x
  :call setpos('.',[0]+[y_initial,x_initial]+[0])
  :exe 'norm! ^'
  :let x_curr = getpos('.')[2]
  if x_curr < x
    while x_curr < x+1
      :call PrependSpace()
      :let x_curr += 1
    endwhile
  endif

  :exe 'norm! ^'
  :call SetCursor()
endfunction

function! IMatchIndent()
  :call MatchRightIndent()
  if &ft == 'vim' && LineIsOnlySpaces(GetCurrY()) && GetCurrX() != 1
    :exe 'norm! r:'
    :call AppendSpace()
    :exe 'norm! l'
  endif

endfunction


function! ShiftRight()
  :let num=&shiftwidth
  :let i=0
  while i<num
    :call PrependSpace()
    :call NavRight()
    :let i+=1
  endwhile
endfunction

function! ShiftLeft()
  :let num=&shiftwidth
  :let i=0
  while i<num
    try
      :undojoin | exe 'norm! ^dh'
    catch
      :exe 'norm! ^dh'
    endt
    :call NavLeft()
    :let i+=1
  endwhile
endfunction

"============================================================ bindings
":nnoremap <A-1> :call MatchIndent()<CR>:call NavDown()<CR>
":nnoremap <A-2> :call MatchIndent()<CR>
":nnoremap ¡ :call MatchIndent()<CR>:call NavDown()<CR>
":nnoremap <A-z> :call ShiftLeft()<CR>
":nnoremap <A-x> :call ShiftRight()<CR>
":nnoremap æ :call ShiftLeft()<CR>
":nnoremap đ :call ShiftRight()<CR>

"using DeleteWordBackwards in favor of this
":inoremap <A-z> <ESC>:call ShiftLeft()<CR>i
":inoremap <A-x> <ESC>:call ShiftRight()<CR>i
":inoremap æ <ESC>:call ShiftLeft()<CR>i
":inoremap đ <ESC>:call ShiftRight()<CR>i
":inoremap <A-x> <ESC>:exe 'norm i '<CR>:exe 'norm i '<CR>:exe 'norm i '<CR>:exe 'norm i '<CR>i



":nnoremap <C-z> :call ShiftLeft()<CR>:call NavDown()<CR>
":nnoremap <C-x> :call ShiftRight()<CR>:call NavDown()<CR>

":inoremap <silent> <Insert> <Space><ESC>:call MatchIndent()<CR>i
":inoremap <silent> <Insert> <C-o>^

