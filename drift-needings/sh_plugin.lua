
PLUGIN.name = "Hunger & Thirst"
PLUGIN.author = "Bilwin"
PLUGIN.description = "..."
PLUGIN.schema = "Any"
PLUGIN.license = [[
    Copyright 2020 Maxim Sukharev (Bilwin)
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
]]

local ix = ix or {}
ix.Hunger = ix.Hunger or {}

ix.util.Include("sv_hooks.lua", "server")
ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("cl_bars.lua", "client")
