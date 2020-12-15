local plugin = PLUGIN

local bullet_damages = {
    [DMG_BULLET]    = true,
    [DMG_SLASH]     = true,
    [DMG_BLAST]     = true,
    [DMG_AIRBOAT]   = true,
    [DMG_BUCKSHOT]  = true,
    [DMG_SNIPER]    = true,
    [DMG_MISSILEDEFENSE] = true
}

function plugin:EntityTakeDamage(target, info)
    if ( IsValid(target) and target:IsPlayer() ) then
        if !target:GetCharacter() then return end
        if bullet_damages[info:GetDamageType()] then
            if math.random(10) > 7 then
                ix.Wounds:SetBleeding(target)
            end
        elseif info:GetDamageType() == DMG_FALL then
            if math.random(10) > 7 then
                ix.Wounds:SetFracture(target)
            end
        end
    end
end

function plugin:PostPlayerLoadout(pl)
    local char = pl:GetCharacter() or false

    if not char:IsFractured() then
        ix.Wounds:RemoveFracture(pl)
    end

    if not char:IsBleeding() then
        ix.Wounds:RemoveBleeding(pl)
    end

    if char:IsFractured() then
        ix.Wounds:SetFracture(pl)
    end

    if char:IsBleeding() then
        ix.Wounds:SetBleeding(pl)
    end
end

function ix.Wounds:SetBleeding(pl)
    local char = pl:GetCharacter() or false
    if IsValid(pl) and char then
        char:SetData("bIsBleeding", true)

        pl:_SetTimer("bIsBleeding::"..pl:SteamID64(), 7, 0, function()
            pl:SetHealth(pl:Health() - math.random(1,3))
            pl:EmitSound("player/pl_drown2.wav")
            pl:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 128), 0.3, 0 )

            if pl:Health() <= 0 then
                pl:Kill()
                ix.Wounds:RemoveAllWounds(pl)
            end
        end)
    end
end

function ix.Wounds:SetFracture(pl)
    local char = pl:GetCharacter() or false
    if IsValid(pl) and char then
        char:SetData("bIsFractured", true)

        pl:SetWalkSpeed(ix.config.Get("walkSpeed", 100) / 1.4)
        pl:SetRunSpeed(ix.config.Get("walkSpeed", 100) / 1.4)
    end
end

function ix.Wounds:RemoveBleeding(pl)
    local char = pl:GetCharacter() or false
    if IsValid(pl) and char then
        char:SetData("bIsBleeding", false)
        if pl:_TimerExists("bIsBleeding::"..pl:SteamID64()) then
            pl:_RemoveTimer("bIsBleeding::"..pl:SteamID64())
        end
    end
end

function ix.Wounds:RemoveFracture(pl)
    local char = pl:GetCharacter() or false
    if IsValid(pl) and char then
        char:SetData("bIsFractured", false)

        pl:SetWalkSpeed(ix.config.Get("walkSpeed", 100))
        pl:SetRunSpeed(ix.config.Get("runSpeed", 100))
    end
end

function ix.Wounds:RemoveAllWounds(pl)
    if IsValid(pl) and pl:IsPlayer() then
        local char = pl:GetCharacter()

        if char then
            char:SetData("bIsBleeding", false)
            char:SetData("bIsFractured", false)
        end

        if pl:_TimerExists("bIsBleeding::"..pl:SteamID64()) then
            pl:_RemoveTimer("bIsBleeding::"..pl:SteamID64())
        end
    end
end

function plugin:DoPlayerDeath(pl, _, __)
    ix.Wounds:RemoveAllWounds(pl)
end