

function GoNext()
  try
    :exe 'norm! mmn'
  catch
    :return
  endt
  ":call AddCurrLocationToJumps()
  :exe 'norm! `m'

  :set hlsearch
  if CursorIsAtEndOfLine()
    :exe 'norm! `>0jgn'
  else
    :let pos = getpos('.')
    :exe 'norm! gn'
    :exe 'norm! v`>'
    :let new_pos = getpos('.')
    if pos[1] == new_pos[1] && pos[2] == new_pos[2]
      :exe 'norm! lgn'
    else
      :exe 'norm! `<gn'
    endif
  endif
  :let b:vmode = 1
  :exe 'norm! zv'
  :lua require('hlslens').start()
endfunction

function! GoPrev()
  ":exe 'norm! mjN'
  ":call AddJump(GetFilePath(), GetCurrY(), GetCurrX())
  ":exe 'norm! `j'

  :set hlsearch
  try
    :exe 'norm! `<gNv`<'
  catch
    :exe 'norm! gNv`<'
  endt
  if CursorIsAtBeginningOfLine()
    :exe 'norm! kgNvgn'
  else
    :let pos = getpos('.')
    :let new_pos = getpos('.')
    "if pos[1] == new_pos[1] && pos[2] == new_pos[2]
      ":exe 'norm! hgN'
    "else
      :exe 'norm! hgNv`<gn`>'
    "endif
    ":norm! gNv`<hgN
  endif
  :let b:vmode = 1
  :exe 'norm! zv'
  :lua require('hlslens').start()
endfunction

function! g:WriteToClipboard()
  :let l1=getpos("'<")
  :let x1=l1[2]
  :let y1=l1[1]

  :let l2=getpos("'>")
  :let x2=l2[2]
  :let y2=l2[1]

  :let text=""
  if y1==y2
    :let text=getline('.')[x1-1:x2-1]
  endif
  ":call inputsave()
  :let @+=PromptInput("Replace:",text)
  ":call inputrestore()
  "TODO clean search string for things like '.'s
  :exe 'norm! gv"+p`>gn'
  :
endfunction
"============================================================ bindings

":vnoremap <LocalLeader>p <ESC>:call g:WriteToClipboard()<CR>ddJump(GetFilePath(), GetCurrY(), GetCurrX())

":vnoremap k v:call AddJump(GetFilePath(), GetCurrY(), GetCurrX())<CR>:call GoNext()<CR>


":vnoremap k v:call GoNext()<CR>
":vnoremap K v:call GoPrev()<CR>

":nnoremap k :call GoNext()<CR>
":nnoremap K :call GoPrev()<CR>

":vnoremap <A-k> <ESC>:call g:PasteInto()<CR>:call g:GoNext()<CR>


