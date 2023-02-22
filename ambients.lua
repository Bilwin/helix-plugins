
local PLUGIN = PLUGIN
local _tonumber = tonumber
local _math_ceil = math.ceil
local _SoundDuration = SoundDuration
local util_PrecacheSound = util.PrecacheSound

PLUGIN.name = "Ambient Music"
PLUGIN.description = "Adds background music"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0
PLUGIN.songs = {
    {path = "music/hl2_song13.mp3", duration = 54},
    {path = "music/hl2_song17.mp3", duration = 61},
    {path = "music/hl2_song2.mp3", duration = 173},
    {path = "music/hl2_song30.mp3", duration = 104},
    {path = "music/hl2_song8.mp3", duration = 60},
}

ix.lang.AddTable("english", {
	optEnableAmbient = "Enable ambient",
    optAmbientVolume = "Ambient volume"
})

ix.lang.AddTable("russian", {
	optEnableAmbient = "Включить фоновую музыку",
    optAmbientVolume = "Громкость фоновой музыки"
})

if CLIENT then
    if !table.IsEmpty(PLUGIN.songs) then
        for _, data in ipairs(PLUGIN.songs) do
            util_PrecacheSound(data.path)
        end
    end

    m_flAmbientCooldown = m_flAmbientCooldown or 0
    bAmbientPreSaver = bAmbientPreSaver or false

    ix.option.Add("enableAmbient", ix.type.bool, true, {
		category = PLUGIN.name,
        OnChanged = function(oldValue, value)
            if value then
                if IsValid(PLUGIN.ambient) then
                    local volume = ix.option.Get("ambientVolume", 1)
                    PLUGIN.ambient:SetVolume(volume)
                end
            else
                if IsValid(PLUGIN.ambient) then
                    PLUGIN.ambient:SetVolume(0)
                end
            end
        end
	})

	ix.option.Add("ambientVolume", ix.type.number, 0.5, {
		category = PLUGIN.name,
        min = 0.1,
        max = 2,
        decimals = 1,
        OnChanged = function(oldValue, value)
            if IsValid(PLUGIN.ambient) and ix.option.Get("enableAmbient", true) then
                PLUGIN.ambient:SetVolume(value)
            end
        end
	})

    function PLUGIN:CreateAmbient()
        local bEnabled = ix.option.Get('enableAmbient', true)

        if (bEnabled and !bAmbientPreSaver) then
            local flVolume = _tonumber(ix.option.Get('ambientVolume', 1))
            local mSongTable = self.songs[math.random(1, #self.songs)]
            local mSongPath = mSongTable.path
            local mSongDuration = mSongTable.duration or _SoundDuration(mSongPath)

            sound.PlayFile('sound/' .. mSongTable.path, 'noblock', function(radio)
                if IsValid(radio) then
                    if IsValid(self.ambient) then self.ambient:Stop() end

                    radio:SetVolume(flVolume)
                    radio:Play()
                    self.ambient = radio

                    m_flAmbientCooldown = os.time() + _tonumber(mSongDuration) + 10
                end
            end)
        end
    end

    net.Receive('ixPlayAmbient', function()
        if !timer.Exists('mAmbientMusicChecker') then
            timer.Create('mAmbientMusicChecker', 5, 0, function()
                if (m_flAmbientCooldown or 0) > os.time() then return end
                PLUGIN:CreateAmbient()
            end)
        end

        if !timer.Exists('mAmbientChecker') then
            timer.Create('mAmbientChecker', 0.5, 0, function()
                if IsValid(ix.gui.characterMenu) and ix.config.Get("music") ~= "" then
                    if IsValid(PLUGIN.ambient) then
                        PLUGIN.ambient:SetVolume(0)
                    end
                else
                    if ix.option.Get('enableAmbient', true) then
                        if IsValid(PLUGIN.ambient) then
                            local volume = ix.option.Get("ambientVolume", 1)
                            PLUGIN.ambient:SetVolume(volume)
                        end
                    end
                end
            end)
        end
    end)
end

if (SERVER) then
    util.AddNetworkString('ixPlayAmbient')
    function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)
        net.Start('ixPlayAmbient')
        net.Send(client)
    end
end