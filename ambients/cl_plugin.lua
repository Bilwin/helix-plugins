local PLUGIN = PLUGIN
local m_iFadeTime = 1
local m_iDefaultVolume = 1

ix.lang.AddTable('english', {
    optAmbientPlaylists = 'Playlist',
    optAmbientVolume = 'Volume',
    optdAmbientPlaylists = 'Selected playlist for playing ambient music',
    optdAmbientVolume = 'Ambient music volume',
    ambients = 'Ambient music',

    optSpawnMusic = 'Music when spawning',
    optdSpawnMusic = 'Music when character appears'
})

ix.lang.AddTable('russian', {
    optAmbientPlaylists = 'Плейлист',
    optAmbientVolume = 'Громкость',
    optdAmbientPlaylists = 'Выбранный плейлист для проигрывания фоновой музыки',
    optdAmbientVolume = 'Громкость фоновой музыки',
    ambients = 'Фоновая музыка',

    optSpawnMusic = 'Музыка при появлении',
    optdSpawnMusic = 'Музыка при появлении персонажа'
})

ix.option.Add('ambientPlaylists', ix.type.array, PLUGIN.defaultAmbientList, {
    category = PLUGIN.name,
    populate = function()
        local entries = {}

        for _, ambient in ipairs(PLUGIN.ambientsList) do
            entries[ambient.name] = ambient.name
        end

        return entries
    end,
    OnChanged = function(_, value)
        PLUGIN:PlayAmbient()
    end
})

ix.option.Add('spawnMusic', ix.type.array, PLUGIN.defaultSpawnAmbient, {
    category = PLUGIN.name,
    populate = function()
        local entries = {}

        for _, ambient in ipairs(PLUGIN.spawnLists) do
            entries[ambient.name] = ambient.name
        end

        return entries
    end
})

ix.option.Add('ambientVolume', ix.type.number, 0.5, {
    category = PLUGIN.name,
    min = 0,
    max = 1,
    decimals = 1,
    OnChanged = function(oldValue, value)
        if PLUGIN.ambientTrack && ix.config.Get('enableAmbients', true) then
            PLUGIN.ambientTrack:ChangeVolume(value, m_iFadeTime)
        end
    end
})

net.Receive('ixEnableAmbients', function(_, client)
    local enableAmbient = net.ReadBool()
    if enableAmbient then
        PLUGIN:PlayAmbient(true)
    else
        if not PLUGIN.ambientTrack then return end
        PLUGIN.ambientTrack:FadeOut(m_iFadeTime)
    end
end)

local m_strLastAmbient
function PLUGIN:PlayAmbient(bSpawnMusic)
    if not ix.config.Get('enableAmbients', true) then return end

    local m_arrNewAmbient = {name = ''}
    while m_arrNewAmbient.name ~= (bSpawnMusic && ix.option.Get('spawnMusic', self.defaultSpawnAmbient) || ix.option.Get('ambientPlaylists', self.defaultAmbientList)) do
        m_arrNewAmbient = bSpawnMusic && self.spawnLists[math.random(#self.spawnLists)] || self.ambientsList[math.random(#self.ambientsList)]
    end

    local m_strNewAmbient
    local m_iNewAmbientLength

    if bSpawnMusic then
        m_strNewAmbient = m_arrNewAmbient.ost[LocalPlayer():Team()]
        if not m_strNewAmbient then return end
        m_iNewAmbientLength = m_strNewAmbient[2]
        m_strNewAmbient = m_strNewAmbient[1]
    else
        m_strNewAmbient = m_arrNewAmbient.ost[math.random(#m_arrNewAmbient.ost)]
        m_iNewAmbientLength = m_strNewAmbient[2]
        m_strNewAmbient = m_strNewAmbient[1]
    end

    if not bSpawnMusic && m_strNewAmbient == m_strLastAmbient && #m_arrNewAmbient.ost > 1 then
        self:PlayAmbient()
        return
    end

    if self.ambientTrack then
        self.ambientTrack:FadeOut(m_iFadeTime)
    end

    self.ambientTrack = CreateSound(game.GetWorld(), m_strNewAmbient)
        if not self.ambientTrack then
            print(('Error playing \'%s\' ambient, retrying...'):format(m_strNewAmbient))
            self:PlayAmbient()
            return
        end

        self.ambientTrack:SetSoundLevel(0)
        self.ambientTrack:Play()
        self.ambientTrack:ChangeVolume(0)
        self.ambientTrack:SetDSP(0)
    self.ambientTrack:ChangeVolume(ix.option.Get('ambientVolume', 0.5), m_iFadeTime)
    print(('Playing %s'):format(m_strNewAmbient))

    timer.Create('ixPlayAmbientCooldown', m_iNewAmbientLength - m_iFadeTime, 1, function()
        if not PLUGIN.ambientTrack then return end
        self.ambientTrack:FadeOut(m_iFadeTime)
        self:PlayAmbient()
    end)

    m_strLastAmbient = m_strNewAmbient
end