--tl-ignore
local record persistence
  write : function(string, string)
  read : function(string): string
  load : function(string): any
  save : function(any, string)
end

function persistence.write(path: string, contents: string)
  vim.fn.system('mkdir -p "$(dirname ' .. path .. ')"')
  vim.fn.writefile({contents}, path)
end

function persistence.read(path: string): string
  if vim.fn.filereadable(path) == 1 then
    local lines = vim.fn.readfile(path)
    return table.concat(lines, '')
  end
  return ''
end

function persistence.load(path: string): any
  local str = persistence.read(path)
  local ok, obj = pcall(vim.json.decode, str)
  if ok and type(obj) == 'table' then
    return obj
  end
  return {}
end

function persistence.save(obj: any, path: string)
  local str = vim.json.encode(obj)
  persistence.write(path, str)
end

return persistence
