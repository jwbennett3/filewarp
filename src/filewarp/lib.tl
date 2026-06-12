--tl-ignore
local record lib
  string_contains : function(string, string): boolean
  string_starts_with : function(string, string): boolean
  sanitize_search_string : function(string): string
  prompt_input : function(string, string): string
  prompt_char : function(): number
  get_char_with_timeout : function(number): number
  exists : function(string): boolean
  is_file : function(string): boolean
  is_dir : function(string): boolean
  file_has_no_name : function(): boolean
  is_readonly_file : function(): boolean
  get_curr_dir : function(): string
  get_file_path : function(): string
  get_file_name : function(): string
  clean_file_path : function(string): string
  get_curr_x : function(): number
  get_curr_y : function(): number
  cursor_is_at_beginning_of_line : function(): boolean
  cursor_is_at_end_of_line : function(): boolean
  set_caret_pos : function(number, number)
  get_char_under_cursor : function(): string
  get_char_at : function(number, number): string
  get_word_under_cursor : function(): string
  screen_height : function(): number
  first_screen_y : function(): number
  last_screen_y : function(): number
  get_selected_text : function(): string
  add_line_highlight_group : function(number, string, number)
  clear_highlight_group : function(number)
  uncolor_buffer : function()
  highlight_line : function(number, string): number
  for_each : function(any, function)
  filter : function(any, function): any
  contains : function(any, any): boolean
  last_value : function(any): any
  pop : function(any): any
  run : function(string)
  run_terminal_cmd : function(function, string, ...:any)
  read_file : function(string): string
  num_open_buffers : function(): number
  get_num_lines_in_buffer : function(): number
  host_name : function(): string
  get_machine_name : function(): string
  set_scroll_limit : function()
  unset_scroll_limit : function()
  show_status_message : function(string)
end

function lib.string_contains(str: string, val: string): boolean
  return strfind(str, val, 1, true) ~= nil
end

function lib.string_starts_with(str: string, val: string): boolean
  return strsub(str, 1, #val) == val
end

function lib.sanitize_search_string(str: string): string
  local t = { ['.'] = '\\.', ['$'] = '\\$', ['/'] = '\\/', ['//'] = '\\/\\/' }
  return t[str] or str
end

function lib.prompt_input(prompt: string, text: string): string
  prompt = prompt or ''
  text = text or ''
  vim.fn.inputsave()
  local ret = vim.fn.input(prompt, text)
  vim.fn.inputrestore()
  return ret
end

function lib.prompt_char(): number
  return vim.fn.nr2char(vim.fn.getchar())
end

function lib.get_char_with_timeout(time: number): number
  time = time or 30
  local count = 0
  local n = vim.fn.getchar(0)
  while n == 0 and count < time do
    n = vim.fn.getchar(0)
    count = count + 1
    vim.fn.reltimefloat(vim.fn.reltime())
    vim.cmd('sleep 10m')
  end
  return n
end

function lib.exists(path: string): boolean
  return vim.fn.glob(path) ~= ''
end

function lib.is_file(path: string): boolean
  return vim.fn.filereadable(path) == 1
end

function lib.is_dir(path: string): boolean
  return vim.fn.isdirectory(path) == 1
end

function lib.file_has_no_name(): boolean
  return vim.fn.expand('%:t') == ''
end

function lib.is_readonly_file(): boolean
  return vim.bo.readonly
    or vim.fn.expand('%:t') == ''
    or vim.bo.buftype == 'nofile'
    or vim.bo.filetype == 'help'
    or lib.string_contains(vim.fn.expand('%:t'), 'undotree')
end

function lib.get_curr_dir(): string
  return vim.fn.expand('%:p:h')
end

function lib.get_file_path(): string
  return lib.clean_file_path(vim.fn.expand('%:p'))
end

function lib.get_file_name(): string
  return vim.fn.fnamemodify(vim.fn.expand('%:t'), ':r')
end

function lib.clean_file_path(path: string): string
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

function lib.get_curr_x(): number
  return vim.fn.getpos('.')[3]
end

function lib.get_curr_y(): number
  return vim.fn.getpos('.')[2]
end

function lib.cursor_is_at_beginning_of_line(): boolean
  return lib.get_curr_x() == 1
end

function lib.cursor_is_at_end_of_line(): boolean
  local pos = vim.fn.getpos('.')
  return pos[3] == vim.fn.col({pos[2], '$'}) - 1
end

function lib.set_caret_pos(line: number, col: number)
  vim.fn.setpos('.', {0, line, col, 0})
end

function lib.get_char_under_cursor(): string
  local pos = vim.fn.getpos('.')
  return vim.fn.getline('.')[pos[3]]
end

function lib.get_char_at(x: number, y: number): string
  return vim.fn.getline(y)[x]
end

function lib.get_word_under_cursor(): string
  return vim.fn.expand('<cword>')
end

function lib.screen_height(): number
  return lib.last_screen_y() - lib.first_screen_y()
end

function lib.first_screen_y(): number
  vim.cmd('norm! H')
  local y = lib.get_curr_y()
  lib.set_caret_pos(lib.get_curr_x(), lib.get_curr_y())
  local ret = y - vim.o.scrolloff
  return ret <= 0 and 1 or ret
end

function lib.last_screen_y(): number
  vim.cmd('norm! L')
  local y = lib.get_curr_y()
  lib.set_caret_pos(lib.get_curr_x(), lib.get_curr_y())
  local ret = y + vim.o.scrolloff
  local last = vim.fn.line('$')
  return ret > last and last or ret
end

function lib.get_selected_text(): string
  vim.cmd("norm! `<v`>\"jy")
  return vim.fn.getreg('j')
end

local color_highlights: {number} = {}

function lib.add_line_highlight_group(y: number, name: string, id: number)
  pcall(vim.fn.matchaddpos, name, {{y, 1, 120}}, 10, id)
end

function lib.clear_highlight_group(id: number)
  pcall(vim.fn.matchdelete, id)
end

function lib.uncolor_buffer()
  for _, hl in ipairs(color_highlights) do
    if hl > 0 then
      pcall(vim.fn.matchdelete, hl)
    end
  end
end

function lib.highlight_line(line_number: number, hi_group: string): number
  return vim.fn.matchaddpos(hi_group, {{line_number}})
end

function lib.for_each(container: any, action: function)
  for i, v in ipairs(container) do
    action(v, i)
  end
end

function lib.filter(container: any, action: function): any
  local ret = {}
  for i, v in ipairs(container) do
    if action(v, i) then
      table.insert(ret, v)
    end
  end
  return ret
end

function lib.contains(container: any, value: any): boolean
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

function lib.last_value(container: any): any
  return container[#container]
end

function lib.pop(container: any): any
  local ret = lib.last_value(container)
  table.remove(container, #container)
  return ret
end

function lib.run(cmd: string)
  vim.fn.system(cmd)
end

function lib.run_terminal_cmd(build_cmd: function, then_cmd: string, ...: any)
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

function lib.num_open_buffers(): number
  local count = 0
  for i = 1, vim.fn.bufnr('$') do
    if vim.fn.buflisted(i) == 1 then
      count = count + 1
    end
  end
  return count
end

function lib.get_num_lines_in_buffer(): number
  return vim.fn.line('$')
end

function lib.host_name(): string
  return vim.fn.system('echo -n $HOSTNAME')
end

function lib.get_machine_name(): string
  vim.fn.system('cat /etc/hostname > /tmp/hostname')
  return lib.read_file('/tmp/hostname')
end

function lib.read_file(file: string): string
  if vim.fn.filereadable(file) == 1 then
    local lines = vim.fn.readfile(file)
    return table.concat(lines, '\n')
  end
  return ''
end

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

function lib.show_status_message(message: string)
  vim.api.nvim_set_hl(0, 'StatusLine', {ctermbg = 'blue', ctermfg = 'white'})
  local t = vim.inspect(message)
  t = t:gsub(' ', '\\\\ ')
  vim.o.laststatus = 2
  vim.wo.statusline = '%{' .. t .. '}'
end

return lib
