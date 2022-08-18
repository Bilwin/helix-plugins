PLUGIN.name     = 'Prop-Kill blocker'
PLUGIN.author   = 'Bilwin'

if SERVER then
    function PLUGIN:EntityTakeDamage(client, dmg)
        if IsValid(client) && client:IsPlayer() && dmg:IsDamageType(DMG_CRUSH) && not IsValid(client.ixRagdoll) then
            return true
        end
    end
end
