
local ix = ix
local PLUGIN = PLUGIN
PLUGIN.name = "Scroll Text"
PLUGIN.description = "Provides an interface for drawing and sending 'scrolling text.'"
PLUGIN.author = "Chessnut"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

if !netstream then return end

PLUGIN.scroll = PLUGIN.scroll or {}
PLUGIN.scroll.buffer = PLUGIN.scroll.buffer or {}

local CHAR_DELAY = 0.1
if (CLIENT) then
    function PLUGIN:AddText(text, callback)
        local info = {text = "", callback = callback, nextChar = 0, char = ""}
		local index = table.insert(self.scroll.buffer, info)
		local i = 1

		timer.Create("ScrollText."..tostring(info), CHAR_DELAY, #text, function()
			if (info) then
				info.text = string.sub(text, 1, i)
				i = i + 1

				LocalPlayer():EmitSound("common/talk.wav", 40, math.random(120, 140))

				if (i >= #text) then
					info.char = ""
					info.start = RealTime() + 3
					info.finish = RealTime() + 5
				end
			end
		end)
    end

	local SCROLL_X = ScrW() * 0.9
	local SCROLL_Y = ScrH() * 0.7

    function PLUGIN:HUDPaint()
        local curTime = RealTime()
		for k, v in pairs(self.scroll.buffer) do
			local alpha = 255

			if (v.start and v.finish) then
				alpha = 255 - math.Clamp(math.TimeFraction(v.start, v.finish, curTime) * 255, 0, 255)
			elseif (v.nextChar < curTime) then
				v.nextChar = RealTime() + 0.01
				v.char = string.char(math.random(47, 90))
			end

			ix.util.DrawText(v.text..v.char, SCROLL_X, SCROLL_Y - (k * 24), Color(255, 255, 255, alpha), 2, 1)

			if (alpha == 0) then
				if (v.callback) then
					v.callback()
				end

				table.remove(self.scroll.buffer, k)
			end
		end
    end

	netstream.Hook('ixScrollData', function(data)
		PLUGIN:AddText(data)
	end)
else
	function PLUGIN:Send(text, receiver, callback)
		netstream.Start(receiver, 'ixScrollData', text)

		timer.Simple(CHAR_DELAY*#text + 4, function()
			if (callback) then
				callback()
			end
		end)
	end
end