
local PLUGIN = PLUGIN

ix.config.Add("primaryNeedsDelay", 120, "How long does it take to calculate the character's primary needs? (In seconds)", function(oldValue, newValue)
	if (SERVER) then
		for _, pl in ipairs(player.GetAll()) do
			if IsValid(pl) and pl:GetCharacter() then
				if timer.Exists("ixPrimaryNeeds." .. pl:AccountID()) then timer.Remove("ixPrimaryNeeds." .. pl:AccountID()) end
				PLUGIN:CreateNeedsTimer(pl, pl:GetCharacter())
			end
		end
	end
end, {data = {min = 1, max = 1000}, category = PLUGIN.name})

ix.config.Add("deathCountdown", 300, "How long will it take for a character to die if starving", nil, {
	data = {min = 0, max = 1000},
	category = PLUGIN.name
})

ix.config.Add("saturationConsume", 3, "How much saturation will be taken from the character", nil, {
	data = {min = 0, max = 100},
	category = PLUGIN.name
})

ix.config.Add("satietyConsume", 2, "How much satiety will be taken from the character", nil, {
	data = {min = 0, max = 100},
	category = PLUGIN.name
})