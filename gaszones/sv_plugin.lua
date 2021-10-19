
local PLUGIN = PLUGIN
PLUGIN.maleCoughSounds = {
    [1] = 'ambient/voices/cough1.wav',
    [2] = 'ambient/voices/cough2.wav',
    [3] = 'ambient/voices/cough3.wav',
    [4] = 'ambient/voices/cough4.wav'
}

PLUGIN.chockSounds = {
    [1] = 'ambient/voices/citizen_beaten3.wav',
    [2] = 'ambient/voices/citizen_beaten4.wav'
}

function PLUGIN:PlayerLoadedCharacter(client, character)
    if timer.Exists('GasAntidote.'..client:AccountID()) then timer.Remove("GasAntidote."..client:AccountID()) end
    self:CreateGasTimer(client, character)
    self:OnVarChanged(client, character)
end

function PLUGIN:CreateGasTimer(client, character)
    if !IsValid(client) and !character then return end
    local uniqueID = client:AccountID()
    local thinkDelay = ix.config.Get("gasTickTime", 5)
    if timer.Exists("GasTick."..uniqueID) then timer.Remove("GasTick."..uniqueID) end
    timer.Create("GasTick."..uniqueID, thinkDelay, 0, function()
        if !IsValid(client) then return end
        if !character then return end
        if hook.Run("ShouldCharacterPoisoned", client, character) == false then return end
        if client:GetMoveType() == MOVETYPE_NOCLIP then return end

        local inGasArea,_ = client:InGasArea()
        if (inGasArea) then
            if character:WearingGasmask() then return end
            if timer.Exists('GasCoughTimer.'..uniqueID) then
                timer.Pause('GasCoughTimer.'..uniqueID)
            end

            if timer.Exists('GasAntidote.'..uniqueID) then
                timer.Remove("GasAntidote."..uniqueID)
            end

            if client:IsFemale() then
                client:EmitSound("ambient/voices/cough3.wav")
            else
                local randomCough = self.maleCoughSounds[math.random(#self.maleCoughSounds)]
                client:EmitSound(randomCough)
            end

            character:AddToxicity(math.random(5))
        else
            if timer.Exists('GasCoughTimer.'..uniqueID) then
                timer.UnPause('GasCoughTimer.'..uniqueID)
            end
        end
    end)
end

function PLUGIN:CharacterVarChanged(character, key, oldVar, value)
    if (character and key == 'toxicity') then
        self:OnVarChanged(character:GetPlayer(), character, value)
    end
end

function PLUGIN:OnVarChanged(client, character, value)
    if !value then value = character:GetToxicity() end
    local uniqueID = client:AccountID()

    if (value <= 20) then
        if timer.Exists("GasKillCD."..uniqueID) then timer.Remove("GasKillCD."..uniqueID) end
        if timer.Exists("GasCoughTimer."..uniqueID) then timer.Remove("GasCoughTimer."..uniqueID) end
    elseif (value <= 30) then
        self:CreateCoughTimer(client, character)
        if timer.Exists("GasKillCD."..uniqueID) then timer.Remove("GasKillCD."..uniqueID) end
    elseif (value <= 50) then
        self:DeathTimerCountdown(client, character)
    elseif (value <= 65) then
        self:DeathTimerCountdown(client, character)
    elseif (value <= 80) then
        self:DeathTimerCountdown(client, character)
    elseif (value <= 100) then
        if timer.Exists("GasKillCD."..uniqueID) then timer.Remove("GasKillCD."..uniqueID) end
        if client:GetLocalVar("gasChocked") then return end
        self:ChockCharacter(client, character)
    end
end

function PLUGIN:ChockCharacter(client, character)
    if !IsValid(client) and !character then return end
    local randomBeaten = self.chockSounds[math.random(#self.chockSounds)]
    client:SetLocalVar("gasChocked", true)
    client:EmitSound(randomBeaten)
    client:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0), 5, 5 )
    client:SetRagdolled(true)
    client:SetSimpleTimer(10, function()
        client:Kill()
        client:SetLocalVar("gasChocked", false)
    end)
end

function PLUGIN:DeathTimerCountdown(client, character)
    if !IsValid(client) and !character then return end
    local uniqueID = client:AccountID()
    local thinkDelay = ix.config.Get("gasKillDelay", 5)
    if timer.Exists("GasKillCD."..uniqueID) then timer.Remove("GasKillCD."..uniqueID) end
    timer.Create("GasKillCD."..uniqueID, thinkDelay, 0, function()
        if !IsValid(client) and !character then return end
        local randomCough = self.maleCoughSounds[math.random(#self.maleCoughSounds)]
        local inGasArea,_ = client:InGasArea()
        if (!inGasArea and client:GetMoveType() ~= MOVETYPE_NOCLIP) then
            if client:IsFemale() then
                client:EmitSound("ambient/voices/cough3.wav")
            else
                client:EmitSound(randomCough)
            end
        end

        client:SetHealth(client:Health() - 1)
        if (client:Health() <= 10) then
            self:ChockCharacter(client, character)
        end
    end)
end

function PLUGIN:CreateCoughTimer(client, character)
    if !IsValid(client) and !character then return end
    local uniqueID = client:AccountID()
    if timer.Exists("GasCoughTimer."..uniqueID) then timer.Remove("GasCoughTimer."..uniqueID) end
    timer.Create("GasCoughTimer."..uniqueID, 10, 0, function()
        if !IsValid(client) and !character then return end
        if timer.Exists("GasKillCD."..uniqueID) then return end
        local randomCough = self.maleCoughSounds[math.random(#self.maleCoughSounds)]
        if client:GetMoveType() == MOVETYPE_NOCLIP then return end
        if client:IsFemale() then
            client:EmitSound("ambient/voices/cough3.wav")
        else
            client:EmitSound(randomCough)
        end
    end)
end

function PLUGIN:DoPlayerDeath(client)
    local character = client:GetCharacter()
    if ( IsValid(client) and character ) then
        local defaultToxicity = ix.char.vars["toxicity"].default or 0
        character:SetToxicity(defaulttoxicity)
    end
end

function PLUGIN:PlayerDisconnected(client)
    local uniqueID = client:AccountID()
    if timer.Exists('GasTick.'..uniqueID) then
        timer.Remove('GasTick.'..uniqueID)
    end
end