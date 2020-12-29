
ix.config.Add("needsEnabled", true, "Whether or not the Needs system is enabled.", nil, {
    category = "Needs"
})

ix.config.Add("starvingKilling", true, "Whether or not the Needs system can kill player.", nil, {
    category = "Needs"
})

ix.config.Add("needsDamage", 2, "How much damage to take starving.", nil, {
	data = {min = 0, max = 100},
	category = "Needs"
})

ix.config.Add("hungerDowngrade", 2, "How much satiety will be taken from the player", nil, {
	data = {min = 0, max = 100},
	category = "Needs"
})

ix.config.Add("thirstDowngrade", 3, "How much saturation will be taken from the player", nil, {
	data = {min = 0, max = 100},
	category = "Needs"
})