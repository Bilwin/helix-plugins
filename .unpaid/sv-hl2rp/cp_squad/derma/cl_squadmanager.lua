
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
	if IsValid(ix.gui.squadCPManager) then
		ix.gui.squadCPManager:Remove()
	end
	ix.gui.squadCPManager = self

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

	self.acceptsquad = self.content:Add("DButton")
	self.acceptsquad:SetText('')
	self.acceptsquad:Dock(BOTTOM)
	self.acceptsquad:SetTall( 35 )
	self.acceptsquad:SetVisible(false)
	self.acceptsquad.Paint = function(self, w,h)
		surface.SetDrawColor( btnAccept ) 
		surface.DrawOutlinedRect( 0, 0, w, h, 1)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, btnAcceptHover )
		end
	end
	self.acceptsquad.DoClick = function()
		net.Start("ixAcceptSquad", true)
			net.WriteString(self.acceptsquad.id)
			if self.ent then
				net.WriteEntity(self.ent)
			end
		net.SendToServer()
		self:Remove()
	end

	for id, data in SortedPairsByMemberValue(ix.squads.stored, 'xp') do
		if data.isPrivate then continue end
		self.squadbutton = self.navbar:Add("DButton")
		self.squadbutton:SetText( data.uniqueID:upper() )
		self.squadbutton:Dock(TOP)
		self.squadbutton:DockMargin(0, 0, 5, 5)
		self.squadbutton:SetTall( 35 )

		if ( xp < data.xp ) then
			self.squadbutton:SetText(Format("%s | Необходимо ещё %s ОР", data.uniqueID:upper(), data.xp - xp))
			self.squadbutton.Paint = function(self, w,h)
				surface.SetDrawColor( btnClose ) 
				surface.DrawOutlinedRect( 0, 0, w, h, 1)
				if self:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, btnCloseHover )
				end
			end
		elseif ( ix.squads.IsLimited(id) ) then
			self.squadbutton:SetText(Format("%s | Занято!", data.uniqueID:upper()))
			self.squadbutton.Paint = function(self, w,h)
				surface.SetDrawColor( btnClose ) 
				surface.DrawOutlinedRect( 0, 0, w, h, 1)
				if self:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, btnCloseHover )
				end
			end
		else
			if id == LocalPlayer():GetCharacter():GetSquad() then
				self.squadbutton:SetText(Format("%s - Активно", data.uniqueID:upper()))
				self.squadbutton.Paint = function(self, w,h)
					surface.SetDrawColor( Color(155, 255, 155) )
					surface.DrawOutlinedRect( 0, 0, w, h, 1)
					if self:IsHovered() then
						draw.RoundedBox(0, 0, 0, w, h, Color(100, 200, 100) )
					end
				end

				self.squadbutton.DoClick = function()
					self.acceptsquad:SetVisible(false)
					self.acceptsquad.id = id
					self.acceptsquad:SetText("Вы уже состоите в этом подразделении!")
					self.header:SetText(data.name)
					self.description:SetText(data.description)
					self.description:SizeToContents()
					self.header:SizeToContents()
					surface.PlaySound("ui/buttonclick.wav")
				end
			else
				self.squadbutton.Paint = function(self, w,h)
					surface.SetDrawColor( btnAccept ) 
					surface.DrawOutlinedRect( 0, 0, w, h, 1)
					if self:IsHovered() then
						draw.RoundedBox(0, 0, 0, w, h, btnAcceptHover )
					end
				end

				self.squadbutton.DoClick = function()
					self.acceptsquad:SetVisible(true)
					self.acceptsquad.id = id
					self.acceptsquad:SetText("Вступить в подразделение: ".. data.name )
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

vgui.Register("ixCP_SquadManager", PANEL, "DFrame")
