
local PLUGIN = PLUGIN

ix.config.Add("cpMaxPlayersPercent", 25, "Сколько % игроков может быть за Г.О.", nil, {
	data = {min = 1, max = 75},
	category = PLUGIN.name
})

ix.config.Add("cpMaxOfficer", 1, "Сколько максимум Офицеров может быть на сервере", nil, {
	data = {min = 1, max = 100},
	category = PLUGIN.name
})

ix.config.Add("cpCityNumber", 17, "Номер города, для выдачи кода Г.О.", nil, {
	data = {min = 1, max = 100},
	category = PLUGIN.name
})
