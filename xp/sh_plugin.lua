
local PLUGIN = PLUGIN
PLUGIN.name = "XP System"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds XP whitelisted system"
PLUGIN.schema = "Any"
PLUGIN.version = 1.03
PLUGIN.whitelists = {
    --[FACTION_CITIZEN] = {
    --    [CLASS_CITIZEN] = 0,
    --    [CLASS_CWU]     = 5
    --},
    --[FACTION_MPF] = {
    --    [CLASS_MPR]     = 50,
    --    [CLASS_MPU]     = 75,
    --    [CLASS_EMP]     = 100
    --},
    --[FACTION_OTA] = {
    --    [CLASS_OWS]     = 200,
    --    [CLASS_EOW]     = 300
    --},
    --[FACTION_ADMIN] = {
    --    [CLASS_ADMIN]   = 600
    --}
}

ix.util.Include("sv_hooks.lua")

ix.char.RegisterVar("XP", {
    field = "XP",
    fieldType = ix.type.number,
    isLocal = true,
    bNoDisplay = true,
    default = 0
})

ix.lang.AddTable("english", {
	xpGainTime = "You got %s XP!",
    xpAborted = "Your XP has been reset!",
    xpSet = "Your XP was set on %s"
})

ix.lang.AddTable("russian", {
	xpGainTime = "Вы получили %s XP!",
    xpAborted = "Ваши XP были обнулены!",
    xpSet = "Ваш XP был установлен на %s"
})

ix.config.Add("maxXPgain", 5, "Points awarded when playing on the server", nil, {
	data = {min = 0, max = 50},
	category = PLUGIN.name
})

ix.config.Add("XPgainEnabled", true, "Will the XP auto-give system be enabled?.", nil, {
	category = PLUGIN.name
})
