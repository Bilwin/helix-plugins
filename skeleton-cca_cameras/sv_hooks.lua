local plugin = PLUGIN
local distance, classname = 335, "npc_combine_camera"
local _blacklist_weapon = {
    ["weapon_smg1"] = true,
    ["weapon_shotgun"] = true,
    ["weapon_slam"] = true,
    ["weapon_rpg"] = true,
    ["weapon_ar2"] = true,
    ["weapon_stunstick"] = true,
    ["weapon_frag"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_crossbow"] = true,
    ["weapon_pistol"] = true
}

-- idk why i do this
function plugin:EmitQueuedSound(ent, t_sound)
    return ix.util.EmitQueuedSounds(ent, t_sound, 0, 0.1, 75, 100)
end

function plugin:Think()
    for _, ent in pairs(ents.FindByClass(classname)) do
        for _, pl in pairs(ents.FindInSphere(ent:GetPos(), distance)) do
            if not (pl:IsPlayer() and ent:IsLineOfSightClear(pl:GetPos())) then -- If camera isn't triggered or ent is not player then ignore
                continue
            end

            if (pl:IsCombine()) then continue end -- If player is combine ignore

            if _blacklist_weapon[pl:GetActiveWeapon():GetClass()] and (pl.b_CameraScanDelay or 0) < CurTime() then -- Custom check, if you want you can change this
                self:EmitQueuedSound(ent, {"npc/scanner/scanner_siren1.wav", "npc/scanner/scanner_photo1.wav"})
                ent:Fire("SetAngry")

                ent:_SetSimpleTimer(5, function()
                    ent:Fire("SetIdle")
                end)

                pl.b_CameraScanDelay = CurTime() + 5
            end
        end
    end
end

-- No breakable camera
function plugin:EntityTakeDamage(target, dmginfo)
    if target:GetClass() == classname then
        dmginfo:SetDamage(0)
    end
end