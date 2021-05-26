local String = {
  lower = function(...)
    return (string.utf8lower or string.lower)(...)
  end,
  upper = function(...)
    return (string.utf8upper or string.upper)(...)
  end,
  sub = function(...)
    return (string.utf8sub or string.sub)(...)
  end
}

local string_meta = getmetatable('')

do
  local vowels = {
    ['a'] = true,
    ['e'] = true,
    ['o'] = true,
    ['i'] = true,
    ['u'] = true
  }

  -- A function to check whether character is vowel or not.
  function string.vowel(char)
    print('string.vowel is deprecated')
    return ''
  end
end

-- A function to remove a substring from the end of the string.
function string.trim_end(str, needle, all_occurences)
  if !needle or needle == '' then
    return str
  end

  if str:ends(needle) then
    if all_occurences then
      while str:ends(needle) do
        str = str:trim_end(needle)
      end

      return str
    end

    return String.sub(str, 1, utf8.len(str) - utf8.len(needle))
  else
    return str
  end
end

-- A function to remove a substring from the beginning of the string.
function string.trim_start(str, needle, all_occurences)
  if !needle or needle == '' then
    return str
  end

  if str:starts(needle) then
    if all_occurences then
      while str:starts(needle) do
        str = str:trim_start(needle)
      end

      return str
    end

    return String.sub(str, utf8.len(needle) + 1, utf8.len(str))
  else
    return str
  end
end

-- A function to check whether the string is full uppercase or not.
function string.is_upper(str)
  return String.upper(str) == str
end

-- A function to check whether the string is full lowercase or not.
function string.is_lower(str)
  return String.lower(str) == str
end

-- A function to find all occurences of a substring in a string.
function string.find_all(str, pattern)
  if !str or !pattern then return end

  local hits = {}
  local last_pos = 1

  while true do
    local find_data = { string.find(str, pattern, last_pos) }
    local start_pos, end_pos = find_data[1], find_data[2]

    if !start_pos then
      break
    end

    table.insert(hits, {
      text      = String.sub(str, start_pos, end_pos),
      start_pos = start_pos,
      end_pos   = end_pos,
      matches   = table.map(find_data, function(v) if isstring(v) then return v end end)
    })

    last_pos = end_pos + 1
  end

  return hits
end

function string.include(str, substring, start_pos)
  return string.find(str, substring, start_pos, true)
end

-- A function to check if string is command or not.
function string.is_command(str)
  print('string.is_command is deprecated')
  return ''
end

do
  -- ID's should not have any of those characters.
  local blocked_chars = {
    "'", '"', '\\', '/', '^',
    ':', '.', ';', '&', ',', '%'
  }

  function string.to_id(str)
    str = String.lower(str)
    str = str:gsub(' ', '_')

    for k, v in ipairs(blocked_chars) do
      str = str:replace(v, '')
    end

    return str
  end
end

function string.ensure_end(str, ending)
  if str:ends(ending) then return str end
  return str..ending
end

function string.ensure_start(str, start)
  if str:starts(start) then return str end
  return start..str
end

function string.set_indent(str, indent)
  return indent..str:gsub('\n', '\n'..indent):gsub('\n%s+\n', '\n\n')
end

function string_meta:__add(right)
  return self..tostring(right)
end

function string.is_n(char)
  return tonumber(char) != nil
end

function string.count(str, char)
  local hits = 0

  for i = 1, str:len() do
    if str[i] == char then
      hits = hits + 1
    end
  end

  return hits
end

function string.spelling(str, first_lower, no_period)
  local len = utf8.len(str)
  local end_text = String.sub(str, -1)
  local first_char = String.sub(str, 1, 1)

  if !str:is_upper() then
    str = (!first_lower and String.upper(String.sub(str, 1, 1)) or
          String.lower(String.sub(str, 1, 1)))..String.sub(str, 2, len)
  end

  if !no_period then
    if end_text != '.' and end_text != '!' and end_text != '?' and end_text != '"' then
      str = str..'.'
    end
  end

  return str
end

function string.presence(str)
  return isstring(str) and (str != '' and str) or nil
end

function string.underscore(str)
  return str:gsub('::', '/')
            :gsub('([A-Z]+)([A-Z][a-z])', '%1_%2')
            :gsub('([a-z%d])([A-Z])', '%1_%2')
            :gsub('[%-%s]', '_')
            :lower()
end

function string.camel_case(str)
  return str:capitalize():gsub('_([a-z])', string.upper)
end

function string.chomp(str, what)
  if !what then
    str = str:trim_end('\n', true):trim_end('\r', true)
  else
    str = str:trim_start(what, true):trim_end(what, true)
  end

  return str
end

function string.capitalize(str)
  local len = utf8.len(str)
  return String.upper(str[1])..(len > 1 and String.sub(str, 2, utf8.len(str)) or '')
end

function string.parse_table(str, ref)
  local tables = str:split('::')

  ref = istable(ref) and ref or _G

  for k, v in ipairs(tables) do
    ref = ref[v]

    if !istable(ref) then return false, v end
  end

  return ref
end

function string.parse_parent(str, ref)
  local tables = str:split('::')
  local last_ref = str

  ref = istable(ref) and ref or _G

  for k, v in ipairs(tables) do
    local new_ref = ref[v]

    if !istable(new_ref) then return ref, v end

    last_ref = v

    ref = new_ref
  end

  if istable(ref) then
    return ref, last_ref or str
  else
    return false
  end
end

local function real_gsub(pat)
  return pat:gsub("(%%?)(.)", function(percent, letter)
    if percent != "" or !letter:match("%a") then
      return percent..letter
    else
      return string.format("[%s%s]", letter:lower(), letter:upper())
    end
  end)
end

-- https://stackoverflow.com/questions/11401890/case-insensitive-lua-pattern-matching
function i(pattern)

  if pattern:include('[') then
    local p = pattern:gsub('([.]*)%[([%w]*)%]([.]*)', function(before, letters, after)
      return real_gsub(before)..'['..letters:lower()..letters:upper()..']'..real_gsub(after)
    end)
    return p
  else
    local p = real_gsub(pattern)
    return p
  end
end

function string.fmt(format, data)
  data = istable(data) and data or {}

  return string.gsub(format, '{([%w_]+)}', function(hit)
    return data[hit] or ''
  end)
end

function string.escape(str)
  return str:gsub('\a', '\\a')
            :gsub('\b', '\\b')
            :gsub('\f', '\\f')
            :gsub('\n', '\\n')
            :gsub('\r', '\\r')
            :gsub('\t', '\\t')
            :gsub('\v', '\\v')
end
