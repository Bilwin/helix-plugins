local plugin = PLUGIN
plugin.name = "CCA Cameras"
plugin.author = "You're here"
plugin.description = "..."
plugin.schema = "HL2 RP"
plugin.readme = [[
    Example plugin for camera NPC usage

    if player has weapon_slam or etc. camera be triggered, and you can put some function for trigger (sv_hooks.lua 33 line)
]]

ix.util.Include("sv_hooks.lua")
