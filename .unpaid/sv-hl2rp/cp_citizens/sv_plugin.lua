
local PLUGIN = PLUGIN
local Schema = Schema

ix.log.AddType("loyalEvent", function(client, name, loyal)
    return string.format("%s поменял лояльность '%s' на '%s'", client:Name(), name, loyal)
end)

local meta = ix.meta.character
function meta:AddLoyalPoints(amount)
    if !isnumber(amount) then return end
    self:SetLoyalPoints(self:GetLoyalPoints() + amount)
    hook.Run("OnLPChanged", self, self:GetLoyalPoints(), 'add', amount)
end

function meta:TakeLoyalPoints(amount)
    if !isnumber(amount) then return end
    amount = math.abs(amount)
    local calculated = self:GetLoyalPoints() - amount
    calculated = math.Clamp(calculated, -1000, 5500)
    self:SetLoyalPoints(calculated)
    hook.Run("OnLPChanged", self, self:GetLoyalPoints(), 'take', calculated)
end

function PLUGIN:OnCPChangedCitizenLP(client, target, amount, reason, stripped)
end