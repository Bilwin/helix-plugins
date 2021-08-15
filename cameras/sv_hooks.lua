
-- optimizate
function PLUGIN:Think()
    local cameras_ents = ents.FindByClass("npc_combine_camera")

    for _, camera in ipairs(cameras_ents) do
        local near_ents = ents.FindInSphere( camera:GetPos(), 335 )
        for _, target in ipairs(near_ents) do
            if not ( target:IsPlayer() and camera:IsLineOfSightClear( target:GetPos() ) ) then continue end
            --...
        end
    end
end

function PLUGIN:EntityTakeDamage(target, dmginfo)
    if target:GetClass() == "npc_combine_camera" then
        dmginfo:SetDamage(0)
    end
end