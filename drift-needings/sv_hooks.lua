
function PLUGIN:PostPlayerLoadout( pl )
    if !IsValid( pl ) and !pl:IsPlayer() then return end
    local char = pl:GetCharacter() or false
    local _enabled = ix.config.Get( "needsEnabled", true ) or true
    if not _enabled then return end

    if char then
        if pl:_TimerExists( "ixSaturation::" .. pl:SteamID64() ) then
            pl:_RemoveTimer( "ixSaturation::" .. pl:SteamID64() )
        end

        if pl:_TimerExists( "ixSatiety::" .. pl:SteamID64() ) then
            pl:_RemoveTimer( "ixSatiety::" .. pl:SteamID64() )
        end

        if !char:GetData( "ixSaturation" ) then
            ix.Hunger:InitThirst( pl )
        end

        if !char:GetData( "ixSatiety" ) then
            ix.Hunger:InitHunger( pl )
        end

        local notBEnaled = hook.Run( "CanPlayerHunger", pl ) == false

        if notBEnaled then
            ix.Hunger:AbortThirst(pl)
            ix.Hunger:AbortHunger(pl)
            goto init
        end

        pl:_SetTimer( "ixSaturation::" .. pl:SteamID64(), 60 * 8, 0, function()
            local _damage = ix.config.Get( "needsDamage", 2 ) or 2
            local _killing = ix.config.Get( "starvingKilling", true ) or true

            local downgrade = ix.config.Get( "thirstDowngrade", 3 ) or 3
            ix.Hunger:DowngradeSaturation( pl, tonumber( downgrade ) )

            if char:GetThirst() <= 0 and _killing then
                ix.util.Notify("Wouldn't hurt to drink something", pl)
                pl:SetHealth( math.Clamp( pl:Health() - tonumber( _damage ), 10, pl:GetMaxHealth() ) )
            end
        end )

        pl:_SetTimer( "ixSatiety::" .. pl:SteamID64(), 60 * 10, 0, function()
            local _damage = ix.config.Get( "needsDamage", 2 ) or 2
            local _killing = ix.config.Get( "starvingKilling", true ) or true

            local downgrade = ix.config.Get( "hungerDowngrade", 2 ) or 2
            ix.Hunger:DowngradeSatiety( pl, tonumber( downgrade ) )

            if char:GetHunger() <= 0 then
                pl:EmitSound("npc/barnacle/barnacle_digesting2.wav", 45, 100)

                if _killing then
                    ix.util.Notify("Wouldn't hurt to eat something", pl)
                    pl:SetHealth( math.Clamp( pl:Health() - tonumber( _damage ), 10, pl:GetMaxHealth() ) )
                end
            end
        end )

        ::init::
        hook.Run("PlayerHungerInit", pl)
    end
end

function ix.Hunger:InitThirst( pl )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSaturation", 60 )
        end
    end
end

function ix.Hunger:InitHunger( pl )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSatiety", 60 )
        end
    end
end

function ix.Hunger:AbortThirst(pl)
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSaturation", 0 )
        end
    end
end

function ix.Hunger:AbortHunger(pl)
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSatiety", 0 )
        end
    end
end

function ix.Hunger:RestoreSatiety( pl, amount )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSatiety", math.Clamp(char:GetData("ixSatiety", 0) + amount, 0, 100) )
        end
    end
end

function ix.Hunger:RestoreSaturation( pl, amount )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSaturation", math.Clamp(char:GetData("ixSaturation", 0) + amount, 0, 100) )
        end
    end
end

function ix.Hunger:DowngradeSatiety( pl, amount )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSatiety", math.Clamp(char:GetData("ixSatiety", 0) - amount, 0, 100) )
        end
    end
end

function ix.Hunger:DowngradeSaturation( pl, amount )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSaturation", math.Clamp(char:GetData("ixSaturation", 0) - amount, 0, 100) )
        end
    end
end

function ix.Hunger:SetSatiety( pl, amount )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSatiety", math.Clamp(amount, 0, 100) )
        end
    end
end

function ix.Hunger:SetSaturation( pl, amount )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSaturation", math.Clamp(amount, 0, 100) )
        end
    end
end

function ix.Hunger:SetCharSatiety( char, amount )
    char:SetData( "ixSatiety", math.Clamp(amount, 0, 100) )
end

function ix.Hunger:SetCharSaturation( char, amount )
    char:SetData( "ixSaturation", math.Clamp(amount, 0, 100) )
end

function PLUGIN:DoPlayerDeath(pl, _, __)
    if IsValid( pl ) then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSatiety", 60 )
            char:SetData( "ixSaturation", 60 )
        end
    end
end

util.AddNetworkString( 'EnableHungerBars' )
function PLUGIN:PlayerLoadedCharacter( pl, _, __ )
    if pl.BarsUpdated == nil then
        net.Start( 'EnableHungerBars' )
        net.Send( pl )

        pl.BarsUpdated = true
    end
end