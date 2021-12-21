file.CreateDir('rnlib_assets')

local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local white = Color( 255, 255, 255 )
local crc = util.CRC
local _error = Material("error")
local assets = {}
local fetchedavatars = {}
local snd_type = {["mp3"] = true, ["ogg"] = true, ["wav"] = true}

local math              = math
local table             = table
local draw              = draw
local team              = team
local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local draw_RoundedBoxEx = draw.RoundedBoxEx
local draw_RoundedBox = draw.RoundedBox
local surface_SetFont = surface.SetFont
local surface_DrawRect = surface.DrawRect
local surface_DrawLine = surface.DrawLine
local surface_GetTextSize = surface.GetTextSize
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawPoly = surface.DrawPoly
local surface_DrawCircle = surface.DrawCircle
if not sound.oPlayURL then sound.oPlayURL = sound.PlayURL end
local sound_PlayFile = sound.PlayFile

local function fetch_image(crc, url)
	if exists("rnlib_assets/" .. crc .. ".png", "DATA") then
		assets[url] = Material("data/rnlib_assets/" .. crc .. ".png")

		return assets[url]
	end

	assets[url] = _error

	fetch(url, function(data)
		write("rnlib_assets/" .. crc .. ".png", data)
		assets[url] = Material("data/rnlib_assets/" .. crc .. ".png")
	end)

	return assets[url]
end

local function fetch_sound(crc, url)
	if exists("rnlib_assets/" .. crc .. ".txt", "DATA") then
		assets[url] = "data/rnlib_assets/" .. crc .. ".txt"

		return assets[url]
	end

	return nil
end

local function write_sound(crc, url)
	fetch(url, function(data)
		write("rnlib_assets/" .. crc .. ".txt", data)
		assets[url] = "data/rnlib_assets/" .. crc .. ".txt"
	end)
end

function fetch_asset(url)
	if (not url) then return _error end

	if (assets[url]) then
		return assets[url]
	end

	if (not http) then
		return _error
	end

	local crc = crc(url)

	if (snd_type[url:GetExtensionFromFilename()]) then
		return fetch_sound(crc, url)
	else
		return fetch_image(crc, url)
	end
end

local default_avatar = "https://i.imgur.com/P3d3CO2.png"
function fetchAvatarAsset(id64, size, cb)
	id64 = id64 or "BOT"
	size = size == "medium" and "medium" or size == "small" and "" or size == "large" and "full" or ""

	if (fetchedavatars[id64 .. size]) then
		if (cb) then cb(fetchedavatars[id64 .. size]) end
		return
	end

	fetchedavatars[id64 .. size] = default_avatar
	if (not id64 or id64 == "BOT") then 
		if (cb) then cb(fetchedavatars[id64 .. size]) end
		return 
	end

	fetch("https://steamcommunity.com/profiles/" .. id64 .. "/?xml=1",function(body)
		local link = body:match("https://steamcdn%-a%.akamaihd%.net/steamcommunity/public/images/avatars/.-jpg")
		if (not link) then return end

		fetchedavatars[id64 .. size] = link:Replace(".jpg", (size ~= "" and "_" .. size or "") .. ".jpg")
		if (cb) then cb(fetchedavatars[id64 .. size]) end
	end)
end

function draw.WebImage( url, x, y, width, height, color, angle, cornerorigin )
	color = color or white

	local img = fetch_asset(url)
	if (not img or img == _error) then return end

	surface_SetDrawColor( color.r, color.g, color.b, color.a )
	surface_SetMaterial(img)
	if not angle then
		surface_DrawTexturedRect( x, y, width, height)
	else
		if not cornerorigin then
			surface_DrawTexturedRectRotated( x, y, width, height, angle )
		else
			surface_DrawTexturedRectRotated( x + width / 2, y + height / 2, width, height, angle )
		end
	end
end

function draw.SeamlessWebImage( url, parentwidth, parentheight, xrep, yrep, color )
	color = color or white
	local xiwx, yihy = math.ceil( parentwidth/xrep ), math.ceil( parentheight/yrep )
	for x = 0, xrep - 1 do
		for y = 0, yrep - 1 do
			draw.WebImage( url, x*xiwx, y*yihy, xiwx, yihy, color )
		end
	end
end

function draw.SteamAvatar(avatar, res, x, y, width, height, color, ang, corner)
	fetchAvatarAsset(avatar, res, function(url)
		draw.WebImage(url, x, y, width, height, color, ang, corner)
	end)
end
