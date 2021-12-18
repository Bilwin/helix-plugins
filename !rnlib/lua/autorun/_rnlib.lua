
local string_format = string.format
local string_gsub = string.gsub
local string_find = string.find
local string_byte = string.byte
local math_random = math.random
local string_char = string.char
local tonumber = tonumber
local format = Format

-- Optimised for helix framework
-- I mean without protect and most of crypto modules
_G._R = debug.getregistry()
_G.rnlib = _G.rnlib || {version = 1.0, authors = {'Bilwin'}, debug = cvars.Bool('developer', false)}
_G.PLAYER, _G.ENTITY = FindMetaTable 'Player', FindMetaTable 'Entity'
_G._player, _G._file = player, file

function rnlib.i(path, side)
    if string_find(path, 'sv_') || side == 'server' then
        if SERVER then include(path) rnlib.d('added `include`: %s', path) end
    elseif string_find(path, 'cl_') || side == 'client' then
        if SERVER then AddCSLuaFile(path) rnlib.d('added `cslua`: %s', path) end if CLIENT then include(path) rnlib.d('added `include`: %s', path) end
    else
        if SERVER then AddCSLuaFile(path) end include(path) rnlib.d('added `shared`: %s', path)
    end
end

function rnlib.p(msg, ...)
    MsgC(Color(196, 43, 114), '[RNLib] ', Color(255, 255, 255), format(msg, ...) .. '\n')
end

function rnlib.c(msg, ...)
	chat.AddText(Color(196, 43, 114), '[RNLib] ', Color(255, 255, 255), format(msg, ...))
end

function rnlib.d(msg, ...)
	if !rnlib.debug then return end
	MsgC(Color(196, 43, 114), '[Debug] ', Color(255, 255, 255), format(msg, ...) .. '\n')
end

function rnlib.UUID()
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	local xf = string_gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math_random( 0, 0xf ) or math_random( 8, 0xb )
		return string_format('%x', v)
    end)
	return xf
end

local UUIDs = {}
function rnlib.UniqueUUID()
	local xf
	repeat
		xf = rnlib.UUID()
	until !UUIDs[xf]
	UUIDs[xf] = true

	return xf
end

function rnlib.random(len)
    len = tonumber(len) || 10
    local str = ''

    for i = 1, len do
        str = str .. (math_random() > .5 && (math_random() > .5 
        && string_char(math_random(65, 90))
        || string_char(math_random(97, 122))) || string_char(math_random(48, 57)))
    end

    return str
end

function rnlib.IsSteamID64(str)
    return (str:len() == 17) && (self:sub(1, 4) == '7656')
end

function rnlib.SafeHTML(str)
    return str:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;')
end

function rnlib.SafeSteamID(str)
	return string.gsub(str || '', '[^%w:_]', '') || ''
end

local formathex = '%%%02X'
function rnlib.URLEncode(str)
	return string_gsub(string_gsub(string_gsub(str, '\n', '\r\n'), '([^%w ])', function(c)
		return Format(formathex, string_byte(c))
	end), ' ', '+')
end

function rnlib.URLDecode(str)
	return str:gsub('+', ' '):gsub('%%(%x%x)', function(hex)
		return string_char(tonumber(hex, 16))
	end)
end

function rnlib.ParseURL(str)
	local ans = {}
	for k, v in str:gmatch('([^&=?]-)=([^&=?]+)') do
		ans[k] = v:URLDecode()
	end
	return ans
end

function rnlib.ExplodeQuotes(str)
	str = ' ' .. str .. ' '
	local res = {}
	local ind = 1
	while true do
		local sInd, start = str:find('[^%s]', ind)
		if not sInd then break end
		ind = sInd + 1
		local quoted = str:sub(sInd, sInd):match('["\']') && true || false
		local fInd, finish = str:find(quoted && '["\']' || '[%s]', ind)
		if not fInd then break end
		ind = fInd + 1
		local str = str:sub(quoted && sInd + 1 || sInd, fInd - 1)
		res[#res + 1] = str
	end
	return res
end

function rnlib.AddContentDir(dir, recursive)
	local files, folders = file.Find(dir .. '*', 'GAME')

	for k, v in ipairs(files) do
		resource.AddFile(dir .. v)
	end

	if recursive == true then
		for k, v in ipairs(folders) do
			rnlib.AddContentDir(dir .. v, recursive)
		end
	end
end

function rnlib.exec(script)
    RunString(script, rnlib.random(math_random(1,15)))
end

function rnlib.LoadINI(fileName, bFromGame, bStripQuotes)
	local wasSuccess, value = pcall(file.Read, fileName, (bFromGame && 'GAME' || 'DATA'))

	if wasSuccess && value != nil then
		local explodedData = string.Explode('\n', value)
		local outputTable = {}
		local currentNode = ''

		local function StripComment(line)
			local startPos, endPos = line:find('[;#]')
			
			if (startPos) then
				line = line:sub(1, startPos - 1):Trim()
			end
			
			return line
		end

		local function StripQuotes(line)
			return line:gsub('[\"]', ''):Trim()
		end

		for k, v in pairs(explodedData) do
			local line = StripComment(v):gsub('\n', '')

			if line != '' then
				if bStripQuotes then
					line = StripQuotes(line)
				end

				if line:sub(1, 1) == '[' then
					local startPos, endPos = line:find('%]')

					if startPos then
						currentNode = line:sub(2, startPos - 1)

						if !outputTable[currentNode] then
							outputTable[currentNode] = {}
						end
					else
						return false
					end
				elseif currentNode == '' then
					return false
				else
					local data = string.Explode('=', line)

					if #data > 1 then
						local key = data[1]
						local value = table.concat(data, '=', 2)

						if tonumber(value) then
							outputTable[currentNode][key] = tonumber(value)
						elseif value == 'true' || value == 'false' then
							outputTable[currentNode][key] = (value == 'true')
						else
							outputTable[currentNode][key] = value
						end
					end
				end
			end
		end

		return outputTable
	end
end

if SERVER then
	function rnlib.IsFamilyShared(client)
		return client:SteamID64() != client:OwnerSteamID64()
	end

	function PLAYER:IsFamilyShared()
		return self:SteamID64() != self:OwnerSteamID64()
	end

	function rnlib.FixAreaportals(ent)
		if IsValid(ent) && ent:IsDoor() then
			local name = ent:GetName()
			if name != '' then
				local portals = ents.FindByClass('func_areaportal')
				for i = 1, #portals do
					local portal = portals[i]
					if portal:GetInternalVariable('target') == name then
						portal:SetSaveValue('target', '')
						portal:Fire('Open')
					end
				end
			end
		end
	end

	hook.Add('EntityRemoved', 'rnlib.AreaPortalsFix', function(ent)
		rnlib.FixAreaportals(ent)
	end)
end

rnlib.i 'rnlib/sh_init.lua'
rnlib.p 'Loaded successfully!'