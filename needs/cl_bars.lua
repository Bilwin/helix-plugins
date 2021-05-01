
do
	if ix.bar.Get("saturation") then
		ix.bar.Remove("saturation")
	end

	ix.bar.Add( function()
		return math.max( LocalPlayer():GetLocalVar("saturation") / 100, 0 )
	end, Color( 68, 106, 205 ), nil, "saturation", "hudSaturation" )

	if ix.bar.Get("satiety") then
		ix.bar.Remove("satiety")
	end

	ix.bar.Add( function()
		return math.max( LocalPlayer():GetLocalVar("satiety") / 100, 0 )
	end, Color( 203, 151, 0 ), nil, "satiety", "hudSatiety" )
end