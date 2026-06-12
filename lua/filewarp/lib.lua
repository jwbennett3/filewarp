local lib = {}

-- string utilities
function lib.string_contains(str, val)
  return strfind(str, val, 1, true) ~= nil
end

function lib.string_starts_with(str, val)
  return strsub(str, 1, #val) == val
end

function lib.sanitize_search_string(str)
  local t = { ['.'] = '\\.', ['$'] = '\\$', ['/'] = '\\/', ['//'] = '\\/\\/' }
  return t[str] or str
end

function lib.prompt_input(prompt, text)
  prompt = prompt or ''
  text = text or ''
  vim.fn.inputsave()
  local ret = vim.fn.input(prompt, text)
  vim.fn.inputrestore()
  return ret
end

function lib.prompt_char()
  return vim.fn.nr2char(vim.fn.getchar())
end

function lib.get_char_with_timeout(time)
  time = time or 30
  local count = 0
  local n = vim.fn.getchar(0)
  while n == 0 and count < time do
    n = vim.fn.getchar(0)
    count = count + 1
    vim.fn.reltimefloat(vim.fn.reltime())  -- small delay equivalent
    vim.cmd('sleep 10m')
  end
  return n
end

-- file system queries
function lib.exists(path)
  return vim.fn.glob(path) ~= ''
end

function lib.is_file(path)
  return vim.fn.filereadable(path) == 1
end

function lib.is_dir(path)
  return vim.fn.isdirectory(path) == 1
end

function lib.file_has_no_name()
  return vim.fn.expand('%:t') == ''
end

function lib.is_readonly_file()
  return vim.bo.readonly
    or vim.fn.expand('%:t') == ''
    or vim.bo.buftype == 'nofile'
    or vim.bo.filetype == 'help'
    or lib.string_contains(vim.fn.expand('%:t'), 'undotree')
end

function lib.get_curr_dir()
  return vim.fn.expand('%:p:h')
end

function lib.get_file_path()
  return lib.clean_file_path(vim.fn.expand('%:p'))
end

function lib.get_file_name()
  return vim.fn.fnamemodify(vim.fn.expand('%:t'), ':r')
end

function lib.clean_file_path(path)
  local p = path
  p = p:gsub('\n', '')
  p = p:gsub('//', '/')
  p = p:gsub('/optimus', '')
  p = p:gsub('/data/cloud/config', '/config')
  p = p:gsub('/home/joe/config', '/config')
  p = p:gsub('/home/neon/config', '/config')
  p = p:gsub('/data/gitfiles', '/gitfiles')
  p = p:gsub('/data/code', '/code')
  p = p:gsub('/mnt/drive1', '')
  p = p:gsub('/home/joe/links/symboldragon', '/symboldragon')
  p = p:gsub('/home/joe/links/gitfiles', '/gitfiles')
  return p
end

-- cursor / screen
function lib.get_curr_x()
  return vim.fn.getpos('.')[3]
end

function lib.get_curr_y()
  return vim.fn.getpos('.')[2]
end

function lib.cursor_is_at_beginning_of_line()
  return lib.get_curr_x() == 1
end

function lib.cursor_is_at_end_of_line()
  local pos = vim.fn.getpos('.')
  return pos[3] == vim.fn.col({pos[2], '$'}) - 1
end

function lib.set_caret_pos(line, col)
  vim.fn.setpos('.', {0, line, col, 0})
end

function lib.get_char_under_cursor()
  local pos = vim.fn.getpos('.')
  return vim.fn.getline('.')[pos[3]]
end

function lib.get_char_at(x, y)
  return vim.fn.getline(y)[x]
end

function lib.get_word_under_cursor()
  return vim.fn.expand('<cword>')
end

function lib.screen_height()
  return lib.last_screen_y() - lib.first_screen_y()
end

function lib.first_screen_y()
  vim.cmd('norm! H')
  local y = lib.get_curr_y()
  lib.set_caret_pos(lib.get_curr_x(), lib.get_curr_y())
  local ret = y - vim.o.scrolloff
  return ret <= 0 and 1 or ret
end

function lib.last_screen_y()
  vim.cmd('norm! L')
  local y = lib.get_curr_y()
  lib.set_caret_pos(lib.get_curr_x(), lib.get_curr_y())
  local ret = y + vim.o.scrolloff
  local last = vim.fn.line('$')
  return ret > last and last or ret
end

-- selection
function lib.get_selected_text()
  vim.cmd("norm! `<v`>\"jy")
  return vim.fn.getreg('j')
end

-- highlighting
local color_highlights = {}

function lib.add_line_highlight_group(y, name, id)
  pcall(vim.fn.matchaddpos, name, {{y, 1, 120}}, 10, id)
end

function lib.clear_highlight_group(id)
  pcall(vim.fn.matchdelete, id)
end

function lib.uncolor_buffer()
  for _, hl in ipairs(color_highlights) do
    if hl > 0 then
      pcall(vim.fn.matchdelete, hl)
    end
  end
end

function lib.highlight_line(line_number, hi_group)
  return vim.fn.matchaddpos(hi_group, {{line_number}})
end

-- containers
function lib.for_each(container, action)
  for i, v in ipairs(container) do
    action(v, i)
  end
end

function lib.filter(container, action)
  local ret = {}
  for i, v in ipairs(container) do
    if action(v, i) then
      table.insert(ret, v)
    end
  end
  return ret
end

function lib.contains(container, value)
  if type(value) == 'function' then
    for i, v in ipairs(container) do
      if value(v, i) then
        return true
      end
    end
    return false
  end
  for _, v in ipairs(container) do
    if v == value then
      return true
    end
  end
  return false
end

function lib.last_value(container)
  return container[#container]
end

function lib.pop(container)
  local ret = lib.last_value(container)
  table.remove(container, #container)
  return ret
end

-- terminal / shell
function lib.run(cmd)
  vim.fn.system(cmd)
end

function lib.run_terminal_cmd(build_cmd, then_cmd, ...)
  local percent = 0
  local float_mode = false
  if select('#', ...) > 0 then
    local arg1 = select(1, ...)
    if arg1 == 'f' then
      float_mode = true
    else
      percent = arg1
    end
  end

  local cmd_str = build_cmd()
  vim.g.cmd_str = cmd_str
  vim.g.then_cmd = then_cmd
  vim.cmd('enew')
  vim.fn.clearmatches()
  vim.fn.system('echo "' .. cmd_str .. '" >> /tmp/vimcmd')
  vim.fn.termopen(cmd_str, {on_exit = 'TerminalExit'})
end

lib.num_open_buffers = function()
  local count = 0
  for i = 1, vim.fn.bufnr('$') do
    if vim.fn.buflisted(i) == 1 then
      count = count + 1
    end
  end
  return count
end

function lib.get_num_lines_in_buffer()
  return vim.fn.line('$')
end

function lib.host_name()
  return vim.fn.system('echo -n $HOSTNAME')
end

function lib.get_machine_name()
  vim.fn.system('cat /etc/hostname > /tmp/hostname')
  return lib.read_file('/tmp/hostname')
end

-- scrolling
function lib.set_scroll_limit()
  if vim.b.scroll_limit then
    vim.wo.scrolloff = vim.b.scroll_limit
  elseif lib.is_readonly_file() then
    vim.wo.scrolloff = 999
  else
    vim.wo.scrolloff = 25
  end
end

function lib.unset_scroll_limit()
  if lib.is_readonly_file() then
    vim.b.scroll_limit = 999
  else
    vim.b.scroll_limit = 25
  end
  vim.wo.scrolloff = 0
end

-- status message
function lib.show_status_message(message)
  vim.api.nvim_set_hl(0, 'StatusLine', {ctermbg = 'blue', ctermfg = 'white'})
  local t = vim.inspect(message)
  t = t:gsub(' ', '\\\\ ')
  vim.o.laststatus = 2
  vim.wo.statusline = '%{' .. t .. '}'
end

return lib
