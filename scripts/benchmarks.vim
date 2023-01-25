


function! HowLong()
  let startTime = localtime()
  for i in range( 5000000 )
    :echo 6
  endfor
  let result = localtime() - startTime
  :echo result
  return result
endfunction


lua << END
function test()
startTime=os.time(os.date("!*t"))
for i = 1,5000000,1
do
  vim.cmd('echo "6"')
end
result = os.time(os.date("!*t")) - startTime
print(result)
end
END

lua << END
function test2()
  vim.cmd('echo "arrsitClearLocalJumps"')
end
END

"python << END
"import vim
"import time
"def abc():
    "start = time.time()
    "for i in range(1,500000):
        "vim.command('echo "6"')
    "result = time.time() - start
    "print(result)
"END


