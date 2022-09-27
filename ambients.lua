local PLUGIN        = PLUGIN
PLUGIN.name         = 'Ambient Music'
PLUGIN.description  = 'Adds background music'
PLUGIN.author       = 'Bilwin'
PLUGIN.ambients     = {
    {path = 'music/hl2_song13.mp3', duration = 54},
    {path = 'music/hl2_song17.mp3', duration = 61},
    {path = 'music/hl2_song2.mp3',  duration = 173},
    {path = 'music/hl2_song30.mp3', duration = 104},
    {path = 'music/hl2_song8.mp3',  duration = 60}
}

ix.config.Add('allowCustomAmbients', true, 'Allow User-Custom Ambients (All on clientside)', function(_, newValue)
    if not SERVER then return end
    net.Start('ixAmbientConfigToggle', true) -- should be on unreliable channel
        net.WriteBool(newValue)
    net.Broadcast()
end, {
    category = PLUGIN.name
})

ix.option.Add('enableAmbient', ix.type.bool, true, {
    category = PLUGIN.name,
    phrase = '',
    description = '',
    OnChanged = function(_, newValue)
        if not IsValid(PLUGIN.ambient) then return end

        if newValue then
            PLUGIN.ambient:ChangeVolume(1, 1) -- probably audio stacks issue
        else
            PLUGIN.ambient:FadeOut(1) -- probably audio stacks issue
        end
    end
})

if CLIENT then
    function PLUGIN:AmbientsReload()
        if not ix.config.Get('allowCustomAmbients', false) then return end
        local listExists = file.Exists('settings/ixAmbients.json', 'MOD') -- in /settings/ folder for security purposes

        if listExists then
            local listContent = file.Read('settings/ixAmbients.json', 'GAME')
            if not listContent then return end
            listContent = util.JSONToTable(listContent)
            if not listContent or not next(listContent) then return end

            self.ambients = {}
            for path, duration in pairs( listContent ) do
                self.ambients[#self.ambients + 1] = {path = path, duration = duration}
            end

            print(('Detected %i custom ambients, redefined successfully'):format(#listContent))
        end
    end

    concommand.Add('ixAmbientsReload', function()
        PLUGIN:AmbientsReload() -- should be called via :
    end, nil, 'Re-check the ambients file content', FCVAR_UNLOGGED)

    local lastAmbient = '' -- prevent playing similar ambients
    function PLUGIN:PlayAmbient()
        if not ix.option.Get('enableAmbient', false) then return end
        local newAmbient = self.ambients[math.random(#self.ambients)]
        local actualPath = newAmbient[1]
        local actualLength = newAmbient[2]

        if actualPath == lastAmbient and #self.ambients > 1 then
            self:PlayAmbient()
            return
        end

        if IsValid(self.ambient) then self.ambient:Stop() end -- ears saver
        self.ambient = CreateSound(game.GetWorld(), actualPath)
            if not self.ambient then
                print(('Error playing \'%s\' ambient, discarding...'):format(actualPath))
                self:PlayAmbient()
                return
            end
            self.ambient:SetSoundLevel(0) -- play everywhere (like surface.PlaySound)
            self.ambient:Play()
            self.ambient:ChangeVolume(0) -- zero volume
        self.ambient:ChangeVolume(1, 1) -- fade in

        timer.Create('ixAmbientFadeOut', actualLength - 1, 1, function()
            if not IsValid(self.ambient) then return end
            self.ambient:FadeOut(1)
            self:PlayAmbient()
        end)

        lastAmbient = actualPath
    end

    net.Receive('ixAmbientPlayerLoadedCharacter', function()
        PLUGIN:PlayAmbient()

        -- if ix.config.Get('music') ~= '' then
        --     local actuallyFaden = false
        --     local actuallyEnabled = false
        --     timer.Create('ixAmbientCharacterMenuSaver', 1, 0, function()
        --         if not IsValid(PLUGIN.ambient) then return end
        --         if IsValid(ix.gui.characterMenu) and not actuallyFaden then
        --             PLUGIN.ambient:FadeOut(1)
        --             actuallyFaden = true
        --         elseif actuallyFaden then
        --             -- brain time lol
        --             PLUGIN.ambient:ChangeVolume(1, 1)
        --             actuallyFaden = false
        --         end
        --     end)
        -- end
    end)
end

if SERVER then
    util.AddNetworkString('ixAmbientPlayerLoadedCharacter')
    util.AddNetworkString('ixAmbientConfigToggle')

    function PLUGIN:PlayerLoadedCharacter(client, _, cc)
        if cc then return end -- only first character
        net.Start('ixAmbientPlayerLoadedCharacter', true) -- should be on unreliable channel
        net.Send(client)
    end

    PLUGIN.serializedAmbients = util.TableToJSON( PLUGIN.ambients )
end