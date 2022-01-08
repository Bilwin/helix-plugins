
local PANEL = {}
local PLUGIN = PLUGIN
local function lighten( color, percent )
	return Color(color.r + percent, color.g + percent, color.b + percent)
end

local btnAccept
local btnAcceptHover
local btnClose
local btnCloseHover
AccessorFunc(PANEL, "bReadOnly", "ReadOnly", FORCE_BOOL)

function PANEL:Init()
	if IsValid(ix.gui.npcCPRankManager) then
		ix.gui.npcCPRankManager:Remove()
	end
	ix.gui.npcCPRankManager = self

	btnAccept = ix.config.Get("color")
	btnAcceptHover = lighten( btnAccept, 25 )
	btnClose = Color(192,57,43)
	btnCloseHover = lighten( btnClose, 25 )
	local xp = LocalPlayer():GetCharacter():GetCPPoint()

	self:SetSize(SScale(300), VScale(300))
	self:SetTitle("Очки Ранга: "..xp)
	self:MakePopup()
	self:Center()
	self:SetDraggable(false)

	self.navbar = self:Add("DScrollPanel")
	self.navbar:DockPadding(5, 5, 5, 5)
	self.navbar:Dock(LEFT)
	self.navbar:SetWide(SScaleMin(200/2))

	self.content = self:Add("DPanel")
	self.content:DockPadding(5, 5, 5, 5)
	self.content:Dock(FILL)

	self.header = self.content:Add("DLabel")
	self.header:Dock(TOP)
	self.header:SetText('')
	self.header:SetTextColor(color_white)
	self.header:SetFont("ixBigFont")
	self.header:SetWrap(true)
	self.header:SetTall( 50 )

	self.description = self.content:Add("DLabel")
	self.description:Dock(TOP)
	self.description:SetText('')
	self.description:SetTextColor(color_white)
	self.description:SetFont("ixMediumLightFont")
	self.description:SetWrap(true)
	self.description:DockMargin(0, 0, 0, 25)

	self.AcceptRank = self.content:Add("DButton")
	self.AcceptRank:SetText('')
	self.AcceptRank:Dock(BOTTOM)
	self.AcceptRank:SetTall( 35 )
	self.AcceptRank:SetVisible(false)
	self.AcceptRank.Paint = function(self, w,h)
		surface.SetDrawColor( btnAccept ) 
		surface.DrawOutlinedRect( 0, 0, w, h, 1)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, btnAcceptHover )
		end
	end
	self.AcceptRank.DoClick = function()
		net.Start("ixAcceptRank", true)
			net.WriteString(self.AcceptRank.id)
			net.WriteEntity(self.ent)
		net.SendToServer()
		self:Remove()
	end

	for id, data in SortedPairsByMemberValue(ix.ranks.stored, 'xp') do
		if data.hide then continue end
		self.RankButton = self.navbar:Add("DButton")
		self.RankButton:SetText( data.name )
		self.RankButton:Dock(TOP)
		self.RankButton:DockMargin(0, 0, 5, 5)
		self.RankButton:SetTall( 35 )

		if table.HasValue(PLUGIN.blacklisted_ranks, id) and LocalPlayer():GetCharacter():GetSquad() ~= "gu" then
			self.RankButton:SetText(Format("%s | Вы в подразделении!", data.name))
			self.RankButton.Paint = function(self, w,h)
				surface.SetDrawColor( btnClose ) 
				surface.DrawOutlinedRect( 0, 0, w, h, 1)
				if self:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, btnCloseHover )
				end
			end
		elseif ( xp < data.xp ) then
			self.RankButton:SetText(Format("%s | Необходимо ещё %s ОР", data.name, data.xp - xp))
			self.RankButton.Paint = function(self, w,h)
				surface.SetDrawColor( btnClose ) 
				surface.DrawOutlinedRect( 0, 0, w, h, 1)
				if self:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, btnCloseHover )
				end
			end
		else
			if id == LocalPlayer():GetCharacter():GetData("cmbRank") then
				self.RankButton:SetText(Format("%s - Активно", data.name))
				self.RankButton.Paint = function(self, w,h)
					surface.SetDrawColor( Color(155, 255, 155) )
					surface.DrawOutlinedRect( 0, 0, w, h, 1)
					if self:IsHovered() then
						draw.RoundedBox(0, 0, 0, w, h, Color(100, 200, 100) )
					end
				end

				self.RankButton.DoClick = function()
					self.AcceptRank:SetVisible(false)
					self.AcceptRank.id = id
					self.AcceptRank:SetText("Вы уже получили данный ранг")
					self.header:SetText(data.name)
					self.description:SetText(data.description)
					self.description:SizeToContents()
					self.header:SizeToContents()
					surface.PlaySound("ui/buttonclick.wav")
				end
			else
				self.RankButton.Paint = function(self, w,h)
					surface.SetDrawColor( btnAccept ) 
					surface.DrawOutlinedRect( 0, 0, w, h, 1)
					if self:IsHovered() then
						draw.RoundedBox(0, 0, 0, w, h, btnAcceptHover )
					end
				end

				self.RankButton.DoClick = function()
					self.AcceptRank:SetVisible(true)
					self.AcceptRank.id = id
					self.AcceptRank:SetText("Получить звание: ".. data.name )
					self.header:SetText(data.name)
					self.description:SetText(data.description)
					self.description:SizeToContents()
					self.header:SizeToContents()
					surface.PlaySound("ui/buttonclick.wav")
				end
			end
		end
	end
end

function PANEL:SetEnt(ent)
	self.ent = ent
end

vgui.Register("ixCP_RankManager", PANEL, "DFrame")
