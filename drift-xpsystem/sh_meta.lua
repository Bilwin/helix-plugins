local plugin = PLUGIN

local CHAR = ix.meta.character

function CHAR:GetXP()
    return self:GetData("ix:XP", 0)
end