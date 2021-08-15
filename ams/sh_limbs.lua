
local PLUGIN = PLUGIN
PLUGIN.defaultLimbsData = PLUGIN.defaultLimbsData or {
    ['leftArmHealthy']      = 60,
    ['rightArmHealthy']     = 60,
    ['leftLegHealthy']      = 65,
    ['rightLegHealthy']     = 65,
    ['chestHealthy']        = 85,
    ['gearHealthy']         = 85,
    ['stomachHealthy']      = 70,
    ['headHealthy']         = 35
}

function PLUGIN:InitializedPlugins()
    for key, default in pairs(self.defaultLimbsData) do
        ix.char.RegisterVar(key, {
            field = key,
            fieldType = ix.type.number,
            default = default,
            bNoDisplay = true
        })
    end
end

PLUGIN.Limbs = PLUGIN.Limbs or {}
PLUGIN.Limbs[HITGROUP_HEAD]     = true
PLUGIN.Limbs[HITGROUP_GEAR]     = true
PLUGIN.Limbs[HITGROUP_CHEST]    = true
PLUGIN.Limbs[HITGROUP_STOMACH]  = true
PLUGIN.Limbs[HITGROUP_LEFTARM]  = true
PLUGIN.Limbs[HITGROUP_RIGHTARM] = true
PLUGIN.Limbs[HITGROUP_LEFTLEG]  = true
PLUGIN.Limbs[HITGROUP_RIGHTLEG] = true

PLUGIN.LimbWounds = PLUGIN.LimbWounds or {}
PLUGIN.LimbWounds[HITGROUP_HEAD] = {}
PLUGIN.LimbWounds[HITGROUP_GEAR] = {
    {
        uniqueID = 'example',
        chance = 75,
        filter = function(client, character, dmgInfo, dir, trace)
            return client:Health() <= 70
        end
    }
}
PLUGIN.LimbWounds[HITGROUP_CHEST] = {
    {
        uniqueID = 'example',
        chance = 75,
        filter = function(client, character, dmgInfo, dir, trace)
            return client:Health() <= 70
        end,
        onInstanced = function(client, character, dmgInfo, dir, trace)
            character:AddDisease('example')
            character:DecreaseChestHealthy(30)
        end
    }
}
PLUGIN.LimbWounds[HITGROUP_STOMACH] = {
    {
        uniqueID = 'example',
        chance = 80,
        filter = function(client, character, dmgInfo, dir, trace)
            return client:Health() <= 70
        end,
        onInstanced = function(client, character, dmgInfo, dir, trace)
            character:DecreaseStomachHealthy(25)
        end
    }
}
PLUGIN.LimbWounds[HITGROUP_LEFTARM] = {
    {
        uniqueID = 'example',
        chance = 20,
        filter = function(client, character, dmgInfo, dir, trace)
            return client:Health() <= 70
        end,
        onInstanced = function(client, character, dmgInfo, dir, trace)
            character:DecreaseLeftArmHealthy(15)
        end
    }
}
PLUGIN.LimbWounds[HITGROUP_RIGHTARM] = {
    {
        uniqueID = 'example',
        chance = 20,
        filter = function(client, character, dmgInfo, dir, trace)
            return client:Health() <= 70
        end,
        onInstanced = function(client, character, dmgInfo, dir, trace)
            character:DecreaseRightArmHealthy(15)
        end
    }
}
PLUGIN.LimbWounds[HITGROUP_LEFTLEG] = {}
PLUGIN.LimbWounds[HITGROUP_RIGHTLEG] = {}