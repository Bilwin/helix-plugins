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
                target:GetCharacter():SetData("bIsBleeding", true)
            end
        elseif info:GetDamageType() == DMG_FALL then
            if math.random(10) > 7 then
                target:GetCharacter():SetData("bIsFractured", true)
            end
        end
    end
end

local bad_movetypes = {
    [MOVETYPE_NOCLIP] = true,
    [MOVETYPE_OBSERVER] = true
}
local damage_color = Color(255, 0, 0, 128)
local ix_config = ix.config.Get

function plugin:PlayerPostThink(pl)
    if !pl:GetCharacter() then return end
    if !pl:Alive() then return end
    if bad_movetypes[pl:GetMoveType()] then return end

    local _health = pl:Health()

    if pl:GetCharacter():GetData("bIsBleeding") then
        if (pl.bIsBleeding or 0) < CurTime() then
            pl:SetHealth(_health - math.random(1,3))
            pl:EmitSound("player/pl_drown2.wav")
            pl:ScreenFade(SCREENFADE.IN, damage_color, 0.3, 0 )

            if _health <= 0 then
                pl:Kill()
            end

            pl.bIsBleeding = CurTime() + 7
        end
    elseif pl:GetCharacter():GetData("bIsFractured") then
        pl:SetWalkSpeed(ix_config("walkSpeed", 100) / 1.4)
        pl:SetRunSpeed(ix_config("walkSpeed", 100) / 1.4)
    else
        if !pl:GetCharacter():GetData("bIsFractured") then
            pl:SetWalkSpeed(ix_config("walkSpeed", 100))
            pl:SetRunSpeed(ix_config("runSpeed", 200))
        elseif !pl:GetCharacter():GetData("bIsBleeding") then
            pl.bIsBleeding = nil
        end
    end
end

function plugin:DoPlayerDeath(pl, attacker, dmg)
    if !pl:GetCharacter() then return end
    if pl:GetCharacter():GetData("bIsBleeding") then
        pl:GetCharacter():SetData("bIsBleeding", false)
    elseif pl:GetCharacter():GetData("bIsFractured") then
        pl:GetCharacter():SetData("bIsFractured", false)
    end
end

function plugin:PlayerDisconnected(pl)
    if !pl:GetCharacter() then return end
    if pl:GetCharacter():GetData("bIsBleeding") and IsValid(pl) then
        if (pl.bIsBleeding or 0) then
            pl.bIsBleeding = nil
        end
    end
end