
function! SourceAll(path)
  for f in split(glob(a:path), '\n')
    if !isdirectory(f)
      :exe 'source' f
    endif
  endfor
endfunction


"function TrimWhitespace(a_str)
  ":return substitute(a:a_str, '\n', '', 'g')
"endfunction

function! RemoveTrailingWhiteSpace()
"whitespaces do not exist - !!!search('\v\s+$', 'cwn')
if !!!search('\v\s+$', 'cwn') || !&modifiable
  return
endif
try
  :let _s=@/
  try
    :undojoin | %s/\s\+$//e
  catch
    :%s/\s\+$//e
  endt
  :let @/=_s
endt
endfunction

function! AppendSpace()
  try
    :undojoin | call setline('.', getline('.').' ')
    ":undojoin | call append(' ')
  catch
    :call setline('.', getline('.').' ')
    ":call append(' ')
  endt
endfunction

function! PrependSpace()
  try
    :undojoin | call setline('.', ' '.getline('.'))
  catch
    :call setline('.', ' '.getline('.'))
  endt
endfunction


function! PromptChar()
  return nr2char(getchar())
endfunction

function! PromptInput(...)
  if a:0 > 0
    :let prompt=a:1
  else
    :let prompt=""
  endif
  if a:0 > 1
    :let text=a:2
  else
    :let text=""
  endif
  :call inputsave()
  :let ret=input(prompt,text)
  :call inputrestore()
  :return ret
endfunction

command! -nargs=* D call Deb(<args>)
function! Deb(...)
  if g:debug
    :let ret=input("Debug:".string(a:000))
  endif
endfunction

function! GetCharWithTimeout(...)
  let time = 30
  if a:0 >0
    :let time = a:1
  endif
  :let n=getchar(0)
  :let count=0
  while n == 0 && count < time
    :let n=getchar(0)
    :let count+=1
    :sleep 10m
  endwhile
  :return n
endfunction

function! SanitizeSearchString(str)
  :let search=a:str
  if search == "."
    :let search = "\\."
  endif
  if search == "$"
    :let search = "\\$"
  endif
  if search == "/"
    :let search = "\\/"
  endif
  if search == "//"
    :let search = "\\/\\/"
  endif
  :return search
endfunction

function! SearchForStringF(str)
  :let search=SanitizeSearchString(a:str)
  :let @j=search
  "note yo,u got these characters by recording a macro /<C-r>j then "qp where q
  "is the macro register
  "you can also get them by doing ctrl+v ctrl+r or m
  ":norm! /j

  :silent exe 'norm! /j'
endfunction


function! SearchForStringB(str)
  :let search=SanitizeSearchString(a:str)
  :let @j=search
  :silent exe 'norm! ?j'
endfunction


"-------------------------------------------------
function! StringContains(in_str,value)
  :return stridx(a:in_str,a:value) != -1
endfunction

function! StringStartsWith(in_str, value) abort
  return a:in_str[0:len(a:value)-1] ==# a:value
endfunction

function GetBufferNums()
  :let list = execute('ls')
  :let ret = []
  for line in split(list,'\n')
    :call add(ret,split(line,' ')[0])
  endfor
  :return ret
endfunction

"------------------------------------------------- plugins
function! PluginLoaded(existing_path)
  :redir @a
  :silent scriptnames
  :redir END
  :return StringContains(@a,a:existing_path)
endfunction

function AddLineHighlightGroup(y,name,id)
  "try
    :call matchaddpos(a:name,[a:y,1,120],10,a:id)
  "catch
  "endt
endfunction
    ":let b:rrm = matchaddpos("right_row",[[a:y]])

function ClearHighlightGroup(id)
   try
    :call matchdelete(a:id)
   catch
      ":call clearmatches()
    endt
endfunction


function! ShowStatusMessage(message,...)
  hi StatusLine ctermbg=blue ctermfg=white
  let $t=string(a:message)
  let $t=substitute($t," ","\\\\ ","g")
  set laststatus=2
  :exe "set statusline=%{".$t."}"
  ":exe "set statusline=".$t
  "if IsString($t)
    "set statusline=$t
  "else
    "set statusline=%{$t}
  "endif
endfunction


function! Eval(exprs)
  for expr in a:exprs
    ":silent exe expr
    :exe expr
  endfor
endfunction


function! ExitVim()
  :q!
  endfunction

function! TerminalExit(job_id, data, event)
  "delete weird buffer left over from the terminal process
  :bdelete!
  if $then != ""
    :let Then = function($then)
    :call Then()
    :let $then=""
  endif
  if $then2 != ""
    :let Then = function($then2)
    :call Then()
    :let $then2=""
  endif
endfunction

function Async(func_name)
  :call jobstart('sendCommandToVim "call '.a:func_name.')"')
endfunction

function! Run(cmd)
  :silent exe '!echo "'.a:cmd.'" >> /tmp/vimcmd'
  :silent exe '!'.a:cmd
endfunction

function! RunCmdStr(cmd_str,then)
  :let $cmd_str = a:cmd_str
  :let $then2=a:then
  :enew
  :call clearmatches()
  :silent exe '!echo "$cmd_str" >> /tmp/vimcmd'
  :call termopen($cmd_str,{'on_exit':'TerminalExit'})
endfunction

function! RunTerminalCmd(buildCmd,then,...)
  :let percent = 0
  :let float = 0
  if a:0 >0
    if a:1 == 'f'
      :let float = 1
    else
      :let percent = a:1
    endif
  endif

  :let BuildCmd = function(a:buildCmd)
  :let $cmd_str = BuildCmd()
  :let $then=a:then
  :enew
  ":let $shell_id = system('echo $$')
  ":e /tmp/$shell_id
  :call clearmatches()
  :silent exe '!echo "$cmd_str" >> /tmp/vimcmd'
  :call termopen($cmd_str,{'on_exit':'TerminalExit'})
endfunction

function! RunTerminalCmd2(buildCmd,then,...)
  :let percent = 0
  :let float = 0
  if a:0 >0
    if a:1 == 'f'
      :let float = 1
    else
      :let percent = a:1
    endif
  endif

  :let BuildCmd = function(a:buildCmd)
  :let $cmd_str = BuildCmd()
  :let $then=""
  :let $then2=a:then
  :enew
  ":let $shell_id = system('echo $$')
  ":e /tmp/$shell_id
  :call clearmatches()
  :silent exe '!echo "$cmd_str" >> /tmp/vimcmd'
  :call termopen($cmd_str,{'on_exit':'TerminalExit'})
endfunction


function GetNumberOfOpenBuffers()
  :return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

function! GetNumLinesInBuffer()
  :return line('$')
endfunction


function! GetMachineName()
  :sil exe '!cat /etc/hostname > /tmp/hostname'
  :return Read('/tmp/hostname')
endfunction

function! GotoProjRoot()
  :exe 'cd '.GetCurrDir()
endfunction

function! GetInput(prompt_message,default_value)
  :call inputsave()
  :let ret=input(a:prompt_message,a:default_value)
  :call inputrestore()
  :return ret
endfunction

function! GetSelectedText()
  ":let l1=getpos("'<")
  ":let x1=l1[2]
  ":let y1=l1[1]

  ":let l2=getpos("'>")
  ":let x2=l2[2]
  ":let y2=l2[1]
  :norm! `<v`>"jy
  return @j
endfunction

function! HighlightLine(line_number,hi_group)
  return matchaddpos(a:hi_group,[[a:line_number]])
endfunction

function! UncolorBuffer()
  for hl in g:color_hls
    if  hl > 0
      :call matchdelete(hl)
    endif
  endfor
endfunction


function! ColorBuffer()
  :let i=1
  :let num_lines = line('$')
  :let g:color_hls = []
  while i<num_lines
    try
      :call add(g:color_hls,Color(i))
    catch
    endtry
    :let i=i+1
  endwhile
endfunction

function! Color(line_number)
  ":call ParseColor(getline('.'))
  :let colors = ParseColor(getline(a:line_number))
  if len(colors) > 0
    :exe 'hi '.a:line_number.' ctermbg='.colors[0].' ctermfg='.colors[1]
    :return matchaddpos(string(a:line_number),[[a:line_number]])
  endif
  ":echo getline('.')
endfunction

function! ParseColor(str)
  :let str_split = split(a:str,'"color')
  if len(str_split) == 2
    :let str_split2 = split(str_split[1])
    :let bg = split(str_split2[0],"=")[1]
    :let fg = split(str_split2[1],"=")[1]
    ":call ShowStatusMessage(fg)
    :call ShowStatusMessage(string(str_split2))
    :return [bg,fg]
  endif
  :return []
endfunction

function! HostName()
  return system("echo -n $HOSTNAME")
endfunction

"useful. not being used anywhere
"function! ReturnHighlightTerm(group, term)
   "let output = execute('hi ' . a:group)
   "return matchstr(output, a:term.'=\zs\S*')
"endfunction


function SetScrollLimit()
  if exists('b:scroll_limit')
    :exe 'set scrolloff='.b:scroll_limit
  else
    if IsReadOnlyFile()
      :exe 'set scrolloff=999'
    else
      :exe 'set scrolloff=25'
    endif
  endif
endfunction

function UnsetScrollLimit()
  ":let b:scroll_limit = &scrolloff
  "if b:scroll_limit == 0
    if IsReadOnlyFile()
      :let b:scroll_limit = 999
    else
      :let b:scroll_limit = 25
    endif
  "endif
  :exe 'set scrolloff=0'
endfunction

"=============================================================== containers
function! ForEach(container,action)
  let i = 0
  :let Action = function(a:action)
  while i < len(a:container)
    call Action(a:container[i],i)
    let i += 1
  endwhile
endfunction

function Filter(container,action)
  "writing this for two reasons. 1) builtin makes modifications to the container in place
  "2)builtin leaves 'null' values in where things were filtered out. actually 2) is probably not true,
  "though 3) builtin requires you to pass in an index parameter which would rarely every be used

  if type(a:container) == type({})
    :throw 'Filter:{} not supported'
  endif
  if type(a:container) == type([])
    :let i = 0
    :let Action = function(a:action)
    :let ret = []
    while i < len(a:container)
      if Action(a:container[i],i)
        :call add(ret,a:container[i])
      endif
      :let i += 1
    endwhile
    :return ret
  endif

  :throw 'Filter:wrong type '.string(a:container)
endfunction

function! Contains(container,value)
   if type(a:value) == type({->0})
     :let i = 0
     :let found = 0
     for val in a:container
       if a:value(val,i)
         :let found = 1
         :break
       endif
       :let i += 1
     endfor
     :return found
   else
     :return index(a:container,a:value) != -1
   endif
endfunction

function! LastValue(container)
  :return a:container[len(a:container)-1]
endfunction

function! Pop(container)
  :let ret = LastValue(a:container)
  :call remove(a:container,len(a:container)-1)
  :return ret
endfunction

function! Switch(condition,...)
  for then in a:000
    if function(a:condition)(then[0])
      :let F = function(then[1])
      :return F('_')
    endif
  endfor
endfunction

function! Function1367()
  :echo Switch({x->x==1},
  \[1,{->1}],
  \[2,{->2}],
  \)
  ":call Switch({x->x==1},[1,{->echo 2}],[2,{->echo 2}])
  :call Switch({x->x==1},[1,{x->2}],[2,{x->2}])
  ":call Switch({x->x==1},{1:{->echo 2}},{2:{->echo 2}})
  ":call Switch(1,{1:{->echo 2}},{2:{->echo 2}})
  ":call Switch({x->x==1},1,2,3)
endfunction

function! Function13()
  :let sum = 0
  for val in values({'a':1,'b':2})
    :let sum += val
  endfor
  :return sum
endfunction

function! Function135()
  :let sum = 0
  function! Function136(v,i)
    :let sum+=a:v
  endfunction
  ":call ForEach([1,2,3],{v,_->sum+=v})
  :call ForEach([1,2,3],'Function136')
  ":call ForEach([1,2,3],{v,_->v+1})
  :return sum
endfunction


"function Menu(...)
  "example how to accept eithe vargs or array
  "if type(a:000[0])==type([])
    ":let items = a:000[0]
  "else
    ":let items = a:000
  "endif
"endfunction

"leave this code around until you've libraryized sending keys to vim. the escaping was a nightmare to figure output
"think the magic bullet was putting ! in the command string then not having to "" the exe call
":let $cmd_str="!nvr --servername /tmp/vim".pinned_index." ".$output
"if $line != ""
  "let $cmd_str=$cmd_str." --remote-send \"\'call setpos('.',[0]+[".$line.",1]+[0])<CR>\'call g:SetCursor()<CR>\""
"endif
":sil exe $cmd_str


