
local playerMeta = FindMetaTable("Player")

function playerMeta:GetSaturation()
    local char = self:GetCharacter()
    return self:GetLocalVar("saturation"), (char and char:GetSaturation())
end

function playerMeta:GetSatiety()
    local char = self:GetCharacter()
    return self:GetLocalVar("satiety"), (char and char:GetSatiety())
end

if (SERVER) then
    local CHAR = ix.meta.character

    function CHAR:DowngradeSatiety(value)
        local calculated = math.Round(math.Clamp(self:GetSatiety() - value, 0, 100))
        self:SetSatiety(calculated)
    end

    function CHAR:DowngradeSaturation(value)
        local calculated = math.Round(math.Clamp(self:GetSaturation() - value, 0, 100))
        self:SetSaturation(calculated)
    end

    function CHAR:RestoreSatiety(value)
        local calculated = math.Round(math.Clamp(self:GetSatiety() + value, 0, 100))
        self:SetSatiety(calculated)
    end

    function CHAR:RestoreSaturation(value)
        local calculated = math.Round(math.Clamp(self:GetSaturation() + value, 0, 100))
        self:SetSaturation(calculated)
    end
end
