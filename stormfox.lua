
PLUGIN.name = "StormFox 2 Support"
PLUGIN.description = "Something new thing"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

if !StormFox2 then return end

if (SERVER) then
    function PLUGIN:InitPostEntity()
        RunConsoleCommand("sf_time_speed", 1)
    end

    hook.Add("StormFox2.InitPostEntity", "stormfox:StormFox2.InitPostEntity", function()
        local localTime = ix.date.GetFormatted('%H:%M')
        local validTime = StormFox2.Time.StringToTime(localTime)
        StormFox2.Time.Set(validTime)
    end)
end
