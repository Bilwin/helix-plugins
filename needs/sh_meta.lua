
local playerMeta = FindMetaTable("Player")

function playerMeta:GetSaturation()
    local char = self:GetCharacter()
    return self:GetLocalVar("saturation"), char and char:GetSaturation()
end

function playerMeta:GetSatiety()
    local char = self:GetCharacter()
    return self:GetLocalVar("satiety"), char and char:GetSatiety()
end

if (SERVER) then
    local CHAR = ix.meta.character

    function CHAR:DowngradeSatiety(value)
        local client = self:GetPlayer()
        if (self and IsValid(client)) then
            local clamped = math.Round(math.Clamp(self:GetSatiety() - value, 0, 100))
            client:SetLocalVar("satiety", clamped)
            self:SetSatiety(clamped)
        end
    end

    function CHAR:DowngradeSaturation(value)
        local client = self:GetPlayer()
        if (self and IsValid(client)) then
            local clamped = math.Round(math.Clamp(self:GetSaturation() - value, 0, 100))
            client:SetLocalVar("saturation", clamped)
            self:SetSaturation(clamped)
        end
    end

    function CHAR:RestoreSatiety(value)
        local client = self:GetPlayer()
        if (self and IsValid(client)) then
            local clamped = math.Round(math.Clamp(self:GetSatiety() + value, 0, 100))
            client:SetLocalVar("satiety", clamped)
            self:SetSatiety(clamped)
        end
    end

    function CHAR:RestoreSaturation(value)
        local client = self:GetPlayer()
        if (self and IsValid(client)) then
            local clamped = math.Round(math.Clamp(self:GetSaturation() + value, 0, 100))
            client:SetLocalVar("saturation", clamped)
            self:SetSaturation(clamped)
        end
    end
end
