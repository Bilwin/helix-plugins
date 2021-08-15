
local PLUGIN = PLUGIN
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/props_lab/citizenradio.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
    if IsValid(phys) then
	    phys:Wake()
    end
end

function ENT:Use(activator, caller)
	if ((activator.ixNextRadioUse or 0) > RealTime()) then return end

	net.Start('ixRadio')
		net.WriteEntity(self)
	net.Send(activator)

	activator.ixNextRadioUse = RealTime() + 1
end

function ENT:StopSoundAll()
	for song in pairs(PLUGIN.songs) do
		self:StopSound(song)
	end
end

function ENT:OnRemove()
	self:StopSoundAll()
end

local function song_whitelisted(song)
	local bStatus = false

	for _song in pairs(PLUGIN.songs) do
		if _song == song then
			bStatus = true
			break
		end
	end

	return bStatus
end

function ENT:SelectSong(soundPath)
	if IsValid(self) then
		if !song_whitelisted(soundPath) then return end

		self:StopSoundAll()
		timer.Simple(0.1, function()
			if IsValid(self) then
				self:EmitSound(soundPath, 70, 100)
			end
		end)
	end
end