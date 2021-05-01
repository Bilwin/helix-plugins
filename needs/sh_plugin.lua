
PLUGIN.name = "Primary Needs"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.license = [[
    Copyright 2021 Maxim Sukharev (Bilwin)
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
]]

do
    ix.char.RegisterVar("saturation", {
        field = "saturation",
        fieldType = ix.type.number,
        isLocal = true,
        bNoDisplay = true,
        default = 60
    })

    ix.char.RegisterVar("satiety", {
        field = "satiety",
        fieldType = ix.type.number,
        isLocal = true,
        bNoDisplay = true,
        default = 60
    })
end

ix.util.Include( "sv_hooks.lua", "server" )
ix.util.Include( "sh_meta.lua", "shared" )
ix.util.Include( "sh_config.lua", "shared" )
ix.util.Include( "sh_commands.lua", "shared" )
ix.util.Include( "cl_bars.lua", "client" )
