
local PLUGIN = PLUGIN
PLUGIN.name = "Civil Protection, Citizens Database"
PLUGIN.author = "Bilwin"

ix.char.RegisterVar("loyalPoints", {
	field = "loyalPoints",
	fieldType = ix.type.number,
	default = 0,
	bNoDisplay = true
})

ix.char.RegisterVar("wanted", {
	field = "wanted",
	fieldType = ix.type.bool,
	default = false,
	bNoDisplay = true
})

ix.char.RegisterVar("CID", {
	field = "CID",
	fieldType = ix.type.bool,
	default = false,
	bNoDisplay = true
})

ix.util.Include("sv_plugin.lua")
ix.util.Include("sh_cmds.lua")