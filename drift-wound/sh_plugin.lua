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

ix.util.Include("sv_hooks.lua")