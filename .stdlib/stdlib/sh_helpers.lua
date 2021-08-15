local should_ignore_client = false
local should_ignore_server = false

--- Ignore a certain realm in the require_relative function calls.
-- ```
-- require_ignore('server', true)
-- require_relative('sv_thing.lua') -- will not be included
-- require_ignore('server', false)
-- require_relative('sv_thing.lua') -- will be included
-- ```
-- @param who [String realm]
-- @param should_ignore [Boolean whether the realm should be ignored or not]
function require_ignore(who, should_ignore)
  who = who:lower()

  if who == 'server' or who == 'sv' then
    should_ignore_server = should_ignore
  else
    should_ignore_client = should_ignore
  end
end

--- Require a file relative to the current file's directory.
-- The .lua file ending may be omitted.
-- This function will try to guess the realm the file should be in and
-- AddCSLuaFile accordingly and automatically.
-- ```
-- require_relative 'cl_file'     -- will include cl_file.lua only on client
-- require_relative 'sv_file'     -- will include sv_file.lua only on server
-- require_relative 'file'        -- will include file.lua on both client and server
-- ```
-- @param file_name [String file to include]
-- @return [Object return value of include()]
function require_relative(file_name)
  if !file_name:EndsWith('.lua') then
    file_name = file_name..'.lua'
  end

  if SERVER then
    if !should_ignore_client then
      if string.find(file_name, 'cl_', 1, true) or file_name:EndsWith('/cl_init.lua') then
        return AddCSLuaFile(file_name)
      elseif !string.find(file_name, 'sv_', 1, true) then
        AddCSLuaFile(file_name)
      end
    end
  else
    if string.find(file_name, 'sv_', 1, true) or
       string.find(file_name, 'cratespec', 1, true) or
       file_name:EndsWith('/init.lua') then
      return
    end
  end

  if SERVER and should_ignore_server then return end

  return include(file_name)
end

--- Require all files in a folder using require_relative.
-- Relative to gamemodes/ixhl2rp/ by default, unless `base` is specified.
-- ```
-- require_relative 'my_folder'
-- ```
-- @param dir [String folder to include]
-- @param base=ixhl2rp/ [String base folder for relativity]
-- @param recursive=false [Boolean include all files recursively]
-- @see [require_relative]
function require_relative_folder(dir, base, recursive)
  if base then
    if isbool(base) then
      base = CRATE and CRATE.__path__ or 'ixhl2rp/'
    elseif !base:EndsWith('/') then
      base = base..'/'
    end

    dir = base..dir
  end

  if !dir:EndsWith('/') then
    dir = dir..'/'
  end

  if recursive then
    local files, folders = _file.Find(dir..'*', 'LUA', 'namedesc')

    -- First include the files.
    for k, v in ipairs(files) do
      if File.ext(v) == 'lua' then
        require_relative(dir..v)
      end
    end

    -- Then include all directories.
    for k, v in ipairs(folders) do
      require_relative_folder(dir..v, recursive)
    end
  else
    local files, _ = _file.Find(dir..'*.lua', 'LUA', 'namedesc')

    for k, v in ipairs(files) do
      require_relative(dir..v)
    end
  end
end

--- Require a clientside-only file.
-- The .lua file ending may be omitted.
-- This is equivalent of simply doing this:
-- ```
-- if SERVER then
--   AddCSLuaFile(file_name)
-- else
--   include(file_name)
-- end
-- ```
-- @param file_name [String file name to include]
-- @return [Object return value of include()]
function require_client(file_name)
  if !file_name:EndsWith('.lua') then
    file_name = file_name..'.lua'
  end

  if SERVER then
    return AddCSLuaFile(file_name)
  else
    return include(file_name)
  end
end

--- Require a serverside-only file.
-- The .lua file ending may be omitted.
-- This is equivalent of simply doing this:
-- ```
-- if SERVER then
--   include(file_name)
-- end
-- ```
-- @param file_name [String file name to include]
-- @return [Object return value of include()]
function require_server(file_name)
  if !file_name:EndsWith('.lua') then
    file_name = file_name..'.lua'
  end

  if SERVER then
    return include(file_name)
  end
end

--- Require a file on both client and server.
-- The .lua file ending may be omitted.
-- This is equivalent of simply doing this:
-- ```
-- if SERVER then
--   AddCSLuaFile(file_name)
--   include(file_name)
-- else
--   include(file_name)
-- end
-- ```
-- @param file_name [String file name to include]
-- @return [Object return value of include()]
function require_shared(file_name)
  if !file_name:EndsWith('.lua') then
    file_name = file_name..'.lua'
  end

  if SERVER then
    AddCSLuaFile(file_name)
    return include(file_name)
  else
    return include(file_name)
  end
end
