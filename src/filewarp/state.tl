local persistence = require('filewarp.persistence')

local STATE_PATH = '/cache/state.json'

local KEYS = {
  selected_editor_index_r = 'selected_editor_index_r',
  selected_editor_type_r = 'selected_editor_type_r',
  buffer_counts = 'buffer_counts',
  opened_editors = 'opened_editors',
}

local record M
  get_state : function(): any
  get_max_opened_editors : function(): number
  get_session_files : function(number): any
  get_first_file : function(number): string
  set_selected_editor_index : function(any)
  remove_from_editor : function(number, string)
  move_to_front : function(number, string)
  selected_editor_type_is_jetbrains : function(): boolean
  get_buffer_count : function(any): number
  set_buffer_count : function(any)
end

function M.get_state(): any
  local state = persistence.load(STATE_PATH)
  if not state[KEYS.opened_editors] then
    state[KEYS.opened_editors] = {}
  end
  return state
end

local function set_state(state: any)
  persistence.save(state, STATE_PATH)
end

function M.get_max_opened_editors(): number
  local name = vim.fn.system('cat /etc/hostname'):gsub('%s+', '')
  if name == 'shenobi' then
    return 4
  end
  if vim.env.context == 'work' then
    return 6
  end
  return 9
end

function M.get_session_files(editor_index: number): any
  local state = M.get_state()
  if not state[KEYS.opened_editors][editor_index] then
    state[KEYS.opened_editors][editor_index] = {}
  end
  return state[KEYS.opened_editors][editor_index]
end

function M.get_first_file(editor_index: number): string
  local files = M.get_session_files(editor_index)
  return #files > 0 and files[#files] or ''
end

function M.set_selected_editor_index(index: any)
  local state = M.get_state()
  state[KEYS.selected_editor_index_r] = tonumber(index)
  set_state(state)
end

function M.remove_from_editor(editor_index: number, path: string)
  local clean = require('filewarp.lib').clean_file_path(path)
  local state = M.get_state()
  local editors = state[KEYS.opened_editors]
  if not editors or not editors[editor_index] then
    return
  end
  local files = editors[editor_index]
  for i, f in ipairs(files) do
    if f == clean then
      table.remove(files, i)
      break
    end
  end
  set_state(state)
end

function M.move_to_front(editor_index: number, path: string)
  local clean = require('filewarp.lib').clean_file_path(path)
  M.remove_from_editor(editor_index, clean)
  local state = M.get_state()
  if not state[KEYS.opened_editors] then
    state[KEYS.opened_editors] = {}
  end
  if not state[KEYS.opened_editors][editor_index] then
    state[KEYS.opened_editors][editor_index] = {}
  end
  table.insert(state[KEYS.opened_editors][editor_index], clean)
  local max = M.get_max_opened_editors()
  while #state[KEYS.opened_editors][editor_index] > max do
    table.remove(state[KEYS.opened_editors][editor_index], 1)
  end
  set_state(state)
end

function M.selected_editor_type_is_jetbrains(): boolean
  local state = M.get_state()
  return state[KEYS.selected_editor_type_r] == 'jetbrains'
end

function M.get_buffer_count(index: any): number
  local state = M.get_state()
  if state[KEYS.buffer_counts] and state[KEYS.buffer_counts][index] then
    return state[KEYS.buffer_counts][index]
  end
  return 0
end

function M.set_buffer_count(count: any)
  local state = M.get_state()
  if not state[KEYS.buffer_counts] then
    state[KEYS.buffer_counts] = {}
  end
  state[KEYS.buffer_counts][vim.env.INDEX] = count
  set_state(state)
end

return M
