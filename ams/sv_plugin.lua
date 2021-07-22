
local PLUGIN = PLUGIN

function PLUGIN:ClearDiseases(client, character)
    local diseaseTable = ix.AMS.Diseases:GetAll()

    for uniqueID in pairs( diseaseTable ) do
        local table = ix.AMS.Diseases:FindByID(uniqueID)
        local callback = table.Disinfect

        if (callback) then
            callback(client, character)
        end
    end
end

function PLUGIN:RestoreDiseases(client, character)
    local storedDiseases = character:GetDiseases()

    if (storedDiseases and storedDiseases ~= '') then
        local splittedDiseases = string.Split(storedDiseases, ';')

        for _, uniqueID in ipairs( splittedDiseases ) do
            local table = ix.AMS.Diseases:FindByID(uniqueID)
            local callback = table.Infect

            if (callback) then
                callback(client, character)
            end
        end
    end
end

function PLUGIN:ClearWounds(client, character)
    local wounds = ix.AMS.Wounds:GetAll()

    for uniqueID, table in pairs( wounds ) do
        local callback = table.Diswound

        if (callback) then
            callback(client, character)
        end
    end
end

function PLUGIN:RestoreWounds(client, character)
    local storedWounds = character:GetWounds()

    if (storedWounds and storedWounds ~= '') then
        local splittedWounds = string.Split(storedWounds, ';')

        for _, uniqueID in ipairs( splittedWounds ) do
            local table = ix.AMS.Wounds:FindByID(uniqueID)
            local callback = table.Wounded

            if (callback) then
                callback(client, character)
            end
        end
    end
end

function PLUGIN:PostPlayerLoadout(client)
    local character = client:GetCharacter()

    if (character) then
        self:ClearDiseases(client, character)
        self:ClearWounds(client, character)
        self:RestoreDiseases(client, character)
        self:RestoreWounds(client, character)
    end
end

function PLUGIN:DoPlayerDeath(client)
    local character = client:GetCharacter()
    if (character) then
        character:RemoveAllDiseases()
        character:RemoveAllWounds()
        self:ClearDiseases(client, character)
        self:ClearWounds(client, character)
    end
end