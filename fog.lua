PLUGIN.name = "Fog"
PLUGIN.author = "Bilwin"
PLUGIN.description = "..."
PLUGIN.schema = "Any"

local ix = ix or {}
ix.Seasons = ix.Seasons or {
    ["winter"] = {
        fogColor = Vector( 135, 206, 235 ),
        fogStart = 500,
        fogEnd = 1300,
        fogDensity = 0.15,
        fogFade = 0
    },
    ["summer"] = {
        fogColor = Vector( 170, 100, 31 ),
        fogStart = 500,
        fogEnd = 1300,
        fogDensity = 0.15,
        fogFade = 0
    }
}

ix.Seasons.Active = "winter"

if ( CLIENT ) then
    local _data = ix.Seasons[ix.Seasons.Active]
    local fog_data = {
        ["fog_start"] = _data.fogStart,
        ["fog_end"] = _data.fogEnd,
        ["fog_color"] = _data.fogColor,
        ["fog_max_density"] = _data.fogDensity,
        ["fog_fade"] = _data.fogFade
    }

    local function SetupFog()
        render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(fog_data.fog_start)
            render.FogEnd(fog_data.fog_end)
            render.FogColor(fog_data.fog_color.r, fog_data.fog_color.g, fog_data.fog_color.b)
        render.FogMaxDensity(math.Clamp(fog_data.fog_max_density * ( fog_data.fog_fade or 0 ), 0.19, 1))

        return true
    end

    hook.Add("SetupWorldFog", "Seasons:SetupWorldFog", SetupFog)
    hook.Add("SetupSkyboxFog", "Seasons:SetupWorldFogSnow", SetupFog)
end