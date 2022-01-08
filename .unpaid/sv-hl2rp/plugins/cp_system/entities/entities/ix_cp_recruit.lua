
ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Рекрутёр Civil Protection"
ENT.Category = "[SV] CP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "NoBubble")
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/metropolice/c08.mdl")
		self:SetBodyGroups("00000001010")
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal( )
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid( SOLID_BBOX )
		self:CapabilitiesAdd( CAP_ANIMATEDFACE, CAP_TURN_HEAD )
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()
		self:AddFlags(FL_NOTARGET)

		cpoutfit.SetCPArmband(self, "(0,0,0)_2_(255,0,0,255)_1_(255,255,255,255)_17")
		self:SetDisplayName("MPF-OFC #0001")
		self:SetDescription("")

		local physObj = self:GetPhysicsObject()
		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

if (SERVER) then
	function ENT:Use(ply)
		if (ply.ixCPRecruitCD or 0) > CurTime() then return end
		ply.ixCPRecruitCD = CurTime() + 1
		if !GetNetVar("recruitmentToggled", false) and !ply:IsCombine() then ply:Notify("Набор в Гражданскую Оборону закрыт!") return end
		netstream.Start(ply, 'ixCPRecruitOpen')
	end
else
	ENT.RenderGroup = RENDERGROUP_OPAQUE
	-- client 
	function ENT:CreateBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.6, 0)
	end

	function ENT:Draw()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()

			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.05))
			bubble:SetRenderAngles(Angle(0, realTime * 100, 0))
		end

		self:DrawModel()
	end

	function ENT:Think()
		local noBubble = self:GetNoBubble()

		if (IsValid(self.bubble) and noBubble) then
			self.bubble:Remove()
		elseif (!IsValid(self.bubble) and !noBubble) then
			self:CreateBubble()
		end

		self:SetNextClientThink(CurTime() + 0.25)

		return true
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetDisplayName())
		name:SizeToContents()

		local descriptionText = self:GetDescription()

		if (descriptionText != "") then
			local description = container:AddRow("description")
			description:SetText(self:GetDescription())
			description:SizeToContents()
		end
	end
end
