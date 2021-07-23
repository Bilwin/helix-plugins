
local PLUGIN = PLUGIN
local CHAR = ix.meta.character

function CHAR:DecreaseHeadHealthy(amount)
    local source = self:GetHeadHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['headHealthy'])
    self:SetHeadHealthy(clamped)
end

function CHAR:DecreaseLeftArmHealthy(amount)
    local source = self:GetLeftArmHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['leftArmHealthy'])
    self:SetLeftArmHealthy(clamped)
end

function CHAR:DecreaseRightArmHealthy(amount)
    local source = self:GetRightArmHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['rightArmHealthy'])
    self:SetRightArmHealthy(clamped)
end

function CHAR:DecreaseGearHealthy(amount)
    local source = self:GetGearHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['gearHealthy'])
    self:SetGearHealthy(clamped)
end

function CHAR:DecreaseChestHealthy(amount)
    local source = self:GetChestHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['chestHealthy'])
    self:SetChestHealthy(clamped)
end

function CHAR:DecreaseStomachHealthy(amount)
    local source = self:GetStomachHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['stomachHealthy'])
    self:SetStomachHealthy(clamped)
end

function CHAR:DecreaseLeftLegHealthy(amount)
    local source = self:GetLeftLegHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['leftLegHealthy'])
    self:SetLeftLegHealthy(clamped)
end

function CHAR:DecreaseRightLegHealthy(amount)
    local source = self:GetRightLegHealthy()
    local clamped = math.Clamp(source - amount, 0, PLUGIN.defaultLimbsData['rightLegHealthy'])
    self:SetRightLegHealthy(clamped)
end

function CHAR:IncreaseHeadHealthy(amount)
    local source = self:GetHeadHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['headHealthy'])
    self:SetHeadHealthy(clamped)
end

function CHAR:IncreaseLeftArmHealthy(amount)
    local source = self:GetLeftArmHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['leftArmHealthy'])
    self:SetLeftArmHealthy(clamped)
end

function CHAR:IncreaseRightArmHealthy(amount)
    local source = self:GetRightArmHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['rightArmHealthy'])
    self:SetRightArmHealthy(clamped)
end

function CHAR:IncreaseGearHealthy(amount)
    local source = self:GetGearHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['gearHealthy'])
    self:SetGearHealthy(clamped)
end

function CHAR:IncreaseChestHealthy(amount)
    local source = self:GetChestHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['chestHealthy'])
    self:SetChestHealthy(clamped)
end

function CHAR:IncreaseStomachHealthy(amount)
    local source = self:GetStomachHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['stomachHealthy'])
    self:SetStomachHealthy(clamped)
end

function CHAR:IncreaseLeftLegHealthy(amount)
    local source = self:GetLeftLegHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['leftLegHealthy'])
    self:SetLeftLegHealthy(clamped)
end

function CHAR:IncreaseRightLegHealthy(amount)
    local source = self:GetRightLegHealthy()
    local clamped = math.Clamp(source + amount, 0, PLUGIN.defaultLimbsData['rightLegHealthy'])
    self:SetRightLegHealthy(clamped)
end
