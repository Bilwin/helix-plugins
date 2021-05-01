
local PLUGIN = PLUGIN

PLUGIN.BulletDamages = {
    [DMG_BULLET]    = true,
    [DMG_SLASH]     = true,
    [DMG_BLAST]     = true,
    [DMG_AIRBOAT]   = true,
    [DMG_BUCKSHOT]  = true,
    [DMG_SNIPER]    = true,
    [DMG_MISSILEDEFENSE] = true
}

function PLUGIN:EntityTakeDamage(target, info)
    if ( target:IsValid() and target:IsPlayer() ) then
        if ( self.BulletDamages[info:GetDamageType()] ) then
            if ( math.random(10) > 7 ) then
                self:SetBleeding(target, true)
            end
        elseif ( info:GetDamageType() == DMG_FALL ) then
            if math.random(10) > 7 then
                self:SetFracture(target, true)
            end
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    if (!character:GetFracture()) then
        self:SetFracture(client, false)
    end

    if (!character:GetBleeding()) then
        self:SetBleeding(client, false)
    end

    if (character:GetFracture()) then
        self:SetFracture(client, true)
    end

    if (character:GetBleeding()) then
        self:SetBleeding(client, true)
    end
end

function PLUGIN:SetBleeding(client, status)
    local character = client:GetCharacter()
    local bStatus = hook.Run("CanCharacterGetBleeding", client, character)
    if (bStatus) then return end

    character:SetBleeding(status)
    if (status) then
        timer.Create("bleeding."..client:AccountID(), 7, 0, function()
            if IsValid(client) and character then
                client:SetHealth( client:Health() - math.random(3) )
                client:ScreenFade( SCREENFADE.IN, Color(255, 0, 0, 128), 0.3, 0 )

                if (client:Health() <= 0) then
                    client:Kill()
                    self:ClearWounds(client)
                end
            end
        end)
    else
        if timer.Exists("bleeding."..client:AccountID()) then
            timer.Remove("bleeding."..client:AccountID())
        end
    end
end

function PLUGIN:SetFracture(client, status)
    local character = client:GetCharacter()
    local bStatus = hook.Run("CanCharacterGetFracture", client, character)
    if (bStatus) then return end

    character:SetFracture(status)
    if (status) then
        client:SetWalkSpeed(ix.config.Get("walkSpeed", 100) / 1.4)
        client:SetRunSpeed(ix.config.Get("walkSpeed", 100) / 1.4)
    else
        client:SetWalkSpeed(ix.config.Get("walkSpeed"))
        client:SetRunSpeed(ix.config.Get("runSpeed"))
    end
end

function PLUGIN:ClearWounds(client)
    self:SetFracture(client, false)
    self:SetBleeding(client, false)
end

function PLUGIN:DoPlayerDeath(client)
    self:ClearWounds(client)
end