--- navdown2: Lua entry point for terminal-based file navigation.
-- Replaces the bash navdown2 script by setting FZF configuration
-- and launching the fzfnav2 pipeline in a floating terminal.
--
-- Usage: nvim -u init.lua -c "lua require('filewarp.navdown2').run('/path', 'mode')"

local M = {}
local explorer = require('filewarp.explorer')

function M.run(path, mode)
  path = path or vim.fn.getcwd()
  mode = mode or 'normal'

  -- FZF jump-label bindings (one key per navigation command)
  local jump_labels = 'arstneiodhzxcvqwfpluyARSTNEIODHZXCVQWFPLUY'

  -- FZF navigation bindings (key → fzf action)
  local bindings = {
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

  local fzf_opts = {
    '--ansi',
    '--jump-labels=' .. jump_labels,
    '--layout=reverse',
    '--tiebreak=begin,length',
  }
  for _, b in ipairs(bindings) do
    table.insert(fzf_opts, '--bind=' .. b)
  end

  vim.env.FZF_DEFAULT_OPTS = table.concat(fzf_opts, '\n')
  vim.env.FZF_DEFAULT_COMMAND = "rg --follow --glob '' 2> /dev/null"

  -- MYPID
  local id = vim.env.id
  if not id or id == '' then
    vim.env.MYPID = tostring(vim.fn.getpid())
  else
    vim.env.MYPID = id
  end

  -- scratch buffer
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

  -- fzfnav2 pipeline
  local cmd_str = "on_enter='. changeDirectory' on_up='. navupr' on_open='' " ..
    "getList $MYPID | on_exit='$on_exit_nav' . fzfnav2 '$MYPID' '" .. path .. "' '" .. mode .. "'"

  -- quit nvim when the nav terminal closes
  vim.api.nvim_create_autocmd('TermClose', {
    pattern = '*',
    once = true,
    callback = function()
      vim.cmd('q!')
    end,
  })

  explorer.float_cmd(cmd_str, {w = '1.0', h = '1.0'})
end

return M
