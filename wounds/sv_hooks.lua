local PLUGIN = PLUGIN

function PLUGIN:EntityTakeDamage(target, info)
    if target:IsPlayer() then
        if info:IsBulletDamage() then
            if math.random(10) > 7 then -- 30% chance
                self:SetBleeding(target, true)
            end
        elseif info:GetDamageType() == DMG_FALL then
            self:SetFractured(target, true)
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    if not character:GetFractured() then
        self:SetFractured(client, false)
    else
        self:SetFractured(client, true)
    end

    if not character:GetBleeding() then
        self:SetBleeding(client, false)
    else
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
                end
            end
        end)
    else
        if timer.Exists("bleeding."..client:AccountID()) then
            timer.Remove("bleeding."..client:AccountID())
        end
    end
end

function PLUGIN:SetFractured(client, status)
    local character = client:GetCharacter()
    local bStatus = hook.Run("CanCharacterGetFracture", client, character)
    if (bStatus) then return end
    if !character then return end

    character:SetFractured(status)
    if (status) then
        client:SetWalkSpeed(ix.config.Get("walkSpeed", 100) / 1.4)
        client:SetRunSpeed(ix.config.Get("walkSpeed", 100) / 1.4)
    else
        client:SetWalkSpeed(ix.config.Get("walkSpeed"))
        client:SetRunSpeed(ix.config.Get("runSpeed"))
    end
end

function PLUGIN:ClearWounds(client)
    self:SetFractured(client, false)
    self:SetBleeding(client, false)
end

function PLUGIN:DoPlayerDeath(client)
    self:ClearWounds(client)
end
