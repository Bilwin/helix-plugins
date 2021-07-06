
local PLUGIN = PLUGIN

ix.config.Add("maxXPgain", 5, "Points awarded when playing on the server", nil, {
	data = {min = 0, max = 50},
	category = PLUGIN.name
})

ix.config.Add("XPgainEnabled", true, "Will the XP auto-give system be enabled?.", nil, {
	category = PLUGIN.name
})