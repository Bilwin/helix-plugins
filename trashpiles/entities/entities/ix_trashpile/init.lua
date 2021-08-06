
local PLUGIN = PLUGIN
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( table.Random(PLUGIN.trashModels) )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetMoveType(MOVETYPE_NONE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(120)
		phys:Sleep()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Use(client, caller)
    if (self:GetNetVar('looting') == true) then return end
	if (self:GetNetVar('looted') == true) then return end

	if (self.nextUse and CurTime() < self.nextUse) then
		return
	end

	self.nextUse = CurTime() + 0.5

	if (client:IsRestricted()) then
		return
	end

	if (!client:Crouching()) then
		client:Notify('You must be crouching')
		return
	end

	local cleantime = ix.config.Get("trashPileLootTime", 30)
	client:SetAction("Searching something...", cleantime)
    self:SetNetVar('looting', true)

	local uniqueID = "ixTrashSearch."..client:UniqueID()
	local data = {}
	data.filter = client
	timer.Create(uniqueID, 0.1, cleantime / 0.1, function()
		if (IsValid(client) and IsValid(self)) then
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96

			if (util.TraceLine(data).Entity != self or client:IsRestricted() or client:GetVelocity():LengthSqr() > 0) then
				timer.Remove(uniqueID)
				client:SetAction()
                self:SetNetVar('looting', false)
			elseif !client:Crouching() then
				timer.Remove(uniqueID)
				client:SetAction()
                self:SetNetVar('looting', false)
			elseif (timer.RepsLeft(uniqueID) == 0) then
				PLUGIN:Calculate(client, self)
                self:SetNetVar('looting', false)
			end
		else
			timer.Remove(uniqueID)
			if IsValid(client) then
            	client:SetAction()
			end

			if IsValid(self) then
            	self:SetNetVar('looting', false)
			end
		end
	end)
end

function ENT:CanTool(player, trace, tool)
	return false
end