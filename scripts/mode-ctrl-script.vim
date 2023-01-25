function! EnterInsert()
  :let pos=getpos('.')
  if exists('b:yr') && pos[1]==b:yr && pos[2]==b:xr
    :let b:is="r"
  else
  if exists('b:yl') && pos[1]==b:yl && pos[2]==b:xl
    :let b:is="l"
  endif
  endif
 " :norm! i
 "
endfunction

function! ExitInsert()
  "real whack-a-mole-problem with this
  "if !CursorIsAtBeginningOfLine()
  ":exe 'norm! l'
  "endif
  if b:xr>1
    :call SetCursor()
    :call NavRight()
  else
    if GetCurrX()>1
    :call SetCursor()
    :call NavRight()
    endif
  endif
  ":call UpdateNeutralActiveHl()
  :exe 'norm! zv'
endfunction


function EnterCommandMode()
  :let b:last_search=@/
endfunction


function ExitCommandMode(...)
  :let hand = 'n'
  if a:0>0
    :let hand = a:000[0]
  endif
  "if @/==b:last_search
  if exists('b:search_mode') && b:search_mode
    ":call feedkeys("<\CR>gn<\CR>",'n')
    ":call feedkeys("<\CR>gn",'n')
    :sil exe "norm! <\CR>gngn"
    :call SetCursor(hand)
    :call UpdateCursor(hand)
  elseif exists('b:last_search') && @/==b:last_search
    :sil exe 'norm! gn'
    :call SetCursor()
  else
    :call SetCursor()
  endif
  :exe 'norm! zv'
endfunction

function EnterSearch()
  if !exists('b:search_mode')
    :let b:search_mode = 1
  endif
  :if b:search_mode ==# 1
    :call fuzzysearch#start_search("")
  else
    :call feedkeys('/','n')
  endif
endfunction

function ToggleSearch()
  :let b:search_mode = !b:search_mode
  :if b:search_mode ==# 1
    :call fuzzysearch#start_search(@/)
  else
    :call feedkeys('/'.@/,'n')
  endif
endfunction


