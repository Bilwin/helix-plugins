do
  local cache = {}

  function util.text_size(text, font)
    font = font or 'default'

    if cache[text] and cache[text][font] then
      local text_size = cache[text][font]

      return text_size[1], text_size[2]
    else
      surface.SetFont(font)

      local result = { surface.GetTextSize(text) }

      cache[text] = {}
      cache[text][font] = result

      return result[1], result[2]
    end
  end
end

function util.text_width(text, font)
  return select(1, util.text_size(text, font))
end

function util.text_height(text, font)
  return select(2, util.text_size(text, font))
end

function util.font_size(font)
  return select(2, util.text_size('Agw', font))
end

function util.get_panel_class(panel)
  if panel and panel.GetTable then
    local panel_table = panel:GetTable()

    if panel_table and panel_table.ClassName then
      return panel_table.ClassName
    end
  end
end

-- Adjusts x, y to fit inside x2, y2 while keeping original aspect ratio.
function util.fit_to_aspect(x, y, x2, y2)
  local aspect = x / y

  if x > x2 then
    x = x2
    y = x * aspect
  end

  if y > y2 then
    y = y2
    x = y * aspect
  end

  return x, y
end

function util.cubic_ease_in(cur_step, steps, from, to)
  return (to - from) * math.pow(cur_step / steps, 3) + from
end

function util.cubic_ease_out(cur_step, steps, from, to)
  return (to - from) * (math.pow(cur_step / steps - 1, 3) + 1) + from
end

function util.cubic_ease_in_t(steps, from, to)
  local result = {}

  for i = 1, steps do
    table.insert(result, util.cubic_ease_in(i, steps, from, to))
  end

  return result
end

function util.cubic_ease_out_t(steps, from, to)
  local result = {}

  for i = 1, steps do
    table.insert(result, util.cubic_ease_out(i, steps, from, to))
  end

  return result
end

function util.cubic_ease_in_out(cur_step, steps, from, to)
  if cur_step > (steps * 0.5) then
    return util.cubic_ease_out(cur_step - steps * 0.5, steps * 0.5, from, to)
  else
    return util.cubic_ease_in(cur_step, steps, from, to)
  end
end

function util.cubic_ease_in_out_t(steps, from, to)
  local result = {}

  for i = 1, steps do
    table.insert(result, util.cubic_ease_in_out(i, steps, from, to))
  end

  return result
end

do
  local mat_cache = {}

  -- A function to get a material. It caches the material automatically.
  function util.get_material(mat)
    if !mat_cache[mat] then
      mat_cache[mat] = Material(mat)
    end

    return mat_cache[mat]
  end
end

do
  local cache = {}
  local loading_cache = {}

  function util.cache_url_material(url)
    if isstring(url) and url != '' then
      local url_crc = util.CRC(url)
      local pieces = url:split('/')

      if istable(pieces) and #pieces > 0 then
        local extension = string.GetExtensionFromFilename(pieces[#pieces])

        if extension then
          extension = '.'..extension

          local path = 'reunitedgaming/materials/'..url_crc..extension

          if file.Exists(path, 'DATA') then
            cache[url_crc] = Material('../data/'..path, 'noclamp smooth')

            return
          end

          local directories = path:split('/')
          local current_path = ''

          for k, v in pairs(directories) do
            if k < #directories then
              current_path = current_path..v..'/'
              file.CreateDir(current_path)
            end
          end

          http.Fetch(url, function(body, length, headers, code)
            path = path:gsub('.jpeg', '.jpg')
            file.Write(path, body)
            cache[url_crc] = Material('../data/'..path, 'noclamp smooth')

            hook.run('OnURLMatLoaded', url, cache[url_crc])
          end)
        end
      end
    end
  end

  local placeholder = Material('vgui/wave')

  function URLMaterial(url)
    local url_crc = util.CRC(url)

    if cache[url_crc] then
      return cache[url_crc]
    end

    if !loading_cache[url_crc] then
      util.cache_url_material(url)
      loading_cache[url_crc] = true
    end

    return placeholder
  end
end

function util.wrap_text(text, font, width, initial_width)
  if !text or !font or !width then return end

  text = text:gsub('\n', '')

  local output = {}
  local space_width = util.text_size(' ', font)
  local dash_width = util.text_size('-', font)
  local pieces = text:split(' ')
  local cur_width = initial_width or 0
  local current_word = ''

  for k, v in ipairs(pieces) do
    local w, h = util.text_size(v, font)
    local remain = width - cur_width

    -- The width of the word is LESS OR EQUAL than what we have remaining.
    if w <= remain then
      if k != #pieces then
        current_word = current_word..v..' '
        cur_width = cur_width + w + space_width
      else
        current_word = current_word..v
        cur_width = cur_width + w
      end
    else -- The width of the word is MORE than what we have remaining.
      if w > width then -- The width is more than total width we have available.
        for i = 1, utf8.len(v) do
          local char = v:utf8sub(i, i)
          local char_width, _ = util.text_size(char, font)

          remain = width - cur_width

          if (char_width + dash_width + space_width) < remain then
            current_word = current_word..char
            cur_width = cur_width + char_width
          else
            current_word = current_word..char..'-'

            table.insert(output, current_word)

            current_word = ''
            cur_width = 0
          end
        end
      else -- The width is LESS than the total width
        table.insert(output, current_word)

        current_word = v..' '

        local wide = util.text_size(current_word, font)

        cur_width = wide
      end
    end
  end

  -- If we have some characters remaining, drop them into the lines table.
  if current_word != '' then
    table.insert(output, current_word)
  end

  return output
end
