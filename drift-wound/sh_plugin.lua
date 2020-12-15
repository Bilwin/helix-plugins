local plugin = PLUGIN
plugin.name = "Wounds"
plugin.author = "Bilwin"
plugin.description = "..."
plugin.license = "Check Git Repo License"

ix.char.RegisterVar("bIsBleeding", { 
    field = "bIsBleeding",
    fieldType = ix.type.bool,
    default = false
})

ix.char.RegisterVar("bIsFractured", { 
    field = "bIsFractured",
    fieldType = ix.type.bool,
    default = false
})

local ix = ix or {}
ix.Wounds = ix.Wounds or {}

ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("sv_hooks.lua", "server")