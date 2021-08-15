This library is used by developers for convenient development and creation of small functions, it is not intended for further modification.
This library makes outlined helix chat black and white!
How to fix:
```
hook.Add("LoadFonts", "ixChatOutlinedFix", function(font, genericFont)
	surface.CreateFont("ixChatFontOutlined", {
		font = font,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		outline = true
	})

	surface.CreateFont("ixChatFontItalicsOutlined", {
		font = font,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		italic = true,
		outline = true
	})
end)

-- called when a markup object should paint its text
local function PaintMarkupOverride(text, font, x, y, color, alignX, alignY, alpha)
	alpha = alpha or 255
	if (ix.option.Get("chatOutline", false)) then
		-- outlined background for even more visibility
		draw.SimpleTextOutlined(text, font, x, y, color, alignX, alignY, 1, color_black)
	else
		-- background for easier reading
		surface.SetTextPos(x + 1, y + 1)
		surface.SetTextColor(0, 0, 0, alpha)
		surface.SetFont(font)
		surface.DrawText(text)

		surface.SetTextPos(x, y)
		surface.SetTextColor(color.r, color.g, color.b, alpha)
		surface.SetFont(font)
		surface.DrawText(text)
	end
end
```