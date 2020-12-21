
PLUGIN.name = "Hunger & Thirst"
PLUGIN.author = "Bilwin"
PLUGIN.description = "..."
PLUGIN.schema = "Any"

local ix = ix or {}
ix.Hunger = ix.Hunger or {}

ix.util.Include("sv_hooks.lua", "server")
ix.util.Include("sh_meta.lua", "shared")
