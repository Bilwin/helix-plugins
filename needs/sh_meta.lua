
local CHAR = ix.meta.character

function CHAR:GetThirst()
    return self:GetData( "ixSaturation", 0 ) or 0
end

function CHAR:GetHunger()
    return self:GetData( "ixSatiety", 0 ) or 0
end
