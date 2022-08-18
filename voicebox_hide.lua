PLUGIN.name     = 'VoiceBox Remover'
PLUGIN.author   = 'Bilwin'

if CLIENT then
    function PLUGIN:PlayerStartVoice()
        if IsValid(g_VoicePanelList) then
            g_VoicePanelList:Remove()
        end
    end
end