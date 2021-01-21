
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
function PLUGIN:EmitQueuedSound(ent, t_sound)
    return ix.util.EmitQueuedSounds(ent, t_sound, 0, 0.1, 75, 100)
end

function PLUGIN:Think()
    local _allents = ents.FindByClass(classname)
    for i = 1, #_allents do
        local ent = _allents[i]
        local _buffer = ents.FindInSphere( ent:GetPos(), distance )

        for i = 1, #_buffer do
            local pl = _buffer[i]
            if not ( pl:IsPlayer() and ent:IsLineOfSightClear( pl:GetPos() ) ) then continue end
            if ( pl:IsCombine() ) then continue end

            -- do anything here...

            --[[ Example

            if _blacklist_weapon[pl:GetActiveWeapon():GetClass()] and (pl.b_CameraScanDelay or 0) < CurTime() then
                self:EmitQueuedSound(ent, {"npc/scanner/scanner_siren1.wav", "npc/scanner/scanner_photo1.wav"})
                ent:Fire("SetAngry")

                ent:_SetSimpleTimer(5, function()
                    ent:Fire("SetIdle")
                end)

                pl.b_CameraScanDelay = CurTime() + 5
            end

            --]]
        end
    end
end

-- No breakable camera
function PLUGIN:EntityTakeDamage(target, dmginfo)
    if target:GetClass() == classname then
        dmginfo:SetDamage(0)
    end
end