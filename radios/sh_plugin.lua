
PLUGIN.name = "Radios"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds radio"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

ix.Radio = {}
ix.Radio.Songs = {
    {path = "", name = "Stop"},
    {path = "example/radio/song1.mp3", name = "Song #1"},
    {path = "example/radio/song2.mp3", name = "Song #2"},
    {path = "example/radio/song3.mp3", name = "Song #3"},
    {path = "example/radio/song4.mp3", name = "Song #4"},
    {path = "example/radio/song5.mp3", name = "Song #5"},
    {path = "example/radio/song6.mp3", name = "Song #6"},
    {path = "example/radio/song7.mp3", name = "Song #7"},

    whitelisted = {
        '',
        'example/radio/song1.mp3',
        'example/radio/song2.mp3',
        'example/radio/song3.mp3',
        'example/radio/song4.mp3',
        'example/radio/song5.mp3',
        'example/radio/song6.mp3',
        'example/radio/song7.mp3'
    }
}

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")