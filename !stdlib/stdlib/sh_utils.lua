function game.get_ammo_list()
  local last_ammo_name = game.GetAmmoName(1)
  local ammo_table = { last_ammo_name }

  while last_ammo_name != nil do
    last_ammo_name = game.GetAmmoName(table.insert(ammo_table, last_ammo_name))
  end

  return ammo_table
end

-- A function to check whether all of the arguments in vararg are valid (via IsValid).
function util.validate(...)
  local validate = { ... }

  if #validate <= 0 then return false end

  for k, v in ipairs(validate) do
    if !IsValid(v) then
      return false
    end
  end

  return true
end

-- A function to print C-style formatted strings.
function printf(str, ...)
  print(Format(str, ...))
end

function util.to_b(value)
  return (tonumber(value) == 1 or value == true or value == 'true')
end

function util.wait_for_ent(ent_index, callback, delay, wait_time)
  local entity = Entity(ent_index)

  if !IsValid(entity) then
    local timer_name = CurTime()..'_ent_wait'

    timer.Create(timer_name, delay or 0, wait_time or 100, function()
      local entity = Entity(ent_index)

      if IsValid(entity) then
        callback(entity)

        timer.Remove(timer_name)
      end
    end)
  else
    callback(entity)
  end
end

function util.list_to_string(callback, separator, ...)
  if !isfunction(callback) then
    callback = function(obj) return tostring(obj) end
  end

  if !isstring(separator) then
    separator = ', '
  end

  local list = { ... }
  local result = ''

  for k, v in ipairs(list) do
    local text = callback(v)

    if isstring(text) then
      result = result..text
    end

    if k < #list then
      result = result..separator
    end
  end

  return result
end

function util.player_list_to_string(player_list)
  local nlist = #player_list

  if nlist > 1 and nlist == #_player.all() then
    return 'ui.chat.everyone'
  end

  return util.list_to_string(function(obj)
    return (IsValid(obj) and obj:name()) or 'Unknown Player'
  end, nil, unpack(player_list))
end

function util.remove_newlines(str)
  local pieces = str:split()
  local to_ret = ''
  local skip = ''

  for k, v in ipairs(pieces) do
    if skip != '' then
      to_ret = to_ret..v

      if v == skip then
        skip = ''
      end

      continue
    end

    if v == '"' then
      skip = '"'

      to_ret = to_ret..v

      continue
    end

    if v == '\n' or v == '\t' then
      continue
    end

    to_ret = to_ret..v
  end

  return to_ret
end

function txt(text)
  local lines = (text or ''):chomp('\n'):split('\n')
  local lowest_indent
  local output = ''

  for k, v in ipairs(lines) do
    if v:match('^[%s]+$') then continue end
    local indent = v:match('^([%s]+)')
    if !indent then continue end
    if !lowest_indent then lowest_indent = indent end
    if indent:len() < lowest_indent:len() then
      lowest_indent = indent
    end
  end

  for k, v in ipairs(lines) do
    output = output..v:trim_start(lowest_indent)..'\n'
  end

  return output:chomp(' '):chomp('\n')
end

function get_player_name(player)
  return IsValid(player) and player:SteamName() or t'notification.console'
end

function util.vector_obstructed(vec1, vec2, filter)
  local trace = util.TraceLine({
    start = vec1,
    endpos = vec2,
    filter = filter
  })

  return trace.Hit
end

function util.door_is_locked(entity)
  if entity:IsDoor() then
    local data = entity:GetSaveTable()

    if (data) then
      return data.m_bLocked
    end
  end

  return false
end

local operators = {
  equal = function(a, b)
    return a == b
  end,
  unequal = function(a, b)
    return a != b
  end,
  less = function(a, b)
    return a < b
  end,
  greater = function(a, b)
    return a > b
  end,
  less_equal = function(a, b)
    return a <= b
  end,
  greater_equal = function(a, b)
    return a >= b
  end,
  ['and'] = function(a, b)
    return a and b
  end,
  ['or'] = function(a, b)
    return a or b
  end,
  ['not'] = function(a, b)
    return !a
  end
}

local operators_symbol = {
  less = '<',
  greater = '>',
  less_equal = '<=',
  greater_equal = '>=',
  equal = '==',
  unequal = '!=',
  ['and'] = '&&',
  ['or'] = '||',
  ['not'] = '!'
}

function util.process_operator(op, a, b)
  return operators[op](a, b)
end

function util.get_operators()
  local list = {}

  for k, v in pairs(operators) do
    table.insert(list, k)
  end

  return list
end

function util.get_logical_operators()
  local list = {
    equal = '==',
    unequal = '!=',
    ['and'] = '&&',
    ['or'] = '||',
    ['not'] = '!'
  }

  return list
end

function util.get_relational_operators()
  local list = {
    less = '<',
    greater = '>',
    less_equal = '<=',
    greater_equal = '>=',
    equal = '==',
    unequal = '!='
  }

  return list
end

function util.get_equal_operators()
  local list = {
    equal = '==',
    unequal = '!='
  }

  return list
end

function util.operator_to_symbol(op)
  return operators_symbol[op]
end

--- Similar to <=> operator in other languages.
-- @returns [Number, -1 if a < b, 0 if a == b, and 1 if a > b]
function compare(a, b)
  if a > b then  return 1 end
  if a == b then return 0 end
  return -1
end

--- Print traceback to current function call.
-- @return [Array string pieces of the traceback]
function print_traceback(suppress, ...)
  local trace_text = debug.traceback(...)

  trace_text = trace_text
                 :gsub('stack traceback:\n', '\n')
                 :gsub(': in main chunk', '')
                 :gsub(': in function', ': in')
                 :gsub('\n%s+', '\n')
                 :gsub('^\n', '')

  local pieces = trace_text:split('\n')
  pieces[1] = '' -- remove the actual call to debug.traceback

  if !suppress then
    for k, v in ipairs(pieces) do
      if v and v != '' then
        Msg('    ')
        MsgC(Color(0, 255, 255), 'from '..v)
        Msg('\n')
      end
    end
  end

  return pieces
end

--- Prints an error using ErrorNoHalt but without character limit.
-- @see[ErrorNoHalt]
function long_error(...)
  local text = table.concat({...})
  local len = string.len(text)
  local pieces = {}

  if len > 200 then
    for i = 1, len / 200 do
      table.insert(pieces, text:sub((i - 1) * 200 + 1, math.min(i * 200, len)))
    end
  else
    pieces = { text }
  end

  for k, v in ipairs(pieces) do
    ErrorNoHalt(v)
  end

  if text:ends('\n') then
    print ''
  end
end

--- Print an error message followed by a complete stack traceback.
function error_with_traceback(msg)
  long_error(msg..'\n')
  print_traceback()
end
