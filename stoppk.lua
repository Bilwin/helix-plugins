
local PLUGIN = PLUGIN
PLUGIN.name = "Prop-Kill blocker"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

if SERVER then
    function PLUGIN:EntityTakeDamage(client, dmg)
        if IsValid(client) and client:IsPlayer() then
            if dmg:IsDamageType(DMG_CRUSH) and !IsValid(client.ixRagdoll) then
                dmg:ScaleDamage(0)
            end
        end
    end
end