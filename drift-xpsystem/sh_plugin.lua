local plugin = PLUGIN
plugin.name = "XP System"
plugin.author = "Bilwin"
plugin.description = "..."
plugin.license = "Check Git Repo License"
plugin.readme = [[
    This plugin adds the XP system to the server, if it is enabled.
    If used correctly, you can make it so that you need to have some XP to select a class.
    The table ix.XPSystem.whitelists contains fractions and classes for it, and XP need (Classes are necessary!)
]]

local ix = ix or {}
ix.XPSystem = ix.XPSystem or {}
ix.XPSystem.prefix = ix.XPSystem.prefix or "[IX:XP]"
ix.XPSystem.whitelists = ix.XPSystem.whitelists or {
    [FACTION_CITIZEN] = {
        [CLASS_CITIZEN] = 0,
        [CLASS_CWU]     = 5
    },
    [FACTION_MPF] = {
        [CLASS_MPR]     = 50,
        [CLASS_MPU]     = 75,
        [CLASS_EMP]     = 100
    },
    [FACTION_OTA] = {
        [CLASS_OWS]     = 200,
        [CLASS_EOW]     = 300
    },
    [FACTION_ADMIN] = {
        [CLASS_ADMIN]   = 600
    }
}

ix.config.Add("maxXPGain", 5, "Points awarded when playing on the server", nil, {
	data = {min = 0, max = 50},
	category = "characters"
})

ix.config.Add("XPGainEnabled", true, "Will the XP auto-give system be enabled?.", nil, {
	category = "characters"
})

ix.util.Include("sv_hooks.lua", "server")
ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("sh_language.lua", "shared")