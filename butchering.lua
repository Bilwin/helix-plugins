PLUGIN.name     = 'Corpse Butchering'
PLUGIN.author   = 'Bilwin'

PLUGIN.list = {
    --[[
    ['modelpath/modelname.mdl'] = {
        butcheringTime = 5,                                                                     -- How many seconds will the corpse be butchered
        impactEffect = 'AntlionGib',                                                            -- What will be the effect when butchering a corpse
        slicingSound = {[1] = 'soundpath/soundname.***', [2] = 'soundpath/soundname.***'},      -- [1] This is the initial butchering sound; [2] this is the sound at which the corpse will already be butchered
        butcheringWeapons = {'weapon_class', 'weapon_class2'},                                  -- Weapons available for butchering a specific corpse
        animation = 'Roofidle1',                                                                -- Animation that will be played when butchering
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
        slicingSound = {'ambient/machines/slicer2.wav', 'ambient/machines/slicer3.wav'},
        items = {}
    }
}

if SERVER then
    ix.log.AddType('playerButchered', function(client, corpse)
        return string.format('%s was butchered %s.', client:Name(), corpse:GetModel())
    end)

    util.AddNetworkString('ixClearClientRagdolls')
	function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
        if IsValid(npc) && self.list[npc:GetModel()] then
            local ragdoll = ents.Create('prop_ragdoll')
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
            net.SendPVS( npc:GetPos() )
        end
	end

    local hook_Run = hook.Run
    local math_ceil = math.ceil
    local util_Effect = util.Effect
    local table_IsEmpty = table.IsEmpty
    local table_HasValue = table.HasValue
    function PLUGIN:KeyPress(client, key)
        if client:GetCharacter() and client:Alive() then
            if key == IN_USE then
                local HitPos = client:GetEyeTraceNoCursor()
                local target = HitPos.Entity
                if target and IsValid(target) and target:IsRagdoll() and self.list[target:GetModel()] then
                    local allowedWeapons = self.list[target:GetModel()].butcheringWeapons or {'weapon_crowbar'}
                    local canButch = hook_Run('CanButchEntity', client, target)
                    if ( table_HasValue(allowedWeapons, client:GetActiveWeapon():GetClass()) and !target:GetNetVar('cutting', false) and client:IsWepRaised() and canButch ) then
                        local butchAnim = self.list[target:GetModel()].animation or 'Roofidle1'
                        local butchSound = self.list[target:GetModel()].slicingSound[1] or 'ambient/machines/slicer1.wav'
                        client:ForceSequence(butchAnim, nil, 0)
                        target:SetNetVar('cutting', true)
                        target:EmitSound(butchSound)
 
                        local physObj, butcheringTime = target:GetPhysicsObject(), self.list[target:GetModel()].butcheringTime or 2
                        if (IsValid(physObj) and !isnumber(self.list[target:GetModel()].butcheringTime) ) then
                            butcheringTime = math_ceil( physObj:GetMass() )
                        end

                        client:SetAction('Butchering...', butcheringTime)
                        client:DoStaredAction(target, function()
                            if ( IsValid(client) ) then
                                client:LeaveSequence()

                                if IsValid(target) then
                                    target:SetNetVar('cutting', nil)
                                    butchSound = self.list[target:GetModel()].slicingSound[2] or 'ambient/machines/slicer4.wav'
                                    target:EmitSound(butchSound)

                                    local effect = EffectData()
                                        effect:SetStart(target:LocalToWorld(target:OBBCenter()))
                                        effect:SetOrigin(target:LocalToWorld(target:OBBCenter()))
                                        effect:SetScale(3)
                                    util_Effect(self.list[target:GetModel()].impactEffect or 'BloodImpact', effect)

                                    local butcheringItems = self.list[target:GetModel()].items or {}
                                    if !table_IsEmpty(butcheringItems) then
                                        for _, item in ipairs(butcheringItems) do
                                            if !client:GetCharacter():GetInventory():Add(item) then
                                                ix.item.Spawn(item, client)
                                            end
                                        end
                                    end

                                    ix.log.Add(client, 'playerButchered', target)
                                    hook_Run('OnButchered', client, target)
                                    target:Remove()
                                end
                            end
                        end, butcheringTime, function()
                            if ( IsValid(client) ) then
                                client:SetAction()
                                client:LeaveSequence()
                                target:SetNetVar('cutting', false)
                            end
                        end)
                    end
                end
            end
        end
    end

    function PLUGIN:CanButchEntity(client, target)
        return true
    end
end

if (CLIENT) then
    net.Receive('ixClearClientRagdolls', function(len)
        local model = net.ReadString()
        timer.Simple(FrameTime() * 2, function()
            for _, ragdoll in ipairs( ents.GetAll() ) do
                if (ragdoll:GetClass() == 'class C_ClientRagdoll' and ragdoll:GetModel() == model) then
                    ragdoll:Remove()
                end
            end
        end)
    end)
end