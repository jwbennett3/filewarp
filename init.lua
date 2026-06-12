vim.cmd"set noswapfile"
vim.opt.runtimepath:prepend(os.getenv("FILEWARP_HOME"))
local plugin_home = os.getenv("FILEWARP_HOME") .. "plugins"
vim.opt.runtimepath:prepend(plugin_home .. '/lualib0')
vim.opt.runtimepath:prepend(plugin_home .. '/lualib1')
vim.opt.runtimepath:prepend(plugin_home .. '/nvimlib')
vim.opt.runtimepath:prepend(plugin_home .. '/features')
