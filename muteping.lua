
local PLUGIN = PLUGIN
PLUGIN.name = 'Mute Camera Pings'
PLUGIN.description = 'Mute Camera "beep" pings'
PLUGIN.author = 'Bilwin'

function PLUGIN:EntityEmitSound(soundData)
    if (soundData.Entity and IsValid(soundData.Entity)) then
        if (soundData.Entity:GetClass() == "npc_combine_camera") then
            local soundName = soundData.SoundName
            if soundName == 'npc/turret_floor/ping.wav' then
                return false
            end
        end
    end
end