
local PLUGIN = PLUGIN

function PLUGIN:CharacterVarChanged(character, key, oldValue, value)
    local client = character:GetPlayer()
    if (client and IsValid(client)) then
        if (key == "saturation") then
            client:SetLocalVar("saturation", value)
        end

        if (key == "satiety") then
            client:SetLocalVar("satiety", value)
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character, _)
    if !IsValid(client) and !client:IsPlayer() and !character then return end
    if (character:GetSaturation()) then
        local clampedSaturation = math.Round(math.Clamp(character:GetSaturation(), 0, 100))
        client:SetLocalVar("saturation", clampedSaturation)
    end
    if (character:GetSatiety()) then
        local clampedSatiety = math.Round(math.Clamp(character:GetSatiety(), 0, 100))
        client:SetLocalVar("satiety", clampedSatiety)
    end

    local uniqueID = client:AccountID()
    if timer.Exists("ixPrimaryNeeds." .. uniqueID) then timer.Remove("ixPrimaryNeeds." .. uniqueID) end
    if ( hook.Run("EnableNeedsForCharacter", client, character) == false ) then return end
    self:CreateNeedsTimer(client, character)
end

PLUGIN.hungerSounds = {
    [1] = 'npc/barnacle/barnacle_digesting1.wav',
    [2] = 'npc/barnacle/barnacle_digesting2.wav'
}

function PLUGIN:CreateNeedsTimer(client, character)
    local uniqueID = client:AccountID()
    local needsDelay = ix.config.Get("primaryNeedsDelay", 120)
    timer.Create("ixPrimaryNeeds." .. uniqueID, needsDelay, 0, function()
        if !IsValid(client) then return end
        if !character then return end
        if ( hook.Run("EnableNeedsForCharacter", client, character) == false ) then return end

        local filledSlots = math.Round( character:GetInventory():GetFilledSlotCount() / 2 )
        local velocity = client:GetVelocity():LengthSqr()
        local saturationConsume = ix.config.Get("saturationConsume", 3) + filledSlots
        local satietyConsume = ix.config.Get("satietyConsume", 2) + filledSlots
        if (velocity > 0) then
            saturationConsume = math.Round(saturationConsume * 1.5)
            satietyConsume = math.Round(satietyConsume * 1.5)
        end

        if (character:GetSatiety() <= 10) then
            client:EmitSound( self.hungerSounds[math.random(#self.hungerSounds)] )
        end

        if (character:GetSatiety() <= 0 and character:GetSaturation() <= 0) then
            client:SetHealth( client:Health() - 2 )
        end

        character:DowngradeSaturation(saturationConsume)
        character:DowngradeSatiety(satietyConsume)
    end)
end

function PLUGIN:EnableNeedsForCharacter(client, character)
    local bStatus = false
    local factionTable = ix.faction.indices[character:GetFaction()] or {}

    if (factionTable and factionTable.includeNeeds) then
        bStatus = true
    end

    return bStatus
end

function PLUGIN:DoPlayerDeath(client, _, __)
    local char = client:GetCharacter()
    if ( IsValid(client) and char ) then
        local defaultSaturation = ix.char.vars["saturation"].default or 60
        local defaultSatiety = ix.char.vars["satiety"].default or 60
        char:SetSaturation(defaultSaturation)
        char:SetSatiety(defaultSatiety)
    end
end

function PLUGIN:PlayerDisconnected(client)
    local uniqueID = client:AccountID()
    if timer.Exists("ixPrimaryNeeds." .. uniqueID) then
        timer.Remove("ixPrimaryNeeds." .. uniqueID)
    end
end
