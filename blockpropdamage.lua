
local PLUGIN = PLUGIN
PLUGIN.name = 'PK Stopper'
PLUGIN.description = 'Block Prop Killing'
PLUGIN.author = 'Bilwin'

if SERVER then
    function PLUGIN:EntityTakeDamage(client, dmg)
        if IsValid(client) and client:IsPlayer() then
            if dmg:IsDamageType(DMG_CRUSH) and !IsValid(client.ixRagdoll) then
                dmg:ScaleDamage(0)
            end
        end
    end
end