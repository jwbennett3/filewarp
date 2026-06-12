local persistence = {}

function persistence.write(path, contents)
  vim.fn.system('mkdir -p "$(dirname ' .. path .. ')"')
  vim.fn.writefile({contents}, path)
end

function persistence.read(path)
  if vim.fn.filereadable(path) == 1 then
    local lines = vim.fn.readfile(path)
    return table.concat(lines, '')
  end
  return ''
end

function persistence.load(path)
  local str = persistence.read(path)
  local ok, obj = pcall(vim.json.decode, str)
  if ok and type(obj) == 'table' then
    return obj
  end
  return {}
end

function persistence.save(obj, path)
  local str = vim.json.encode(obj)
  persistence.write(path, str)
end

return persistence
