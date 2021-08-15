
local PLUGIN = PLUGIN
local CHAR = ix.meta.character

function CHAR:IsDiseased()
    return self:GetData("diseaseInfo", "") ~= "" or false
end

function CHAR:GetDisease()
    return self:GetData("diseaseInfo", "") or false
end
