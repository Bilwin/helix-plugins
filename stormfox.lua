
PLUGIN.name = "StormFox 2 support"
PLUGIN.description = "Something new thing"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"

if !StormFox2 then return end
PLUGIN.maps = { -- Custom SF2 options
    ['rp_rg_city34_v1'] = {
        ['sf_extra_lightsupport'] = -1,
        ['sf_random_round_weather'] = 0,
        ['sf_maplight_max'] = 55,
        ['sf_maplight_updaterate'] = 3,
        ['sf_extra_darkness'] = 1,
        ['sf_extra_darkness_amount'] = 0.9,
        ['sf_enable_ice'] = 0,
        ['sf_footprint_enablelogic'] = 0,
        ['sf_min_temp'] = 10
    }
}

if (SERVER) then
    function PLUGIN:InitPostEntity()
        RunConsoleCommand("sf_time_speed", 1)
        RunConsoleCommand("sf_addnight_temp", 4)

        if self.maps[game.GetMap()] then
            for command, value in pairs( self.maps[game.GetMap()] ) do
                RunConsoleCommand(command, value)
            end
        end

        RunConsoleCommand("sf_windmove_props", 0)
        RunConsoleCommand("sf_windmove_props_break", 0)
        RunConsoleCommand("sf_windmove_props_unfreeze", 0)
        RunConsoleCommand("sf_windmove_props_unweld", 0)
        RunConsoleCommand("sf_windmove_props_makedebris", 0)
    end

    hook.Add("StormFox2.InitPostEntity", "stormfox:StormFox2.InitPostEntity", function()
        local localTime = ix.date.GetFormatted('%H:%M')
        local validTime = StormFox2.Time.StringToTime(localTime)
        StormFox2.Time.Set(validTime)
    end)
end
