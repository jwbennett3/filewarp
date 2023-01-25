
func! DumpToStdout(str)
    "redi! > /dev/stdout
     redi! > /tmp/abc
    :echo a:str
     ":sil exe '!echo -e "'.a:str.'"'
    redi END
endfunc


function CursorIsAtBeginningOfLine()
  :let pos=getpos('.')
  return pos[2] == 1
endfunction

function CursorIsAtEndOfLine()
  :let pos=getpos('.')
  return pos[2] == col([pos[1],"$"])-1
  "return pos[2] == col([pos[1],"$"])
endfunction

function! CoordIsAtBeginningOfLine(x,y)
  :let num_cols = col([a:y,"$"])-1
  return num_cols==0 || a:x == num_cols
endfunction


function! CoordIsAtEndOfLine(x,y)
  :let num_cols = col([a:y,"$"])-1
  return num_cols==0 || a:x == num_cols
endfunction


"Rename GetFirstScreenY
function! FirstScreenY()
  :exe 'norm! H'
  :let y = GetCurrY()
  :call UpdateCursor()
  :let ret =  y - &scrolloff
  if ret <= 0
    :let ret = 1
  endif
  :return ret
endfunction
"Rename GetLastScreenY
function! LastScreenY()
  :exe 'norm! L'
  :let y = GetCurrY()
  :call UpdateCursor()
  :let ret = y + &scrolloff
  if ret > line('$')
    :let ret = line('$')
  endif
  :return ret
endfunction


function! GetFirstScreenY()
exe 'norm! H'
  :let y = GetCurrY()
  :call UpdateCursor()
  :let ret =  y - &scrolloff
  if ret <= 0
    :let ret = 1
  endif
  :return ret
endfunction


function! GetLastScreenY()
  :exe 'norm! L'
  :let y = GetCurrY()
  :call UpdateCursor()
  :let ret = y + &scrolloff
  :if ret > line('$')
    :let ret = line('$')
  endif
  :return ret
endfunction

function! GetLastRowX(...)
  if a:0 > 0
    :return strlen(getline(a:000[0]))
  else
    :return strlen(getline(GetCurrY()))
  endif
endfunction

function! GetMaxWidth()
  :let widths = map(getline(1, '$'), 'strdisplaywidth(v:val)')
  :let maxWidth = max(widths)
  :let longestLines = filter(map(copy(widths), 'v:val == maxWidth ? (v:key + 1) : ""'), '! empty(v:val)')
  :return maxWidth
endfunction

function! ScreenHeight()
  :return LastScreenY() - FirstScreenY()
endfunction


function! GetCurrX()
  return getpos('.')[2]
endfunction

function! GetCurrY()
  return getpos('.')[1]
endfunction

function! SetCaretPos(line,col)
  call setpos('.',[0,a:line,a:col,0])
endfunction


function! GetCharUnderCursor()
  let pos=getpos('.')
  return getline('.')[pos[2]-1]
endfunction

function! GetCharAt(x,y)
  let pos=getpos('.')
  return getline(a:y)[a:x-1]
endfunction


function! GetLineUnderCursor()
  let pos=getpos('.')
  return getline('.')[pos[2]-1]
endfunction

function! SetCharUnderCursor(char)
  :let pos=getpos('.')
  :let line = getline('.')
  :let x = pos[2]-1
  if CursorIsAtBeginningOfLine()
    :call setline('.',a:char.line[x+1:len(line)])
  else
    :call setline('.',line[0:x-1].a:char.line[x+1:len(line)])
  endif
endfunction


function GetWordUnderCursor()
  return expand('<cword>')
endfunction

"------------------------------------------------- fileops

function! FileHasNoName()
  return expand('%:t') == ""
endfunction

function! Exists(path)
  :return ! empty(glob(a:path))
endfunction

function! IsFile(path)
  ":let $is_file=0
  ":silent exe '!if [[ -f "'.a:path.'" ]];then export is_file=1; else export is_file=0; fi'
  if filereadable(a:path)
    :return 1
  endif
  :return 0
endfunction

function! IsDir(path)
  if finddir(a:path,'')
    :return 1
  endif
  :return 0
endfunction

function! IsReadOnlyFile()
  if &readonly == 1 || @% == "" || &ft == "help" ||&buftype == "nofile" || expand('%:t') == "" || len(matchstr(expand('%:t'), "undotree"))!=0
    :return 1
  else
    :return 0
  endif
endfunction



function CleanFilePath(path)
  "let file_path = substitute(a:path,'\n','','g')
  let file_path = a:path
  let file_path = substitute(file_path,"\n","","")
  "let file_path = system('realpath '.file_path)
  let file_path = substitute(file_path,"//","/","")
  let file_path = substitute(file_path,"/optimus","","")
  let file_path = substitute(file_path,"/data/cloud/config","/config","")
  let file_path = substitute(file_path,"/home/joe/config","/config","")
  let file_path = substitute(file_path,"/home/neon/config","/config","")
  let file_path = substitute(file_path,"/data/gitfiles","/gitfiles","")
  let file_path = substitute(file_path,"/data/code","/code","")

  let file_path = substitute(file_path,"/mnt/drive1","","")
  let file_path = substitute(file_path,"/home/joe/links/symboldragon","/symboldragon","")
  let file_path = substitute(file_path,"/home/joe/links/gitfiles","/gitfiles","")
  return file_path
endfunction

function GetFilePath()
  let file_path = expand('%:p')
  return CleanFilePath(file_path)
endfunction

function GetFileName()
  return fnamemodify(expand('%:t'),':r')
endfunction


"function! g:GetCurrDir()
  "return expand('%:h')
"endfunction

function! GetCurrDir()
  return expand('%:p:h')
endfunction

