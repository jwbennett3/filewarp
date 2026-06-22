--tl-ignore
local record M
  set_insert_mode : function()
  set_easy_motion : function()
  set_normal_mode : function()
  back_to_normal : function()
end

local function tmap(lhs: string, rhs: string, opts: any)
  opts = opts or {}
  opts.nowait = opts.nowait ~= false
  opts.silent = opts.silent ~= false
  vim.api.nvim_buf_set_keymap(0, 't', lhs, rhs, opts)
end

local function tnoremap(lhs: string, rhs: string)
  tmap(lhs, rhs, {noremap = true})
end

local function nnoremap(lhs: string, rhs: string)
  vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {noremap = true, silent = true, nowait = true})
end

function M.set_insert_mode()
  local pass: {string} = {
    '<C-u>', '<C-l>', '<C-n>', '<C-e>', '<C-o>',
    'O',
    '<LocalLeader>i', '<LocalLeader>n', '<LocalLeader>e',
    'q','w','f','p','g','j','l','u','y','a','r','s','t','d','h','n','e','i','o','z','x','c','v','b','k','m',
    'Q','W','F','P','G','J','L','U','Y','A','R','S','T','D','H','N','E','I','O','Z','X','C','V','B','K','M',
    '<Space>', '8',
    'ä','å','ã','ø','ð','þ','‘','’','ł','æ','đ','ç','œ','ħ',
  }
  for _, k in ipairs(pass) do
    tnoremap(k, k)
  end
end

function M.set_easy_motion()
  local letters: {string} = {
    'q','w','f','p','g','j','l','u','y','a','r','s','t','d','h','n','e','i','o','z','x','c','v','b','k','m',
    'Q','W','F','P','G','J','L','U','Y','A','R','S','T','D','H','N','E','I','O','Z','X','C','V','B','K','M',
  }
  for _, k in ipairs(letters) do
    tmap(k, '<C-\\><C-N>:set noinsertmode<CR>' ..
      ':lua require(\'filewarp.modes\').set_normal_mode()<CR>' ..
      ':startinsert<CR>' .. k, {noremap = false})
  end
end

function M.set_normal_mode()
  tnoremap('<C-q>',
    '<C-\\><C-N>:set noinsertmode<CR><C-w>h' ..
    ':lua require(\'filewarp.explorer\').set_curr_panel_to_left()<CR>:startinsert<CR>')
  tnoremap('<C-p>',
    '<C-\\><C-N>:set noinsertmode<CR><C-w>l' ..
    ':lua require(\'filewarp.explorer\').set_curr_panel_to_right()<CR>:startinsert<CR>')

  nnoremap('11', '<C-w>h')
  nnoremap('12', '<C-w>l')
  nnoremap('13', '<F6>')
  nnoremap('14', '<A-u>')

  tnoremap('<A-S-c>', '<A-c>')
  tnoremap('<C-A-d>', '<A-a>')
  tnoremap('ç', '<A-r>')
  tnoremap('<C-A-n>',
    '<C-\\><C-N>:lua require(\'filewarp.explorer\').split_parent()<CR>')

  if vim.g.num_panes ~= 2 then
    tnoremap('<C-A-e>',
      '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').recent_dirs_then_nav_split()<CR>')
  end

  tnoremap('<C-A-o>',
    '<C-\\><C-N>:lua require(\'filewarp.explorer\').split_child()<CR>')
  tnoremap('<Space>',
    '<C-\\><C-N>:set noinsertmode<CR>:startinsert<CR><f11>')
  tnoremap('<C-Space>',
    '<C-\\><C-N>:set noinsertmode<CR>:startinsert<CR><f10>')

  tnoremap('<C-u>',
    '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').toggle_preview()<CR>')
  tnoremap('<C-A-u>',
    '<A-u><C-\\><C-N>:lua require(\'filewarp.explorer\').preview_off()<CR>')
  tnoremap('<C-l>', '<A-l>')
  tnoremap('<C-d>', '<A-d>')

  if vim.env.GVIM then
    tnoremap('<ESC>', 'di<Return>')
    tnoremap('<LocalLeader>q', 'di<Return>')
    tnoremap('<Leader>q', 'di<Return>')
  else
    tnoremap('<Leader>q',
      '<C-\\><C-N>:set noinsertmode<CR>' ..
      ':lua require(\'filewarp.explorer\').fquit_nav()<CR>')
    tnoremap('<LocalLeader>q',
      '<C-\\><C-N>:set noinsertmode<CR>' ..
      ':lua require(\'filewarp.explorer\').quit_nav()<CR>')
  end

  tnoremap('<LocalLeader>i',
    '<C-\\><C-N>:set noinsertmode<CR>:startinsert<CR><C-A-i>')
  tnoremap('<f5>', '<f5>')
  tnoremap('q', '<Nop>')
  tnoremap('w', '<C-\\><C-N>:lua require(\'filewarp.explorer\').watch_dir()<CR>')
  tnoremap('<C-w>', '<A-w>')
  tnoremap('p',
    '<F6><C-\\><C-N>:lua require(\'filewarp.explorer\').cp_rename()<CR>')
  tnoremap('P',
    '<F6><C-\\><C-N>:lua require(\'filewarp.explorer\').rename()<CR>')
  tnoremap('g',
    '<C-\\><C-N>:lua require(\'filewarp.explorer\').toggle_console()<CR>')
  tnoremap('j', '<Nop>')
  tnoremap('l', '<C-\\><C-N>:lua require(\'filewarp.explorer\').cp_transfer()<CR>')
  tnoremap('dn', '<C-\\><C-N>:lua require(\'filewarp.explorer\').goto_root()<CR>')
  tnoremap('N', '<C-\\><C-N>:lua require(\'filewarp.explorer\').goto_proj_root()<CR>')
  tnoremap('u', '<Nop>')
  tnoremap('y', '<Nop>')
  tnoremap('a',
    '<C-\\><C-N>:set noinsertmode<CR><C-w>l<C-n><CR>:startinsert<CR>')
  tnoremap('r', '<C-R>')
  tnoremap('Þ', '<C-A-R>')
  tnoremap('s', '<C-s>')
  tnoremap('“', '<C-A-s>')
  tnoremap('t', '<Nop>')
  tnoremap('d', '<Nop>')
  tnoremap('h', '<Nop>')
  tnoremap('n',
    '<C-n><C-\\><C-N>:sil lua vim.defer(function() ' ..
    'require(\'filewarp.explorer\').update_path() end)<CR>')
  tnoremap('e', '<C-e>')
  tnoremap('i', '<C-i>')
  tnoremap('o',
    '<C-o><C-\\><C-N>:sil lua vim.defer(function() ' ..
    'require(\'filewarp.explorer\').update_path() end)<CR>')
  tnoremap('<C-o>',
    '<C-\\><C-N>:set noinsertmode<CR>' ..
    ':lua require(\'filewarp.modes\').set_easy_motion()<CR>:startinsert<CR><C-h>')
  tnoremap('E',
    '<C-\\><C-N>:set noinsertmode<CR>' ..
    ':lua require(\'filewarp.modes\').set_easy_motion()<CR>:startinsert<CR><C-h>')
  tnoremap('I',
    '<C-\\><C-N>:set noinsertmode<CR>' ..
    ':lua require(\'filewarp.modes\').set_easy_motion()<CR>:startinsert<CR><C-h>')
  tnoremap('z', '<Nop>')
  tnoremap('x', '<Nop>')
  tnoremap('c', '<C-\\><C-N>:lua require(\'filewarp.explorer\').mv_transfer()<CR>')
  tnoremap('v', '<Nop>')
  tnoremap('<C-b>', '<A-b>')
  tnoremap('b', '<C-b>')
  tnoremap('B', '<C-A-b>')
  tnoremap('<C-k>', '<C-d>')
  tnoremap('<C-A-k>',
    '<C-\\><C-N>:lua require(\'filewarp.explorer\').new_dir()<CR>')
  tnoremap('<A-S-o>',
    '<C-\\><C-N>:lua require(\'filewarp.explorer\').new_dir_cd()<CR>')
  tnoremap('K', '<C-\\><C-N>:lua require(\'filewarp.explorer\').new_file()<CR>')
  tnoremap('k',
    '<C-\\><C-N>:lua require(\'filewarp.explorer\').new_file_type()<CR>')
  tnoremap('m',
    '<F7><C-\\><C-N>:set noinsertmode<CR>' ..
    ':lua require(\'filewarp.explorer\').perms()<CR>')
  tnoremap(';',
    '<F7><C-\\><C-N>:lua require(\'filewarp.explorer\').counts()<CR>')

  tnoremap('<A-S-E>', '<A-e>')
  tnoremap('<A-S-I>', '<A-i>')
  tnoremap('<LocalLeader>e', '<C-A-e>')
  tnoremap('<LocalLeader>i', '<C-A-i>')

  local alt_maps: {string:string} = {
    ['<A-q>'] = 'q', ['<A-w>'] = 'w', ['<A-f>'] = 'f', ['<A-p>'] = 'p',
    ['ö'] = 'g',
    ['<A-j>'] = 'j', ['<A-l>'] = 'l', ['<A-u>'] = 'u', ['<A-y>'] = 'y',
    ['<A-a>'] = 'a', ['<A-r>'] = 'r', ['<A-s>'] = 's', ['<A-t>'] = 't',
    ['<A-d>'] = 'd', ['<A-h>'] = 'h', ['<A-n>'] = 'n', ['<A-e>'] = 'e',
    ['<A-i>'] = 'i', ['<A-o>'] = 'o', ['<A-z>'] = 'z', ['<A-x>'] = 'x',
    ['<A-c>'] = 'c', ['<A-v>'] = 'v', ['<A-b>'] = 'b', ['<A-k>'] = 'k',
    ['<A-m>'] = 'm', ['<A-.>'] = '.',
  }
  for lhs, rhs in pairs(alt_maps) do
    tnoremap(lhs, rhs)
  end

  local dead_key_maps: {string:string} = {
    ['ä'] = 'q', ['å'] = 'w', ['ã'] = 'f', ['ø'] = 'p',
    ['ð'] = 'a', ['þ'] = 'r', ['‘'] = 's', ['’'] = 't',
    ['ł'] = 'd', ['æ'] = 'z', ['đ'] = 'x',
    ['œ'] = 'v', ['ħ'] = 'b',
  }
  for lhs, rhs in pairs(dead_key_maps) do
    tnoremap(lhs, rhs)
  end
end

function M.back_to_normal()
  M.set_normal_mode()
  vim.cmd('startinsert')
end

return M
