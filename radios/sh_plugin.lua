
PLUGIN.name = "Radios"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds radio"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0
PLUGIN.songs = {
    [''] = "Stop",
    ["example/radio/song1.mp3"] = "Song #1",
    ["example/radio/song2.mp3"] = "Song #2"
}

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")