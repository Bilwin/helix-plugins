local PLUGIN        = PLUGIN
PLUGIN.name         = 'Ambient Music'
PLUGIN.description  = 'Adds background music'
PLUGIN.author       = 'Bilwin'
PLUGIN.songs = {
    {path = 'music/hl2_song13.mp3', duration = 54},
    {path = 'music/hl2_song17.mp3', duration = 61},
    {path = 'music/hl2_song2.mp3', duration = 173},
    {path = 'music/hl2_song30.mp3', duration = 104},
    {path = 'music/hl2_song8.mp3', duration = 60}
}

ix.lang.AddTable('english', {
	optEnableAmbient = 'Enable ambient',
    optAmbientVolume = 'Ambient volume'
})

ix.lang.AddTable('russian', {
	optEnableAmbient = 'Включить фоновую музыку',
    optAmbientVolume = 'Громкость фоновой музыки'
})

if CLIENT then
    if next(PLUGIN.songs) ~= nil then
        for _, data in ipairs(PLUGIN.songs) do
            util.PrecacheSound(data.path)
        end
    end

    m_iAmbientCooldown = m_iAmbientCooldown || 0
    bAmbientPreSaver = bAmbientPreSaver || false

    ix.option.Add('enableAmbient', ix.type.bool, true, {
		category = PLUGIN.name,
        OnChanged = function(oldValue, value)
            if not IsValid(PLUGIN.ambient) then return end
            if value then
                PLUGIN.ambient:SetVolume(ix.option.Get('ambientVolume', 1))
            else
                PLUGIN.ambient:SetVolume(0)
            end
        end
	})

	ix.option.Add('ambientVolume', ix.type.number, 0.5, {
		category = PLUGIN.name,
        min = 0.1,
        max = 2,
        decimals = 1,
        OnChanged = function(oldValue, value)
            if IsValid(PLUGIN.ambient) && ix.option.Get('enableAmbient', true) then
                PLUGIN.ambient:SetVolume(value)
            end
        end
	})

    function PLUGIN:CreateAmbient()
        local bEnabled = ix.option.Get('enableAmbient', true)

        if (bEnabled && not bAmbientPreSaver) then
            local iVolume = ix.option.Get('ambientVolume', 1)
            local mSongTable = self.songs[math.random(1, #self.songs)]
            local mSongPath = mSongTable.path
            local mSongDuration = mSongTable.duration || SoundDuration(mSongPath)

            sound.PlayFile('sound/' .. mSongTable.path, 'noblock', function(mSongObj)
                if IsValid(mSongObj) then
                    if IsValid(self.ambient) then self.ambient:Stop() end

                    mSongObj:SetVolume(iVolume)
                    mSongObj:Play()
                    self.ambient = mSongObj

                    m_iAmbientCooldown = os.time() + mSongDuration + 10 -- presaver
                    timer.Create('mAmbientMusicFinal', m_iAmbientCooldown, 1, function() -- should be timer.Simple?
                        self:CreateAmbient()
                    end)
                end
            end)
        end
    end

    net.Receive('ixPlayAmbient', function()
        if not timer.Exists('m_tAmbientChecker') then
            timer.Create('m_tAmbientChecker', 0.5, 0, function()
                if not IsValid(PLUGIN.ambient) then return end
                if IsValid(ix.gui.characterMenu) && ix.config.Get('music') ~= '' then
                    PLUGIN.ambient:SetVolume(0)
                else
                    if ix.option.Get('enableAmbient', true) then
                        PLUGIN.ambient:SetVolume(ix.option.Get('ambientVolume', 1))
                    end
                end
            end)
        end
    end)
end

if SERVER then
    util.AddNetworkString('ixPlayAmbient')
    function PLUGIN:PlayerLoadedCharacter(client)
        net.Start('ixPlayAmbient') -- not a good practice
        net.Send(client)
    end
end