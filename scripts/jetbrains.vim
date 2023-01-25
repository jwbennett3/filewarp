

"function! g:GotoImplementation()
  ":let $file_path=expand('%:p')
  ":let $line=getpos('.')[1]
  ":let $col=getpos('.')[2]
  ":silent exec "!gotoImplementation $line $col"
"endfunction

function! Debug()
  :let $file_path=expand('%:p')
  :silent exec "!debugJetbrains"
endfunction
"function! g:Rename()
  ":let $file_path=expand('%:p')
  ":let $line=getpos('.')[1]
  ":let $col=getpos('.')[2]
  ":silent exec "!renameJetbrains $line $col"
"endfunction

function! ActivateJetbrains()
  :let $file_path=GetFilePath()
  ":let $file_path=substitute($file_path,"/data/cloud/config/launchers","~/links/launchers","")
  ":let $file_path=substitute($file_path,"/data/cloud/config/vim/nvim","~/links/nvim","")
  ":let $file_path=substitute($file_path,"/data/cloud/pythonlib","~/links/pythonlib","")
  ":let $file_path=substitute($file_path,"/optimus","","")
  ":let $file_path=substitute($file_path,"/mnt/drive1/symboldragon","/symboldragon","")
  :let $line=getpos('.')[1]
  :let $col=getpos('.')[2]
  ":silent exec \"!updateOpenedEditors $file_path"
  ":silent exec \"!activateJetbrains $file_path $line $col"
  :call Run("activateJetbrains $file_path $line $col &")
endfunction
function! g:FindUsages()
  :let $file_path=expand('%:p')
  :let $line=getpos('.')[1]
  :let $col=getpos('.')[2]
  :silent exec "!findUsages $line $col"
endfunction
function! g:ShowUsages()
  :let $file_path=expand('%:p')
  :let $line=getpos('.')[1]
  :let $col=getpos('.')[2]
  :silent exec "!showUsages $line $col"
endfunction



