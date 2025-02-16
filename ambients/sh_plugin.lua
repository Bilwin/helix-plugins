local PLUGIN = PLUGIN
PLUGIN.name = 'Ambients'
PLUGIN.author = 'Bilwin'

PLUGIN.defaultAmbientList = 'Half-Life 2' -- @comment from .ambientsList
PLUGIN.defaultSpawnAmbient = 'Combine Citizenship' -- @comment from .spawnLists

PLUGIN.ambientsList = {
    {
        name = 'Half-Life', -- @comment playlist name
        ost = {
            {'music/half-life03.mp3', 55}, -- @comment path, duration
            {'music/half-life04.mp3', 57},
            {'music/half-life05.mp3', 38},
            {'music/half-life07.mp3', 43},
            {'music/half-life11.mp3', 36}
        }
    },
    {
        name = 'Half-Life 2',
        ost = {
            {'music/hl2_song1.mp3', 44},
            {'music/hl2_song13.mp3', 56},
            {'music/hl2_song19.mp3', 115},
            {'music/hl2_song2.mp3', 172},
            {'music/hl2_song27_trainstation2.mp3', 72}
        }
    }
}

PLUGIN.spawnLists = { --- @comment start ambient when character loads
    {
        name = 'Combine Citizenship', --- @comment spawn playlist name
        ost = {
            [FACTION_CITIZEN]         = {'music/hl2_song26_trainstation1.mp3', 90}, --- @comment [faction id] = {path, duration}
            [FACTION_METROPOLICE]     = {'music/vlvx_song26.mp3', 110},
            [FACTION_OTA]             = {'music/hl1_song14.mp3', 92}
        }
    },
    {
        name = 'Raising the Bar',
        ost = {
            [FACTION_CITIZEN]       = {'music/hl2_song17.mp3', 63},
            [FACTION_METROPOLICE]   = {'music/hl1_song5.mp3', 98},
            [FACTION_OTA]           = {'music/vlvx_song28.mp3', 193}
        }
    },
    {
        name = 'Nothing',
        ost = {
            [FACTION_CITIZEN]       = {'', 0},
            [FACTION_METROPOLICE]   = {'', 0},
            [FACTION_OTA]           = {'', 0}
        }
    }
}

ix.config.Add('enableAmbients', true, 'Should we enable a background music system', function(_, newValue)
    if not SERVER then return end

    net.Start('ixEnableAmbients', true)
        net.WriteBool(newValue)
    net.Broadcast()
end, {
    category = PLUGIN.name
})

ix.util.Include('sv_plugin.lua')
ix.util.Include('cl_plugin.lua')