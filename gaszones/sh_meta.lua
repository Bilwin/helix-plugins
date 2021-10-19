
local CHAR = ix.meta.character
local META = FindMetaTable("Player")

function CHAR:InGasArea()
    local player = self:GetPlayer()
    local currentArea = player:GetArea() or nil
    if (currentArea) then
        local stored = ix.area.stored[player:GetArea()] or nil
        if (stored and player:GetMoveType() ~= MOVETYPE_NOCLIP) then
            local clientPos = player:GetPos() + player:OBBCenter()
            return stored.type == 'gas' and clientPos:WithinAABox(stored.startPosition, stored.endPosition), stored
        end
    else
        return false
    end
end

function META:InGasArea()
    local character = self:GetCharacter()
    if (character) then
        return character:InGasArea()
    else
        return false
    end
end

function CHAR:GetRoundedToxicity()
    local toxicity = self:GetToxicity()
    local rounded = math.Clamp(toxicity, 0, 100)
    return rounded
end

function CHAR:WearingGasmask()
    local inventory = self:GetInventory()
    local bStatus = false
    local isImmuneFaction = ix.faction.indices[self:GetFaction()].immuneGas or false

    if (isImmuneFaction) then
        bStatus = true
    else
        for _, item in pairs( inventory:GetItems() ) do
            if (item:GetData("equip") == true and item.gasMask) then
                bStatus = true
            end
        end
    end

    return bStatus
end

if (SERVER) then
    function CHAR:AddToxicity(value)
        local toxicity = self:GetToxicity()
        local rounded = math.Clamp(toxicity + value, 0, 100)
        self:SetToxicity(rounded)
    end

    function CHAR:SubtractToxicity(value)
        local toxicity = self:GetToxicity()
        local rounded = math.Clamp(toxicity - value, 0, 100)
        self:SetToxicity(rounded)
    end
end