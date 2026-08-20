local record M
  run:function(string, string)
end

local explorer = require('filewarp.explorer')

function M.run(path:string, mode:string)
  path = path or vim.fn.getcwd()
  mode = mode or 'normal'

  local jump_labels = 'arstneiodhzxcvqwfpluyARSTNEIODHZXCVQWFPLUY'

  local bindings:{string} = {
    'ctrl-e:down',
    'ctrl-i:up',
    'ctrl-a:backward-char',
    'ctrl-t:forward-char',
    'ctrl-r:preview-down',
    'ctrl-s:preview-up',
    'ctrl-q:preview-bottom',
    'ctrl-y:preview-top',
    'å:preview-half-page-down',
    'é:preview-half-page-up',
    'ä:backward-word',
    'ã:forward-word',
    'ctrl-x:backward-delete-char',
    'đ:backward-kill-word',
    'alt-/:kill-word',
    'æ:clear-query',
    'ctrl-alt-e:half-page-down',
    'ctrl-alt-i:half-page-up',
    'alt-e:last',
    'insert:print-query',
    'btab:replace-query',
    'ctrl-a:toggle-all',
    'ctrl-o:jump-accept',
  }

  local fzf_opts:{string} = {
    '--ansi',
    '--jump-labels=' .. jump_labels,
    '--layout=reverse',
    '--tiebreak=begin,length',
  }
  for _, b in ipairs(bindings) do
    table.insert(fzf_opts, '--bind=' .. b)
  end

  vim.env.FZF_DEFAULT_OPTS = table.concat(fzf_opts, '\n')
  vim.env.FZF_DEFAULT_COMMAND = "rg --follow --glob '' 2> "$HOME"/null

  local id = vim.env.id
  if not id or id == '' then
    vim.env.MYPID = tostring(vim.fn.getpid())
  else
    vim.env.MYPID = id
  end

  vim.cmd('enew')
  explorer.hide_vim_mode()
  vim.o.laststatus = 0
  vim.env.panel = 'left'
  vim.env.LEFT_PID = vim.env.MYPID
  vim.env.curr_dir = path
  vim.env.mode = mode
  vim.env.on_exit = 'Quit'
  vim.wo.statusline = path

  vim.fn.system('setAbsDir ' .. vim.env.MYPID .. ' ' .. path)

  local cmd_str = "on_enter='. changeDirectory' on_up='. navupr' on_open='' " ..
    "getList $MYPID | on_exit='$on_exit_nav' . fzfnav2 '$MYPID' '" .. path .. "' '" .. mode .. "'"

  vim.api.nvim_create_autocmd('TermClose', {
    pattern = '*',
    once = true,
    callback = function() vim.cmd('q!') end,
  })

  explorer.float_cmd(cmd_str, {w = 1.0, h = 1.0})
end

return M
