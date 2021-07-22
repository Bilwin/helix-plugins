
local WOUND = ix.AMS.Wounds:New()
    WOUND.uniqueID = 'example'
    WOUND.name = 'Example'
    WOUND.Wounded = function(client, character)
        client:SetNetVar("ExampleWound", true)
    end
    WOUND.Diswound = function(client, character)
        client:SetNetVar("ExampleWound", false)
    end
ix.AMS.Wounds:Register(WOUND)
