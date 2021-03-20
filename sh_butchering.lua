
PLUGIN.name = 'Corpse butchering'
PLUGIN.author = 'Bilwin'
PLUGIN.schema = 'Any'
PLUGIN.license = [[
    Copyright 2021 Maxim Sukharev (Bilwin) All Rights Reserved
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
]]

ix.CorpseButchering = {
    --[[
    ['modelpath/modelname.mdl'] = {
        butcheringTime = 5,                                                                     -- How many seconds will the corpse be butchered
        impactEffect = "AntlionGib",                                                            -- What will be the effect when butchering a corpse
        slicingSound = {[1] = "soundpath/soundname.***", [2] = "soundpath/soundname.***"},      -- [1] This is the initial butchering sound; [2] this is the sound at which the corpse will already be butchered
        butcheringWeapons = {'weapon_class', 'weapon_class2'},                                  -- Weapons available for butchering a specific corpse
        animation = "Roofidle1",                                                                -- Animation that will be played when butchering
        items = {'item_uniqueID1', 'item_uniqueID2'}                                            -- Items to be issued for character after butchered
    }
    --]]
    ['models/Lamarr.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/headcrabclassic.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/headcrabblack.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/headcrab.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/antlion.mdl'] = {
        impactEffect = 'AntlionGib',
        butcheringTime = 30,
        slicingSound = {[1] = 'ambient/machines/slicer2.wav', [2] = 'ambient/machines/slicer3.wav'},
        items = {}
    }
}

if (SERVER) then
    util.AddNetworkString('ixClearClientRagdolls')
	function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
        if IsValid(npc) then
            local ragdoll = ents.Create("prop_ragdoll")
            ragdoll:SetPos( npc:GetPos() )
            ragdoll:SetAngles( npc:EyeAngles() )
            ragdoll:SetModel( npc:GetModel() )
            ragdoll:SetSkin( npc:GetSkin() )

            for i = 0, (npc:GetNumBodyGroups() - 1) do
                ragdoll:SetBodygroup(i, npc:GetBodygroup(i))
            end

            ragdoll:Spawn()
            ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            ragdoll:Activate()

            local velocity = npc:GetVelocity()

            for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
                local physObj = ragdoll:GetPhysicsObjectNum(i)

                if ( IsValid(physObj) ) then
                    physObj:SetVelocity(velocity)

                    local index = ragdoll:TranslatePhysBoneToBone(i)

                    if (index) then
                        local position, angles = npc:GetBonePosition(index)

                        physObj:SetPos(position)
                        physObj:SetAngles(angles)
                    end
                end
            end

            net.Start('ixClearClientRagdolls')
                net.WriteString(npc:GetModel())
            net.Broadcast()
        end
	end

    function PLUGIN:KeyPress(pl, key)
        if ( pl:GetCharacter() and pl:Alive() ) then
            if ( key == IN_USE ) then
                local HitPos = pl:GetEyeTraceNoCursor()
                local target = HitPos.Entity
                local allowedWeapons = istable(ix.CorpseButchering[target:GetModel()].butcheringWeapons) and ix.CorpseButchering[target:GetModel()].butcheringWeapons or {'weapon_crowbar'}
                if ( target:IsRagdoll() and ix.CorpseButchering[target:GetModel()] and table.HasValue(allowedWeapons, pl:GetActiveWeapon():GetClass()) and !target:GetNetVar('cutting', false) and pl:IsWepRaised() ) then
                    local butcheringAnimation = isstring(ix.CorpseButchering[target:GetModel()].animation) and ix.CorpseButchering[target:GetModel()].animation or "Roofidle1"
                    pl:ForceSequence(butcheringAnimation, nil, 0)
                    target:SetNetVar('cutting', true)
                    target:EmitSound( (istable(ix.CorpseButchering[target:GetModel()].slicingSound) and ix.CorpseButchering[target:GetModel()].slicingSound[1]) or "ambient/machines/slicer1.wav" )

                    local physObj, butcheringTime = target:GetPhysicsObject(), isnumber(ix.CorpseButchering[target:GetModel()].butcheringTime) and ix.CorpseButchering[target:GetModel()].butcheringTime or 2

                    if ( IsValid(physObj) and !isnumber(ix.CorpseButchering[target:GetModel()].butcheringTime) ) then
                        butcheringTime = math.Round( physObj:GetMass() )
                    end

                    pl:SetAction("Butchering...", butcheringTime)
                    pl:DoStaredAction(target, function()
                        if ( IsValid(pl) ) then
                            pl:LeaveSequence()

                            if IsValid(target) then
                                target:SetNetVar('cutting', nil)
                                target:EmitSound( (istable(ix.CorpseButchering[target:GetModel()].slicingSound) and ix.CorpseButchering[target:GetModel()].slicingSound[2] or "ambient/machines/slicer4.wav") )

                                local effect = EffectData()
                                    effect:SetStart(target:LocalToWorld(target:OBBCenter()))
                                    effect:SetOrigin(target:LocalToWorld(target:OBBCenter()))
                                    effect:SetScale(3)
                                util.Effect(ix.CorpseButchering[target:GetModel()].impactEffect or "BloodImpact", effect)

                                local butcheringItems = istable(ix.CorpseButchering[target:GetModel()].items) and ix.CorpseButchering[target:GetModel()].items or {}
                                if !table.IsEmpty(butcheringItems) then
                                    for _, item in ipairs( butcheringItems ) do
                                        pl:GetCharacter():GetInventory():Add(item)
                                    end
                                end

                                target:Remove()
                            end
                        end
                    end, butcheringTime, function()
                        if ( IsValid(pl) ) then
                            pl:SetAction()
                            pl:LeaveSequence()
                            target:SetNetVar('cutting', false)
                        end
                    end)
                end
            end
        end
    end
end

if (CLIENT) then
    net.Receive('ixClearClientRagdolls', function(len)
        local model = net.ReadString()
        timer.Simple(.01, function()
            for _, ragdoll in ipairs( ents.GetAll() ) do
                if (ragdoll:GetClass() == 'class C_ClientRagdoll' and ragdoll:GetModel() == model) then
                    ragdoll:Remove()
                end
            end
        end)
    end)
end