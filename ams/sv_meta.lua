
local CHAR = ix.meta.character

-- DISEASES
function CHAR:AddDisease(uniqueID)
    if (ix.AMS.Diseases:FindByID(uniqueID)) then
        local diseaseTable = ix.AMS.Diseases:FindByID(uniqueID)
        if table.HasValue(diseaseTable.immuneFactions, self:GetFaction()) then return false end
        local storedDiseases = self:GetDiseases()

        if storedDiseases ~= '' then
            if storedDiseases:find(uniqueID) then return false end
            self:SetDiseases(storedDiseases .. ';' .. uniqueID)
        else
            self:SetDiseases(uniqueID)
        end

        local client = self:GetPlayer()
        diseaseTable.Infect(client, self)
        hook.Run('CharacterDiseased', self, diseaseTable)
        return true
    end
end

function CHAR:RemoveDisease(uniqueID)
    if (ix.AMS.Diseases:FindByID(uniqueID)) then
        local diseaseTable = ix.AMS.Diseases:FindByID(uniqueID)
        local storedDiseases = string.Split(self:GetDiseases(),';')

        if table.HasValue(storedDiseases, uniqueID) then
            table.RemoveByValue(storedDiseases, uniqueID)
            storedDiseases = table.concat(storedDiseases, ';')
        else
            return
        end

        self:SetDiseases(storedDiseases)
        local client = self:GetPlayer()
        diseaseTable.Disinfect(client, self)
        hook.Run('CharacterUndiseased', self, diseaseTable)
    end
end

function CHAR:RemoveAllDiseases()
    for id in next, ix.AMS.Diseases.stored do
        self:RemoveDisease(id)
    end
end

-- WOUNDS
function CHAR:AddWound(uniqueID)
    if (ix.AMS.Wounds:FindByID(uniqueID)) then
        local woundTable = ix.AMS.Wounds:FindByID(uniqueID)
        if table.HasValue(woundTable.immuneFactions, self:GetFaction()) then return false end
        local storedWounds = self:GetWounds()

        if storedWounds ~= '' then
            if storedWounds:find(uniqueID) then return false end
            self:SetWounds(storedWounds .. ';' .. uniqueID)
        else
            self:SetWounds(uniqueID)
        end

        local client = self:GetPlayer()
        woundTable.Wounded(client, self)
        hook.Run('CharacterWounded', self, woundTable)
        return true
    end
end

function CHAR:RemoveWound(uniqueID)
    if (ix.AMS.Wounds:FindByID(uniqueID)) then
        local woundTable = ix.AMS.Wounds:FindByID(uniqueID)
        local storedWounds = string.Split(self:GetWounds(),';')

        if table.HasValue(storedWounds, uniqueID) then
            table.RemoveByValue(storedWounds, uniqueID)
            storedWounds = table.concat(storedWounds, ';')
        else
            return
        end

        self:SetWounds(storedWounds)
        local client = self:GetPlayer()
        woundTable.Diswound(client, self)
        hook.Run('CharacterUnWounded', self, woundTable)
    end
end

function CHAR:RemoveAllWounds()
    for id in next, ix.AMS.Wounds.stored do
        self:RemoveWound(id)
    end
end