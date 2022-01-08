
local PANEL = {}

local function lighten( color, percent )
	return Color(color.r + percent, color.g + percent, color.b + percent)
end

local btnAccept
local btnAcceptHover
local btnClose
local btnCloseHover
AccessorFunc(PANEL, "bReadOnly", "ReadOnly", FORCE_BOOL)

function PANEL:Init()
	if IsValid(ix.gui.npcRecruitCP) then
		ix.gui.npcRecruitCP:Remove()
	end
	ix.gui.npcRecruitCP = self

	btnAccept = ix.config.Get("color")
	btnAcceptHover = lighten( btnAccept, 25 )
	btnClose = Color(192,57,43)
	btnCloseHover = lighten( btnClose, 25 )
	local faction = LocalPlayer():GetCharacter():GetFaction()

	self:SetSize(SScale(300), VScale(100))
	self:SetTitle("")
	self:MakePopup()
	self:Center()
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self.Paint = function(self, w, h)
		if (!self.bNoBackgroundBlur) then
			ix.util.DrawBlur(self, 10)
		end

		surface.SetDrawColor(30, 30, 30, 150)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

		surface.SetDrawColor(ix.config.Get("color"))
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	end

	self.panel = self:Add("DPanel")
	self.panel:DockPadding(25, 25, 25, 25)
	self.panel:Dock(FILL)
	self.panel.Paint = function() return false end

	self.description = self.panel:Add("DLabel")
	self.description:Dock(FILL)
	self.description:SetText("Я рекрутёр Гражданской Обороны. Чтобы вступить в ряды Г.О. тебе нужно (WIP)[БЫТЬ ЛОЯЛИСТОМ 2ГО УРОВНЯ] \nЖелаешь вступить в наши ряды? ")
	self.description:SetTextColor(color_white)
	self.description:SetFont("ixMediumFont")
	self.description:SetWrap(true)
	self.description:SizeToContents()
	self.description:SetAutoStretchVertical(true)

	if ( faction == FACTION_MPF ) then
		self.description:SetText(Format("Доброго времени суток, юнит %s.\nЖелаете перейти в гражданку?", LocalPlayer():GetCharacter():GetName()))
	else
		self:SetSize(SScale(300), VScale(120))
	end

	self.footer = self:Add("DPanel")
	self.footer:Dock(BOTTOM)
	self.footer:SetTall( SScaleMin(60/2) )
	self.footer.Paint = nil

	self.button = self.footer:Add("DButton")
	self.button:SetText("Вступить в ряды Г.О.")

	if ( faction == FACTION_MPF ) then
		self.button:SetText("Стать гражданским")
	end

	self.button:Dock(LEFT)
	self.button:SetSize(self:GetWide() * 0.5 - SScaleMin(5/2))
	self.button.Paint = function(self, w,h)
		surface.SetDrawColor( ix.config.Get("color") ) 
		surface.DrawOutlinedRect( 0, 0, w, h, 1)

		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, btnAcceptHover)
		end
	end
	self.button.DoClick = function()
		netstream.Start("ixCadetAccept")
		surface.PlaySound("ui/buttonclick.wav")
		self:Close()
	end

	self.close = self.footer:Add("DButton")
	self.close:SetText("Отказаться")
	self.close:Dock(RIGHT)
	self.close:SetSize(self:GetWide() * 0.5 - SScaleMin(5/2))
	self.close.Paint = function(self, w,h)
		surface.SetDrawColor( btnClose ) 
		surface.DrawOutlinedRect( 0, 0, w, h, 1)
		
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, btnCloseHover)
		end
	end

	self.close.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		self:Close()
	end
end

vgui.Register("ixCP_Recruit", PANEL, "DFrame")
