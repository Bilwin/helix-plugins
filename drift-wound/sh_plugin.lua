local plugin = PLUGIN
plugin.name = "Wounds"
plugin.author = "Bilwin"
plugin.description = "..."
plugin.schema = "any"
plugin.license = [[
    Copyright 2020 Maxim Sukharev (Bilwin)
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
]]

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