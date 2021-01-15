
local function EnableBars()
	ix.bar.Remove("thirst")
	ix.bar.Add( function()
		return math.max( LocalPlayer():GetCharacter():GetThirst() / 100, 0 )
	end, Color( 68, 106, 205 ), nil, "thirst", "hudSaturation" )

	ix.bar.Remove("hunger")
	ix.bar.Add( function()
		return math.max( LocalPlayer():GetCharacter():GetHunger() / 100, 0 )
	end, Color( 203, 151, 0 ), nil, "hunger", "hudSatiety" )
end

net.Receive("EnableHungerBars", EnableBars)