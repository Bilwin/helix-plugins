
local PLUGIN = PLUGIN
local entityMeta = ENTITY
local playerMeta = PLAYER

function entityMeta:GetPrimaryVisorColor()
    return self:GetNWVector("PrimaryVisorColor")
end

function entityMeta:GetSecondaryVisorColor()
    return self:GetNWVector("SecondaryVisorColor")
end

function entityMeta:SetPrimaryVisorColor( vector )
	if isvector(vector) then
		self:SetNWVector("PrimaryVisorColor", vector)
	end
end

function entityMeta:SetSecondaryVisorColor( vector )
	if isvector(vector) then
		self:SetNWVector("SecondaryVisorColor", vector)
	end
end

function entityMeta:GetArmbandCode()
	local code = self:GetNWString("ArmbandCode")
	if code and code != "" then
		local codeTable = string.Explode("_", code)
		if codeTable then
			local bg_color = Color(255,255,255)
			local icon_color = Color(255,255,255)
			local text_color = Color(255,255,255)

			if codeTable[1] then
				local r, g, b = codeTable[1]:match("%((%d+),(%d+),(%d+)%)")
				bg_color = Color( r, g, b )
			end

			if codeTable[3] then
				local r, g, b, a = codeTable[3]:match("%((%d+),(%d+),(%d+),(%d+)%)")
				icon_color = Color( r, g, b, a )
			end

			if codeTable[5] then
				local r, g, b, a = codeTable[5]:match("%((%d+),(%d+),(%d+),(%d+)%)")
				text_color = Color( r, g, b, a )
			end

			local backgroundID = tonumber(codeTable[2])
			local iconID = tonumber(codeTable[4])
			local textID = tonumber(codeTable[6])

		    return bg_color, backgroundID, icon_color, iconID, text_color, textID
		end
	end
end

function entityMeta:SetArmbandCode(clrBG, numBG, clrIcon, numIcon, clrText, numText)
	local code = "(%s,%s,%s)_%s_(%s,%s,%s,%s)_%s_(%s,%s,%s,%s)_%s"
	local str = string.format(code, tostring(clrBG.r), tostring(clrBG.g), tostring(clrBG.b), tostring(numBG), tostring(clrIcon.r), tostring(clrIcon.g), tostring(clrIcon.b), tostring(clrIcon.a), tostring(numIcon), tostring(clrText.r), tostring(clrText.g), tostring(clrText.b), tostring(clrText.a), tostring(numText))
	self:SetNWString("ArmbandCode", str)
end
