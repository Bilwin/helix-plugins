-- A function to select a random player.
function player.random()
  local all_ply = player.all()

  if #all_ply > 0 then
    return all_ply[math.random(1, #all_ply)]
  end
end

-- A function to find player based on their name or steam_id.
function player.find(name, case_sensitive, return_first)
  if name == nil then return end
  if !isstring(name) then return (IsValid(name) and name) or nil end

  local hits = {}
  local is_steamid = name:starts('STEAM_')

  for k, v in ipairs(_player.all()) do
    if is_steamid then
      if v:SteamID() == name then
        return v
      end

      continue
    end

    if v:name(true):find(name) then
      table.insert(hits, v)
    elseif !case_sensitive and v:name(true):utf8lower():find(name:utf8lower()) then
      table.insert(hits, v)
    elseif v:steam_name():utf8lower():find(name:utf8lower()) then
      table.insert(hits, v)
    end

    if return_first and #hits > 0 then
      return hits[1]
    end
  end

  if #hits > 1 then
    return hits
  else
    return hits[1]
  end
end

function player.name_from_steamid(steamid)
  local steam64 = util.SteamIDTo64(steamid)
  local steam_name

  steamworks.request_player_info(steam64, function(_steam_name)
    steam_name = _steam_name
  end)

  return steam_name
end
