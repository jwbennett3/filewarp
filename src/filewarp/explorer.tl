--tl-ignore
local record M
  get_panel : function(): string
  get_panel_id : function(): any
  set_left_pid : function(any)
  set_right_pid : function(any)
  update_path : function()
  set_directory : function(string)
  change_dir : function()
  set_curr_panel_to_left : function()
  set_curr_panel_to_right : function()
  toggle_preview : function()
  preview_on : function()
  preview_off : function()
  fquit_nav : function()
  quit_nav : function()
  watch_dir : function()
  new_dir : function()
  new_dir_cd : function()
  new_file : function()
  new_file_type : function()
  write_file_type : function()
  cp_rename : function()
  rename : function()
  counts : function()
  perms : function()
  change_perms : function()
  menu_old : function(string, {string})
  recent_dirs_then_nav_split : function()
  recent_dirs_then_nav : function()
  mv_transfer : function()
  cp_transfer : function()
  split_right : function()
  split_child : function()
  split_parent : function()
  tail_console : function(): string
  toggle_console : function()
  close_console : function()
  open_console : function()
  goto_root : function()
  goto_proj_root : function()
  float_cmd : function(string, any)
  hide_vim_mode : function()
  back_to_normal : function()
  back_to_normal_and_refresh : function()
  process_ipc_cmd : function(string)
  start_ipc : function()
end

local persistence = require('filewarp.persistence')
local lib = require('filewarp.lib')

local panel_vars: any = {
  panel = 'left',
  left_preview = false,
  right_preview = false,
  num_panes = 1,
  left_pid = nil,
  right_pid = nil,
}

function M.get_panel(): string
  return panel_vars.panel
end

function M.get_panel_id(): any
  if panel_vars.panel == 'left' then
    return panel_vars.left_pid
  end
  return panel_vars.right_pid
end

function M.set_left_pid(pid: any)
  panel_vars.left_pid = pid
  vim.env.LEFT_PID = tostring(pid)
end

function M.set_right_pid(pid: any)
  panel_vars.right_pid = pid
  vim.env.RIGHT_PID = tostring(pid)
end

function M.update_path()
  local pid = M.get_panel_id()
  local path = vim.fn.system('echo `getAbsDir ' .. tostring(pid) .. '`')
  path = path:gsub('%s+', '')
  local max_chars = vim.fn.winwidth(0) - 3
  if #path > max_chars then
    path = '...' .. path:sub(#path - max_chars + 1)
  end
  path = path:gsub('/host', '')
  vim.wo.statusline = path
end

function M.set_directory(dir: string)
  panel_vars.panel = panel_vars.panel or 'left'
  local pid = M.get_panel_id()
  vim.fn.system('setAbsDir ' .. tostring(pid) .. ' ' .. dir)
  M.update_path()
  require('filewarp.modes').set_normal_mode()
  vim.fn.feedkeys('\\<F6>', 't')
end

function M.change_dir()
  panel_vars.panel = panel_vars.panel or 'left'
  local dir = lib.clean_file_path(persistence.read('/tmp/output'))
  local pid = M.get_panel_id()
  vim.fn.system('setAbsDir ' .. tostring(pid) .. ' ' .. dir)
  M.update_path()
  require('filewarp.modes').set_normal_mode()
  vim.fn.feedkeys('\\<F6>', 't')
end

function M.set_curr_panel_to_left()
  if panel_vars.panel == 'left' then
    return
  end
  panel_vars.panel = 'left'
  if panel_vars.left_preview then
    vim.api.nvim_buf_set_keymap(0, 't', '<C-u>', '<Nop>', {nowait = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, 't', '<C-A-u>',
      '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_off()<CR>',
      {nowait = true, silent = true})
  else
    vim.api.nvim_buf_set_keymap(0, 't', '<C-A-u>', '<Nop>', {nowait = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, 't', '<C-u>',
      '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_on()<CR>',
      {nowait = true, silent = true})
  end
end

function M.set_curr_panel_to_right()
  if panel_vars.num_panes < 2 then
    return
  end
  if panel_vars.panel == 'right' then
    return
  end
  panel_vars.panel = 'right'
  if panel_vars.right_preview then
    vim.api.nvim_buf_set_keymap(0, 't', '<C-A-e>',
      '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').recent_dirs_then_nav_split()<CR>',
      {nowait = true, silent = true})
  else
    vim.api.nvim_buf_set_keymap(0, 't', '<C-A-u>', '<Nop>', {nowait = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, 't', '<C-u>',
      '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_on()<CR>',
      {nowait = true, silent = true})
  end
  require('filewarp.modes').set_normal_mode()
end

function M.toggle_preview()
  if panel_vars.panel == 'left' then
    panel_vars.left_preview = not panel_vars.left_preview
  else
    panel_vars.right_preview = not panel_vars.right_preview
  end
end

function M.preview_on()
  if panel_vars.panel == 'left' then
    vim.api.nvim_buf_set_keymap(0, 't', '<C-u>', '<Nop>', {nowait = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, 't', '<C-A-u>',
      '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_off()<CR>',
      {nowait = true, silent = true})
    panel_vars.left_preview = true
  else
    if panel_vars.right_preview then
      vim.api.nvim_buf_set_keymap(0, 't', '<C-u>',
        '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_on()<CR>',
        {nowait = true, silent = true})
    else
      vim.api.nvim_buf_set_keymap(0, 't', '<C-u>',
        '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_on()<CR>',
        {nowait = true, silent = true})
    end
    panel_vars.right_preview = true
  end
end

function M.preview_off()
  if panel_vars.panel == 'left' then
    vim.api.nvim_buf_set_keymap(0, 't', '<C-A-u>', '<Nop>', {nowait = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, 't', '<C-u>',
      '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_on()<CR>',
      {nowait = true, silent = true})
    panel_vars.left_preview = false
  end
end

function M.fquit_nav()
  if not vim.env.GVIM then
    vim.fn.system('touch $FILE_WARP_TMP_PATH//$LEFT_PID/killf')
    vim.cmd('q!')
    vim.cmd('q!')
  end
end

function M.quit_nav()
  if not vim.env.GVIM then
    if panel_vars.panel == 'right' then
      local abs_dir = persistence.read('$FILE_WARP_TMP_PATH/' .. tostring(panel_vars.right_pid) .. '/abs_dir')
      vim.fn.system('setAbsDir ' .. tostring(panel_vars.left_pid) .. ' ' .. abs_dir)
    end
    vim.fn.system('touch $FILE_WARP_TMP_PATH/' .. tostring(panel_vars.left_pid) .. '/kill')
    vim.cmd('q!')
    vim.cmd('q!')
  end
end

function M.watch_dir()
  local pid = M.get_panel_id()
  local style = [[+'\%I:\%M:\%S']]
  vim.cmd('te watch -c -d -n 1 ls -GAlFt --color=always --time-style=' .. style ..
    ' `getAbsDir ' .. tostring(pid) .. '`')
end

function M.new_dir()
  require('filewarp.modes').set_insert_mode()
  M.float_cmd('newdir', {w = 0.5, h = 0.5, on_exit = 'back_to_normal_and_refresh'})
end

function M.new_dir_cd()
  require('filewarp.modes').set_insert_mode()
  M.float_cmd('newdircd', {w = 0.5, h = 0.5, on_exit = 'back_to_normal_and_refresh'})
end

function M.new_file()
  require('filewarp.modes').set_insert_mode()
  M.float_cmd('newfile', {w = 0.5, h = 0.5, on_exit = 'back_to_normal_and_refresh'})
end

function M.new_file_type()
  vim.fn.system('echo "" > /tmp/output')
  local menu_items: {string}
  if vim.env.context == 'home' then
    menu_items = {'java', 'bash', 'python'}
  else
    menu_items = {'python', 'bash', 'java'}
  end
  M.menu_old('write_file_type', menu_items)
end

function M.write_file_type()
  require('filewarp.modes').set_insert_mode()
  local selection = persistence.read('/tmp/selection')
  M.float_cmd('newfiletype ' .. selection, {w = 0.5, h = 0.5, on_exit = 'back_to_normal_and_refresh'})
end

function M.cp_rename()
  require('filewarp.modes').set_insert_mode()
  M.float_cmd('cprename', {w = 0.5, h = 0.5, on_exit = 'back_to_normal_and_refresh'})
end

function M.rename()
  require('filewarp.modes').set_insert_mode()
  M.float_cmd('filewarp-rename', {w = 0.5, h = 0.5, on_exit = 'back_to_normal_and_refresh'})
end

function M.counts()
  M.float_cmd('counts', {w = 0.5, h = 0.5, on_exit = 'back_to_normal'})
end

function M.perms()
  vim.g.floaterm_title = vim.fn.system('echo `getName ' .. tostring(M.get_panel_id()) .. '`')
  M.menu_old('change_perms', {'-w', '+w', '+x', '-x', '775', '777'})
end

function M.change_perms()
  vim.g.floaterm_title = ''
  vim.fn.system('perms ' .. tostring(M.get_panel_id()) .. ' ' .. persistence.read('/tmp/selection'))
  require('filewarp.modes').set_normal_mode()
  vim.fn.feedkeys('\\<F6>', 't')
end

function M.menu_old(on_exit: string, items: {string})
  local str = ''
  for i, item in ipairs(items) do
    str = str .. item
    if i < #items then
      str = str .. '\\n'
    end
  end
  M.float_cmd('echo $(echo -e "' .. str .. '" | fzf) | xargs > /tmp/selection',
    {w = 0.5, h = 0.5, on_exit = on_exit})
end

function M.recent_dirs_then_nav_split()
  require('filewarp.modes').set_insert_mode()
  panel_vars.go_back_left = true
  M.float_cmd('. recentDirs "" "" "0"', {on_exit = 'split_right', w = 0.9, h = 0.9})
end

function M.recent_dirs_then_nav()
  require('filewarp.modes').set_insert_mode()
  M.float_cmd('. recentDirs "" "" "0"', {on_exit = 'change_dir', w = 0.9, h = 0.9})
end

function M.mv_transfer()
  vim.fn.system('mvtransfer ' .. panel_vars.panel)
  if panel_vars.panel == 'left' then
    vim.fn.feedkeys('\\<C-p>', 't')
    vim.fn.feedkeys('\\<F6>', 'n')
    vim.fn.feedkeys('\\<C-q>', 't')
  else
    vim.fn.feedkeys('\\<C-q>', 't')
    vim.fn.feedkeys('\\<F6>', 'n')
    vim.fn.feedkeys('\\<C-p>', 't')
  end
  vim.cmd('startinsert')
end

function M.cp_transfer()
  vim.fn.system('cptransfer ' .. panel_vars.panel)
  M.float_cmd('cptransfer ' .. panel_vars.panel, {w = 65, h = 5, on_exit = 'back_to_normal'})
  if panel_vars.panel == 'left' then
    vim.fn.feedkeys('\\<C-p>', 't')
    vim.fn.feedkeys('\\<F6>', 't')
    vim.fn.feedkeys('\\<C-q>', 't')
  else
    vim.fn.feedkeys('\\<C-q>', 't')
    vim.fn.feedkeys('\\<F6>', 'n')
    vim.fn.feedkeys('\\<C-p>', 't')
  end
end

function M.split_right()
  if panel_vars.num_panes == 2 then
    vim.env.on_exit = ''
    M.change_dir()
    return
  end
  panel_vars.num_panes = 2
  vim.api.nvim_buf_set_keymap(0, 't', '<C-A-e>',
    '<C-\\><C-N>:lua require(\'filewarp.explorer\').recent_dirs_then_nav_split()<CR>',
    {nowait = true, silent = true})

  local total_width = vim.fn.winwidth(0)
  vim.cmd('vsplit')
  vim.cmd('vertical resize ' .. math.floor(total_width * 1 / 2))
  vim.cmd('norm 12')

  vim.cmd('enew')
  panel_vars.panel = 'right'
  local right_dir = lib.clean_file_path(persistence.read('/tmp/output'))
  panel_vars.right_dir = right_dir
  vim.env.on_exit = 'BackToNormal'
  panel_vars.left_pid = tonumber(vim.env.MYPID)
  panel_vars.right_pid = 1
  vim.env.MYPID = '1'
  vim.env.RIGHT_PID = '1'
  vim.env.LEFT_PID = tostring(panel_vars.left_pid)

  vim.fn.system('setAbsDir ' .. tostring(panel_vars.right_pid) .. ' ' .. right_dir)
  M.update_path()

  local cmd_str = "on_enter='. changeDirectory' on_up='. navupr' on_open='open' " ..
    "on_exit='open' getList $MYPID | fzfnav2 '$MYPID' '$curr_dir' 'normal'"
  vim.cmd('te ' .. cmd_str)

  panel_vars.left_preview = false
  panel_vars.right_preview = false
  if panel_vars.go_back_left then
    panel_vars.panel = 'left'
    panel_vars.go_back_left = false
    vim.cmd('norm 11')
  end
  vim.env.MYPID = tostring(panel_vars.left_pid)
  require('filewarp.modes').back_to_normal()
end

function M.split_child()
  if panel_vars.num_panes == 2 then
    return
  end
  panel_vars.right_pid = 1
  vim.env.RIGHT_PID = '1'
  vim.fn.system('$(setAbsDir $RIGHT_PID $(getAbsDir $LEFT_PID)/$(getName $LEFT_PID))')
  vim.fn.system('echo $(getAbsDir $RIGHT_PID) > /tmp/output')
  M.split_right()
end

function M.split_parent()
  if panel_vars.num_panes == 2 then
    return
  end
  local parent = vim.fn.system('dirname $(getAbsDir $LEFT_PID)')
  parent = parent:gsub('%s+', '')
  local total_width = vim.fn.winwidth(0)
  vim.cmd('vsplit')
  vim.cmd('vertical resize ' .. math.floor(total_width * 1 / 2))
  vim.cmd('enew')
  panel_vars.left_dir = parent
  panel_vars.left_pid = 1
  panel_vars.right_pid = tonumber(vim.env.MYPID)
  vim.env.LEFT_PID = '1'
  vim.env.MYPID = tostring(panel_vars.right_pid)
  require('filewarp.modes').back_to_normal()
  vim.cmd('startinsert')
end

function M.tail_console(): string
  vim.o.laststatus = 0
  vim.o.showmode = false
  vim.fn.system('touch $FILE_WARP_TMP_PATH/$MYPID/console')
  return 'watch -n .5 cat $FILE_WARP_TMP_PATH//$MYPID/console'
end

function M.toggle_console()
  if vim.g.console_open then
    M.close_console()
  else
    M.open_console()
  end
end

function M.close_console()
  if vim.g.console_open then
    vim.g.console_open = false
    vim.cmd("norm! \\<C-\\>\\<C-N>\\<C-w>j")
    vim.cmd('close!')
    vim.o.laststatus = 0
    vim.cmd('norm! i')
  else
    vim.cmd('norm! i')
  end
end

function M.open_console()
  if not vim.g.console_open then
    local total_height = vim.fn.winheight(0)
    vim.cmd('belowright split')
    vim.cmd('resize ' .. math.floor(total_height * 1 / 8))
    vim.cmd('enew')
    local cmd_str = M.tail_console()
    vim.g.cmd_str = cmd_str
    vim.g.then_cmd = ''
    vim.fn.clearmatches()
    vim.fn.termopen(cmd_str, {on_exit = 'TerminalExit'})
    vim.o.laststatus = 0
    vim.o.showmode = false
    vim.cmd("norm! \\<C-\\>\\<C-N>\\<C-w>ki")
    lib.show_status_message('console')
    vim.g.console_open = true
  else
    vim.cmd('norm! i')
  end
end

function M.goto_root()
  local pid = panel_vars.left_pid
  vim.fn.system('setAbsDir ' .. tostring(pid) .. ' /')
  M.update_path()
  require('filewarp.modes').set_normal_mode()
  vim.fn.feedkeys('\\<F6>', 't')
end

function M.goto_proj_root()
  local pid = panel_vars.left_pid
  vim.fn.system('echo $(getAbsDir $LEFT_PID) > /tmp/output')
  local curr_dir = lib.clean_file_path(persistence.read('/tmp/output'))
  vim.fn.system('getProjRootPath ' .. curr_dir .. ' > /tmp/output')
  local proj_root = lib.clean_file_path(persistence.read('/tmp/output'))
  vim.fn.system('setAbsDir ' .. tostring(pid) .. ' ' .. proj_root)
  M.update_path()
  require('filewarp.modes').set_normal_mode()
  vim.fn.feedkeys('\\<F6>', 't')
end

local on_exit_handlers: any = {
  back_to_normal_and_refresh = function() M.back_to_normal_and_refresh() end,
  back_to_normal = function() M.back_to_normal() end,
  split_right = function() M.split_right() end,
  change_dir = function() M.change_dir() end,
}

function M.float_cmd(cmd_str: string, opts: any)
  opts = opts or {}
  local float_opts: any = {
    w = opts.w or 0.5,
    h = opts.h or 0.5,
  }
  if opts.on_exit and opts.on_exit ~= '' then
    local handler = on_exit_handlers[opts.on_exit]
    if handler then
      float_opts.onDone = handler
    end
  end
  floatCmd(cmd_str, float_opts)
end

function M.hide_vim_mode()
  vim.o.showmode = false
end

function M.back_to_normal()
  require('filewarp.modes').set_normal_mode()
  vim.cmd('startinsert')
end

function M.back_to_normal_and_refresh()
  require('filewarp.modes').set_normal_mode()
  vim.fn.feedkeys('\\<F6>', 't')
  vim.cmd('startinsert')
end

local server_address: string = nil

function M.process_ipc_cmd(cmd: string)
  if cmd:match('^lua ') then
    local lua_cmd = cmd:gsub('^lua ', '')
    local ok, err = pcall(function() vim.cmd('lua ' .. lua_cmd) end)
    local output = ok and '' or tostring(err)
    persistence.write(server_address .. '/output', output)
  else
    local ok, err = pcall(function() vim.cmd(cmd) end)
    local output = ok and '' or tostring(err)
    persistence.write(server_address .. '/output', output)
  end
  vim.fn.system('rm -f ' .. server_address .. '/output_lock')
end

function M.start_ipc()
  local root = vim.env.VIMCOM_ROOT
  if not root or root == '' then
    root = '/tmp/tmp/var/vim-com'
  end
  server_address = root .. '/filewarp'
  vim.fn.mkdir(server_address, 'p')

  if vim.g.ipc_job_id then
    vim.fn.jobstop(vim.g.ipc_job_id)
  end

  vim.g.ipc_job_id = vim.fn.jobstart({'vimSocket', server_address}, {
    on_stdout = function(_, data: any)
      if data[1] then
        M.process_ipc_cmd(data[1])
      end
    end,
    on_stderr = function(_, data: any)
      if data[1] then
        M.process_ipc_cmd(data[1])
      end
    end,
  })
end

return M
