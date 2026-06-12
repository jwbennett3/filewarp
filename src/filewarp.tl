--tl-ignore
local explorer = require('filewarp.explorer')
local modes = require('filewarp.modes')
local lib = require('filewarp.lib')

global record FilewarpOpts
  panel:string
  num_panes:number
  left_preview:number
  right_preview:number
  mypid:number
  left_pid:number
  right_pid:number
  gvim:string
  curr_dir:string
  mode:string
  context:string
  on_exit:string
end

global record AutoCmd
  event:string
  callback:function
end

global record Binding
  mode:string
  lhs:string
  rhs:string
end

local float_term:Feature = require'float-term' as Feature

return {
  start = function(opts:FilewarpOpts)
    opts = opts or {}
    vim.env.panel = opts.panel or 'left'
    vim.env.num_panes = opts.num_panes or 1
    vim.env.left_preview = opts.left_preview or 0
    vim.env.right_preview = opts.right_preview or 0
    vim.env.MYPID = opts.mypid or vim.fn.getpid()
    vim.env.LEFT_PID = opts.left_pid or vim.env.MYPID
    vim.env.RIGHT_PID = opts.right_pid or '1'
    vim.env.GVIM = opts.gvim or vim.env.GVIM or '0'
    vim.env.curr_dir = opts.curr_dir or vim.fn.getcwd()
    vim.env.mode = opts.mode or 'normal'
    vim.env.context = opts.context or vim.env.context or ''
    vim.env.on_exit = opts.on_exit or ''

    explorer.set_left_pid(tonumber(vim.env.LEFT_PID))
    explorer.set_right_pid(tonumber(vim.env.RIGHT_PID))

    local app_opts = {
      priority_features = {
	mode_ctrl = require'mode-ctrl' as Feature,
      },
      features = {
        --'nav',
        --'ccpd',

        float_term = require'float-term' as Feature,
      },
      settings = {
        timeoutlen = 200,
        showmode = false,
      },
      autocmds = {
        {
          event = 'TermEnter',
          callback = function() vim.cmd('startinsert') end,
        },
        {
          event = 'TermOpen',
          callback = function() vim.cmd('startinsert') end,
        },
        {
          event = 'TermLeave',
          callback = function()
            local name = vim.fn.expand('%:t')
            if lib.string_contains(name, 'navdown') or lib.string_contains(name, 'fzfnav2') then
              vim.cmd('q!')
            end
          end,
        },
        {
          event = 'BufEnter',
          callback = function()
            if vim.fn.expand('%:t') ~= '' and not lib.exists(vim.fn.expand('%:p')) then
              vim.cmd('bd!')
            end
          end,
        },
      },
      raw_bindings = {
        {'t', '<Esc>', '<C-\\><C-n>'},
        {'t', "'", '<C-\\><C-n>:'},
        {'t', '!', '<C-\\><C-n>:!'},
        {'c', '<Insert>e', '$'},
        {'c', '<A-e>', '<C-n>'},
        {'c', '<A-i>', '<C-p>'},
        {'c', '<C-e>', '<C-n>'},
        {'c', '<C-s>', '<C-p>'},
      },
    }

    local ok, app = pcall(require, 'app')
    if ok then
      app.start(app_opts)
    end

    explorer.hide_vim_mode()
    explorer.update_path()
    explorer.start_ipc()

    if vim.env.mode == 'insert' then
      modes.set_insert_mode()
    else
      modes.set_normal_mode()
    end

    vim.g.skip_post = 1
  end,

  start_from_terminal = function(curr_dir:string, mode:string)
    mode = mode or 'normal'
    vim.cmd('enew')
    explorer.hide_vim_mode()
    vim.o.laststatus = 0
    vim.env.panel = 'left'
    vim.env.LEFT_PID = vim.env.MYPID
    vim.env.curr_dir = curr_dir
    vim.env.mode = mode

    vim.fn.system('setAbsDir ' .. tostring(vim.env.MYPID) .. ' ' .. curr_dir)

    local cmd_str = "on_enter='. changeDirectory' on_up='. navupr' on_open='' " ..
      "getList " .. tostring(vim.env.MYPID) .. " | on_exit='$on_exit_nav' . fzfnav2 '" ..
      tostring(vim.env.MYPID) .. "' '" .. curr_dir .. "' '" .. mode .. "'"
    vim.env.on_exit = 'Quit'
    vim.wo.statusline = curr_dir

    local termspec = "call termopen('" .. cmd_str .. "',{'on_exit':'Quit'})"
    explorer.float_cmd(
      'nvim -u $NVIMHOME/nav.vim -c "' .. termspec .. '"',
      {w = '1.0', h = '1.0'}
    )
  end,
}
