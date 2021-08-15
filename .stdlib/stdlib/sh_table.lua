function table.Merge(dest, source)
  for k, v in pairs(source) do
    if istable(v) and istable(dest[k]) and k != 'class' then
      table.Merge(dest[k], v)
    else
      dest[k] = v
    end
  end

  return dest
end

table.merge = table.Merge

function table.safe_merge(to, from)
  local old_idx_to, old_idx = to.__index, from.__index
  local references = {}

  to.__index = nil
  from.__index = nil

  for k, v in pairs(from) do
    if v == from or k == 'class' then
      references[k] = v
      from[k] = nil
    end
  end

  table.Merge(to, from)

  for k, v in pairs(references) do
    from[k] = v
  end

  to.__index = old_idx_to
  from.__index = old_idx

  return to
end

function table.map(t, c)
  local new_table = a{}

  for k, v in pairs(t) do
    local val = c(v)
    if val != nil then
      table.insert(new_table, val)
    end
  end

  return new_table
end

function table.map_kv(t, c)
  local new_table = {}

  for k, v in pairs(t) do
    local val = c(k, v)
    if val != nil then
      table.insert(new_table, val)
    end
  end

  return new_table
end

function table.select(t, what)
  local new_table = a{}

  if isfunction(what) then
    for k, v in pairs(t) do
      if what(v, k) != false then
        table.insert(new_table, v)
      end
    end
  else
    for k, v in pairs(t) do
      if istable(v) then
        table.insert(new_table, v[what])
      end
    end
  end

  return new_table
end

function table.slice(t, from, to)
  local new_table = a{}

  for i = from, to do
    table.insert(new_table, t[i])
  end

  return new_table
end

function table.remove_functions(obj)
  if istable(obj) then
    for k, v in pairs(obj) do
      if isfunction(v) then
        obj[k] = nil
      elseif istable(v) then
        obj[k] = table.remove_functions(v)
      end
    end
  end

  return obj
end

do
  local ops = {
    ['+']  = function(a, b) return a + b end,
    ['-']  = function(a, b) return a - b end,
    ['*']  = function(a, b) return a * b end,
    ['/']  = function(a, b) return a / b end,
    ['**'] = function(a, b) return a ^ b end,
    ['^']  = function(a, b) return a ^ b end,
    ['%']  = function(a, b) return a % b end
  }

  function table.reduce(tab, op)
    local sum = 0

    if !isfunction(op) then
      op = ops[op]
    end

    for k, v in ipairs(tab) do
      sum = op(sum, v)
    end

    return sum
  end
end

function table.sum(tab)
  return table.reduce(tab, '+')
end

function table.flatten(tab)
  local t = a{}

  for k, v in pairs(tab) do
    if istable(v) and !v.class then
      table.insert(t, table.flatten(tab))
    else
      table.insert(t, v)
    end
  end

  return v
end

function table.uniq(tab, condition)
  local t = a{}
  local vals = {}

  condition = condition or function(v) return vals[v] end

  for k, v in pairs(tab) do
    if !condition(v) then
      t[k] = v
      vals[v] = true
    end
  end

  return t
end

do
  local function run_comp(key, value, t2)
    if !istable(value) then
      if value != t2[key] then
        return false
      end
    else
      if !table.equal(value, t2[key]) then
        return false
      end
    end

    return true
  end

  function table.equal(tab1, tab2)
    if !istable(tab1) or !istable(tab2) then return false end
    if tab1 == tab2 then return true end

    local t1, t2 = 0, 0

    for k, v in pairs(tab1) do
      t1 = t1 + 1

      if !run_comp(k, v, tab2) then
        return false
      end
    end

    for k, v in pairs(tab2) do
      t2 = t2 + 1

      if !run_comp(k, v, tab1) then
        return false
      end
    end

    if t1 != t2 then return false end

    return true
  end
end

function table.hash(tab)
  return tostring(tab):gsub('table: 0x', '')
end

function table.join(tab, sep)
  local str = ''
  sep = sep or ''

  for k, v in pairs(tab) do
    if !istable(v) then
      str = str..tostring(v)
    else
      str = str..table.join(v, sep)
    end
  end

  return str
end

function table.delete_if(tab, callback)
  local new_tab = a{}

  for k, v in pairs(tab) do
    if callback(k, v) != true then
      new_tab[k] = v
    end
  end

  return new_tab
end

function table.delete(tab, callback)
  for k, v in pairs(tab) do
    if callback(k, v) == true then
      tab[k] = nil
    end
  end

  return tab
end

function table.keep_if(tab, callback)
  local new_tab = a{}

  for k, v in pairs(tab) do
    if callback(k, v) == true then
      new_tab[k] = v
    end
  end

  return new_tab
end

function table.keep(tab, callback)
  for k, v in pairs(tab) do
    if callback(k, v) != true then
      tab[k] = nil
    end
  end

  return tab
end

function table.first(tab)
  return tab[1]
end

function table.last(tab)
  return tab[#tab]
end

function table.one(tab, callback)
  local hit = false

  for k, v in pairs(tab) do
    if callback(k, v) then
      if !hit then
        hit = true
      else
        return false
      end
    end
  end

  return hit
end

function table.none(tab, callback)
  for k, v in pairs(tab) do
    if callback(k, v) then
      return false
    end
  end

  return true
end

function table.partition(tab, callback)
  local t1, t2 = a{}, a{}

  for k, v in pairs(tab) do
    if callback(k, v) then
      table.insert(t1, v)
    else
      table.insert(t2, v)
    end
  end

  return t1, t2
end

function table.to_array(tab)
  local a = a{}

  for k, v in pairs(tab) do
    table.insert(a, { k, v })
  end

  return a
end

function table.to_hash(tab)
  local h = a{}

  for k, v in ipairs(tab) do
    if istable(v) then
      h[v[1]] = v[2]
    else
      table.insert(v)
    end
  end

  return h
end

--
-- Function: table.serialize (table toSerialize)
-- Description: Converts a table into the string format.
-- Argument: table toSerialize - Table to convert.
--
-- Returns: string - pON-encoded table. If pON fails then JSON is returned.
--
function table.serialize(tab)
  if istable(tab) then
    local success, value = pcall(pon.encode, tab)

    if !success then
      success, value = pcall(util.TableToJSON, tab)

      if !success then
        ErrorNoHalt('Failed to serialize a table!\n')
        error_with_traceback(value)

        return ''
      end
    end

    return value
  else
    print('You must serialize a table, not '..type(tab)..'!')
    return ''
  end
end

--
-- Function: table.deserialize (string toDeserialize)
-- Description: Converts a string back into table. Uses pON at first, if it fails it falls back to JSON.
-- Argument: string toDeserialize - String to convert.
--
-- Returns: table - Decoded string.
--
function table.deserialize(data)
  if isstring(data) then
    local success, value = pcall(pon.decode, data)

    if !success then
      success, value = pcall(util.JSONToTable, data)

      if !success then
        ErrorNoHalt('Failed to deserialize a string!\n')
        error_with_traceback(value)

        return {}
      end
    end

    return value
  else
    print('You must deserialize a string, not '..type(data)..'!')
    return {}
  end
end

do
  local table_meta = {
    __index = table
  }

  -- Special arrays.
  function a(initializer)
    return setmetatable(initializer, table_meta)
  end

  function is_a(obj)
    return getmetatable(obj) == table_meta
  end
end

-- For use with table#map
-- table.map(t, s'some_field')
function s(what)
  return function(tab)
    return tab[what]
  end
end

function w(str)
  return str:gsub('\n', ' '):gsub('  ', ' '):split(' ')
end

function wk(str)
  local ret = {}

  for k, v in ipairs(str:split(' ')) do
    ret[v] = true
  end

  return ret
end

function table.range(from, to)
  local t = {}

  for i = from, to do
    table.insert(t, i)
  end

  return t
end

-- A better implementation of PrintTable
function print_table(t, indent, done, indent_length)
  done = done or {}
  indent = indent or 0
  indent_length = indent_length or 1

  local keys = table.GetKeys(t)

  for k, v in pairs(keys) do
    local l = tostring(v):len()

    if l > indent_length then
      indent_length = l
    end
  end

  indent_length = indent_length + 1

  table.sort(keys, function(a, b)
    if isnumber(a) and isnumber(b) then return a < b end
    return tostring(a) < tostring(b)
  end)

  done[t] = true

  for i = 1, #keys do
    local key = keys[i]
    local value = t[key]
    Msg(string.rep('  ', indent))

    if istable(value) and !done[value] then
      local str_key = tostring(key)

      if value.class or value.class_name then
        Msg(
          str_key..':'..
          string.rep(' ', indent_length - str_key:len())..
          ' #<'..tostring(value.class_name or key)..': '..
          tostring(value):gsub('table: ', '')..'>\n'
        )
      elseif IsColor(value) then
        Msg(str_key..':'..
        string.rep(' ', indent_length - str_key:len())..
        ' #<Color: '..value.r..' '..value.g..' '..value.b..' '..value.a..'>\n'
      )
      elseif table.IsEmpty(value) then
        Msg(str_key..':'..string.rep(' ', indent_length - str_key:len())..' []\n')
      else
        done[value] = true
        Msg(str_key..':\n')
        print_table(value, indent + 1, done, indent_length - 3)
        done[value] = nil
      end
    else
      local str_key = tostring(key)
      Msg(str_key..string.rep(' ', indent_length - str_key:len())..'= ' )

      if isstring(value) then
        Msg('"'..value..'"\n')
      elseif isfunction(value) then
        Msg('function ('..tostring(value):gsub('function: ', '')..')\n')
      elseif istable(value) and (value.class or value.class_name) then
        Msg('#<'..tostring(value.class_name or key)..': '..tostring(value):gsub('table: ', '')..'>\n')
      else
        Msg(tostring(value)..'\n')
      end
    end
  end
end

PrintTable = print_table
