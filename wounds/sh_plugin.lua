
PLUGIN.name = "Wounds"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.license = [[
    Copyright 2021 Maxim Sukharev (Bilwin) All Rights Reserved
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
]]

do
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
end

ix.util.Include("sv_hooks.lua", "server")