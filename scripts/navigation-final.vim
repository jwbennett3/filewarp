"######################################################################### right
function VNavSearchRightRFinal()
  :call NavSearchHoriz('r',1,'v')
  ":call AddLocationToJumps()
endfunction

function VNavSearchDownRFinal()
  :call NavSearchVert('r',0,'v')
  ":call AddLocationToJumps()
endfunction

function VNavSearchUpRFinal()
  :call NavSearchVert('r',1,'v')
  ":call AddLocationToJumps()
endfunction

function VNavSearchLeftRFinal()
  :call NavSearchHoriz('r',0,'v')
  ":call AddLocationToJumps()
endfunction

"------------------------------------------------- single char
"------------------------------------------------- easymotion
function NavSearchLeftRFinal()
  :call NavSearchHoriz('r',0)
  ":call AddLocationToJumps()
endfunction

function NavSearchDownRFinal()
  :call NavSearchVert('r',0)
  ":call AddLocationToJumps()
endfunction
function NavSearchUpRFinal()
  :call NavSearchVert('r',1)
  ":call AddLocationToJumps()
endfunction

function NavSearchRightRFinal()
  :call NavSearchHoriz('r',1)
  ":call AddLocationToJumps()
endfunction
"------------------------------------------------- word
function NavLeftWordRFinal()
  ":call UpdateCursorR()
  :call NavLeftWordR()
  ":call AddLocationToJumps()
endfunction

function NavRightWordRFinal()
  ":call UpdateCursorR()
  :call NavRightWordR()
  ":call AddLocationToJumps()
endfunction
"------------------------------------------------- end line
function NavBeginningLineRFinal()
  :call NavBeginningLineR()
  ":call SetCursorR()
  ":call AddLocationToJumps()
endfunction

function NavEndLineRFinal()
  :call NavEndLineR()
  ":call SetCursorR()
  ":call AddLocationToJumps()
  function! Function1314()
    :
  endfunction
endfunction

"===============================================================  block
function BlockNavOutRFinal()
  if ScreenCheck('r')
    return
  endif

  :call UpdateCursorR()
  :call BlockNavOut2()
  :call SetCursorR()
  ":call AddLocationToJumps()
endfunction

function BlockNavDownRFinal()
  if ScreenCheck('r')
    return
  endif

  "UpdateCursorR messing with fold state, for some reason AddJump is too
  :call UpdateCursorR()
  :call BlockNavDown2()
  :call SetCursorR()
  ":call AddLocationToJumps()
endfunction

function BlockNavUpRFinal()
  if ScreenCheck('r')
    return
  endif
  :call UpdateCursorR()
  :call BlockNavUp2()
  :call SetCursorR()
  ":call AddLocationToJumps()
endfunction

function BlockNavInRFinal()
  if ScreenCheck('r')
    return
  endif
  :call UpdateCursorR()
  :call BlockNavIn2()
  :call SetCursorR()
  ":call AddLocationToJumps()
endfunction
"------------------------------------------------- local leader
function BlockNavRootRFinal()
  if ScreenCheck('r')
    return
  endif
  :call UpdateCursorR()
  :call BlockNavRoot2()
  :call SetCursorR()
  ":call AddLocationToJumps()
endfunction

function BlockNavBottonRFinal()
  :call UpdateCursorR()
  :call BlockNavBottom2()
  :call SetCursorR()
  ":call AddLocationToJumps()
endfunction


function BlockNavTopRFinal()
  :call UpdateCursorR()
  :call BlockNavTop2()
  :call SetCursorR()
  ":call AddLocationToJumps()
endfunction

function BlockNavLeafRFinal()
  if ScreenCheck('r')
    return
  endif
  :call UpdateCursorR()
  :call BlockNavLeaf2()
  ":call AddLocationToJumps()
endfunction

"######################################################################### left
"===============================================================  block
function BlockNavOutLFinal()
  if ScreenCheck('l')
    return
  endif
  :call UpdateCursorL()
  :call BlockNavOut2()
  :call SetCursorL()
  ":call AddLocationToJumps()
endfunction

function BlockNavDownLFinal()
  if ScreenCheck('l')
    return
  endif
  "UpdateCursorL messing with fold state, for some reason AddJump is too
  :call UpdateCursorL()
  :call BlockNavDown2()
  :call SetCursorL()
  ":call AddLocationToJumps()
endfunction

function BlockNavUpLFinal()
  if ScreenCheck('l')
    return
  endif
  :call UpdateCursorL()
  :call BlockNavUp2()
  :call SetCursorL()
  ":call AddLocationToJumps()
endfunction

function BlockNavInLFinal()
  if ScreenCheck('l')
    return
  endif
  :call UpdateCursorL()
  :call BlockNavIn2()
  :call SetCursorL()
  ":call AddLocationToJumps()
endfunction
"------------------------------------------------- local leader
function BlockNavRootLFinal()
  if ScreenCheck('l')
    return
  endif
  :call UpdateCursorL()
  :call BlockNavRoot2()
  :call SetCursorL()
  ":call AddLocationToJumps()
endfunction

function BlockNavBottonLFinal()
  :call UpdateCursorL()
  :call BlockNavBottom2()
  :call SetCursorL()
  ":call AddLocationToJumps()
endfunction

function BlockNavTopLFinal()
  :call UpdateCursorL()
  :call BlockNavTop2()
  :call SetCursorL()
  ":call AddLocationToJumps()
endfunction

function BlockNavLeafLFinal()
  if ScreenCheck('l')
    return
  endif
  :call UpdateCursorL()
  :call BlockNavLeaf2()
  ":call AddLocationToJumps()
endfunction

"=============================================================== camel

