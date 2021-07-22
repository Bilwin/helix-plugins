
local DISEASE = ix.AMS.Diseases:New()
    DISEASE.uniqueID = 'example'
    DISEASE.name = 'Example'
    DISEASE.immuneFactions = {FACTION_OTA}
    DISEASE.Infect = function(client, character)
        client:SetLocalVar("ExampleDisease", true)
    end
    DISEASE.Disinfect = function(client, character)
        client:SetLocalVar("ExampleDisease", false)
    end
ix.AMS.Diseases:Register(DISEASE)
