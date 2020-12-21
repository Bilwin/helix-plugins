
function PLUGIN:PostPlayerLoadout( pl )
    if !IsValid(pl) and !pl:IsPlayer() then return end
    local char = pl:GetCharacter() or false

    if char then
        if pl:_TimerExists( "ixSaturation::"..pl:SteamID64() ) then
            pl:_RemoveTimer( "ixSaturation::"..pl:SteamID64() )
        end

        if pl:_TimerExists( "ixSatiety::"..pl:SteamID64() ) then
            pl:_RemoveTimer( "ixSatiety::"..pl:SteamID64() )
        end

        if !char:GetData("ixSaturation") then
            ix.Hunger:InitThirst( pl )
        end

        if !char:GetData("ixSatiety") then
            ix.Hunger:InitHunger( pl )
        end

        pl:_SetTimer( "ixSaturation::" .. pl:SteamID64(), 60 * 2, 0, function()
            ix.Hunger:DowngradeSaturation( pl, 2 )

            if char:GetThirst() <= 0 then
                pl:SetHealth( math.Clamp( pl:Health() - 2, 10, pl:GetMaxHealth() ) )
            end
        end )

        pl:_SetTimer( "ixSatiety::" .. pl:SteamID64(), 60 * 2, 0, function()
            ix.Hunger:DowngradeSatiety( pl, 3 )

            if char:GetHunger() <= 0 then
                pl:SetHealth( math.Clamp( pl:Health() - 2, 10, pl:GetMaxHealth() ) )
            end
        end )
    end
end

function ix.Hunger:InitThirst( pl )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSaturation", pl:IsDonator() and 100 or 60 )
        end
    end
end

function ix.Hunger:InitHunger( pl )
    if IsValid( pl ) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            char:SetData( "ixSatiety", pl:IsDonator() and 100 or 60 )
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