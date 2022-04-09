
local PLUGIN = PLUGIN
ENT.Type = "anim"
ENT.PrintName = "Apartments Lock"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("String", 0, "Owners")
	self:NetworkVar("Bool", 1, "DisplayError")

	if (SERVER) then
		self:NetworkVarNotify("Locked", self.OnLockChanged)
	end
end

if (SERVER) then
    function ENT:GetLockPosition(door, normal)
        local index = door:LookupBone("handle")
        local position = door:GetPos()
        normal = normal or door:GetForward():Angle()
    
        if (index and index >= 1) then
            position = door:GetBonePosition(index)
        end
    
        position = position + normal:Forward() * 7.2 + normal:Up() * 10 + normal:Right() * 2
    
        normal:RotateAroundAxis(normal:Up(), 90)
        normal:RotateAroundAxis(normal:Forward(), 180)
        normal:RotateAroundAxis(normal:Right(), 180)
    
        return position, normal
    end
    
    function ENT:SetDoor(door, position, angles)
        if (!IsValid(door) or !door:IsDoor()) then
            return
        end
    
        local doorPartner = door:GetDoorPartner()
    
        self.door = door
        self.door:DeleteOnRemove(self)
        door.ixLock = self
    
        if (IsValid(doorPartner)) then
            self.doorPartner = doorPartner
            self.doorPartner:DeleteOnRemove(self)
            doorPartner.ixLock = self
        end
    
        self:SetPos(position)
        self:SetAngles(angles)
        self:SetParent(door)
    end
    
    function ENT:SpawnFunction(client, trace)
        local door = trace.Entity
    
        if (!IsValid(door) or !door:IsDoor() or IsValid(door.ixLock)) then
            return client:NotifyLocalized("dNotValid")
        end
    
        local normal = client:GetEyeTrace().HitNormal:Angle()
        local position, angles = self:GetLockPosition(door, normal)
    
        local entity = ents.Create("ix_apartlock")
        entity:SetPos(trace.HitPos)
        entity:Spawn()
        entity:Activate()
        entity:SetDoor(door, position, angles)
        entity:DrawShadow(false)
    
        PLUGIN:SaveData()
        return entity
    end
    
    function ENT:Initialize()
        self:SetModel("models/props_combine/combine_lock01.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self:SetUseType(SIMPLE_USE)
        self:DrawShadow(false)
    
        self.nextUseTime = 0
    end
    
    function ENT:OnRemove()
        if (IsValid(self)) then
            self:SetParent(nil)
        end
    
        if (IsValid(self.door)) then
            self.door:Fire("unlock")
            self.door.ixLock = nil
        end
    
        if (IsValid(self.doorPartner)) then
            self.doorPartner:Fire("unlock")
            self.doorPartner.ixLock = nil
        end

        if (!ix.shuttingDown) then
			PLUGIN:SaveData()
            hook.Run("ApartmentRemoved", self)
		end
    end
    
    function ENT:OnLockChanged(name, bWasLocked, bLocked)
        if (!IsValid(self.door)) then
            return
        end
    
        if (bLocked) then
            self:EmitSound("buttons/combine_button2.wav")
            self.door:Fire("lock")
            self.door:Fire("close")
    
            if (IsValid(self.doorPartner)) then
                self.doorPartner:Fire("lock")
                self.doorPartner:Fire("close")
            end
        else
            self:EmitSound("buttons/combine_button7.wav")
            self.door:Fire("unlock")
    
            if (IsValid(self.doorPartner)) then
                self.doorPartner:Fire("unlock")
            end
        end
    end
    
    function ENT:DisplayError()
        self:EmitSound("buttons/combine_button_locked.wav")
        self:SetDisplayError(true)
    
        timer.Simple(1.2, function()
            if (IsValid(self)) then
                self:SetDisplayError(false)
            end
        end)
    end
    
    function ENT:Toggle(client)
        if (self.nextUseTime > CurTime()) then
            return
        end

        local cid = client:GetCharacter():GetInventory():HasItem("cid")

        if client:IsCombine() then
            self:SetLocked(!self:GetLocked())
            self.nextUseTime = CurTime() + 2
            return
        end

        if (!cid) then
            self:DisplayError()
            self.nextUseTime = CurTime() + 2
    
            return
        end

        if ( !self:AlreadyOwned(cid:GetData("id")) ) then
            self:DisplayError()
            self.nextUseTime = CurTime() + 2
    
            return
        end
    
        self:SetLocked(!self:GetLocked())
        self.nextUseTime = CurTime() + 2
    end
    
    function ENT:Use(client)
        self:Toggle(client)
    end
    
    function ENT:AlreadyOwned(cid)
        local owners = string.Split( tostring( self:GetOwners() ), ";" )
        if owners and !table.IsEmpty(owners) then
            if table.HasValue(owners, tostring(cid)) then
                return true
            end
        end
        return false
    end
    
    function ENT:AddOwner(cid)
        if self:AlreadyOwned(cid) then return end

        if self:GetOwners() == '' or self:GetOwners() == nil then
            self:SetOwners( tostring( cid ) )
        else
            self:SetOwners( tostring( self:GetOwners() ) .. ';' .. tostring( cid ) )
        end

        hook.Run('ApartmentOwned', self, cid)
    end
    
    function ENT:RemoveOwner(cid)
        if !self:AlreadyOwned(cid) then return end
        local owners = self:GetOwners()
        local splitted = string.Split(owners, ';')
    
        for _, id in ipairs( splitted ) do
            if id == tostring(cid) then
                table.RemoveByValue(splitted, id)
            end
        end
        
        local concat = table.concat(splitted, ';')
        self:SetOwners(tostring(concat))
    
        hook.Run('ApartmentUnowned', self, cid)
    end
end

if (CLIENT) then
	local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
	local color_green = Color(0, 255, 0, 255)
	local color_blue = Color(212, 121, 174)
	local color_red = Color(255, 50, 50, 255)

	function ENT:Draw()
		self:DrawModel()

		local color = color_green

		if (self:GetDisplayError()) then
			color = color_red
		elseif (self:GetLocked()) then
			color = color_blue
		end

		local position = self:GetPos() + self:GetUp() * -8.7 + self:GetForward() * -3.85 + self:GetRight() * -6

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, 10, 10, color)
	end
end
