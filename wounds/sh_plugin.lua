
PLUGIN.name = "Wounds"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

ix.char.RegisterVar("bleeding", {
    field = "bleeding",
    fieldType = ix.type.bool,
    default = false,
    isLocal = true,
    bNoDisplay = true
})

ix.char.RegisterVar("fracture", {
    field = "fracture",
    fieldType = ix.type.bool,
    default = false,
    isLocal = true,
    bNoDisplay = true
})

ix.util.Include("sv_hooks.lua")