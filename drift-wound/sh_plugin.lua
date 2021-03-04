
PLUGIN.name = "Wounds"
PLUGIN.author = "Bilwin"
PLUGIN.description = "..."
PLUGIN.schema = "any"
PLUGIN.license = [[
    Copyright 2021 Maxim Sukharev (Bilwin) All Rights Reserved
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
]]

ix.char.RegisterVar("bIsBleeding", { 
    field = "bIsBleeding",
    fieldType = ix.type.bool,
    default = false,
    bNoDisplay = true
})

ix.char.RegisterVar("bIsFractured", { 
    field = "bIsFractured",
    fieldType = ix.type.bool,
    default = false,
    bNoDisplay = true
})

local ix = ix or {}
ix.Wounds = ix.Wounds or {}

ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("sv_hooks.lua", "server")