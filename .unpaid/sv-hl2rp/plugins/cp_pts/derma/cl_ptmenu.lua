
local PANEL = {}
local function lighten( color, percent )
	return Color(color.r + percent, color.g + percent, color.b + percent)
end

local btnAccept
local btnAcceptHover
local btnClose
local btnCloseHover
AccessorFunc(PANEL, "bReadOnly", "ReadOnly", FORCE_BOOL)

local function recreate()
    vgui.Create("ixPTMenu")
    if IsValid(ix.gui.pdamainmenu) then
        ix.gui.pdamainmenu.ptmenu = vgui.Create("ixPTMenu", ix.gui.pdamainmenu.delta)
        ix.gui.pdamainmenu.ptmenu:Dock(FILL)
    end
end

surface.CreateFont("ixPTFont", {
	font = "Open Sans",
	extended = true,
	size = SScaleMin(13/2),
	weight = 500,
	antialias = true,
	shadow = true,
})

function PANEL:Init()
    if IsValid(ix.gui.ptsMenu) then
        ix.gui.ptsMenu:Remove()
    end
    ix.gui.ptsMenu = self

	btnAccept = ix.config.Get("color")
	btnAcceptHover = lighten( btnAccept, 25 )
	btnClose = Color(192,57,43)
	btnCloseHover = lighten( btnClose, 25 )
    
    self.navbar = self:Add("DScrollPanel")
	self.navbar:DockPadding(5, 5, 5, 5)
	self.navbar:Dock(LEFT)
	self.navbar:SetWide(SScaleMin(200/2))

	self.payload = self:Add("DPanel")
	self.payload:DockPadding(5, 5, 5, 5)
	self.payload:Dock(FILL)

	self.content = self.payload:Add("DListView")
	self.content:DockPadding(5, 5, 5, 5)
    self.content:SetMultiSelect( false )
    self.content:AddColumn("Юнит", 1).Header:SetTextColor(color_black)
    self.content:AddColumn("Роль", 2).Header:SetTextColor(color_black)
    self.content:SetVisible(false)
	self.content:Dock(FILL)

    self.pruneLoader = self.payload:Add("DPanel")
	self.pruneLoader:DockPadding(5, 5, 5, 5)
	self.pruneLoader:Dock(BOTTOM)

	self.header = self.payload:Add("DLabel")
	self.header:Dock(TOP)
	self.header:SetText('')
	self.header:SetTextColor(color_white)
	self.header:SetFont("ixBigFont")
	self.header:SetWrap(true)
	self.header:SetTall(SScaleMin(50/2))

    self.join = self.pruneLoader:Add("DButton")
	self.join:SetText('')
	self.join:Dock(FILL)
	self.join:SetTall(SScaleMin(35/2))
	self.join:SetVisible(false)
	self.join.Paint = function(this, w,h)
		surface.SetDrawColor( btnAccept ) 
		surface.DrawOutlinedRect( 0, 0, w, h, 1)
		if this:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, btnAcceptHover )
		end
	end
	self.join.DoClick = function(this)
        net.Start("ixPTRequest.Join")
            net.WriteInt(this.id, 12)
        net.SendToServer()
	end

    self.prune = self.pruneLoader:Add("DButton")
    self.prune:SetText('Сбросить ПГ')
    self.prune:Dock(FILL)
    self.prune:SetTall(SScaleMin(35/2))
    self.prune:SetVisible(false)
    self.prune.Paint = function(this, width, height)
        surface.SetDrawColor(btnClose)
        surface.DrawOutlinedRect( 0, 0, width, height, 1)
        if this:IsHovered() then
            draw.RoundedBox(0, 0, 0, width, height, btnCloseHover)
        end
	end
	self.prune.DoClick = function(this)
        net.Start("ixPTRequest.Leave")
        net.SendToServer()
        self:Remove()
        timer.Simple(0.1, recreate)
	end

    if !LocalPlayer():InPT() then
        self:CreatePT()
    end

    for id, data in ipairs(ix.patrolgroups.stored) do
        self.ptMenu = self.navbar:Add("DButton")
		self.ptMenu:SetText(Format("ПГ #%s", id))
		self.ptMenu:Dock(TOP)
		self.ptMenu:DockMargin(0, 0, 5, 5)
		self.ptMenu:SetTall(SScaleMin(35/2))

        if id == select(2, LocalPlayer():GetPT()) then
            self.ptMenu:SetText(Format("ПГ #%s - Активный", id))
            self.ptMenu.Paint = function(this, width, height)
                surface.SetDrawColor(Color(155, 255, 155))
                surface.DrawOutlinedRect(0, 0, width, height, 1)
                if this:IsHovered() then
                    draw.RoundedBox(0, 0, 0, width, height, Color(100, 200, 100))
                end
            end
        end

        self.ptMenu.DoClick = function()
            if id != select(2, LocalPlayer():GetPT()) then
                self.prune:SetVisible(false)
                self.join:SetVisible(true)
                self.join.id = id
                self.join:SetText("Присоединиться к ПГ #"..id)
            else
                for _, data in ipairs(ix.patrolgroups.stored) do
                    if data.owner == LocalPlayer() then
                        self.join:SetVisible(false)
                        self.prune:SetVisible(true)
                        break
                    end
                end
            end

            self.content:SetVisible(true)
            self.content:Clear()
            for _, client in ipairs(data.members) do
                if !IsValid(client) or !client:InPT() then continue end
                self.content:AddLine(client:Name(), client:GetPT().owner == client and "Лидер" or "Участник")
                self.content.OnRowSelected = function(lst, index, pnl)
                    local target = ix.util.FindPlayer(pnl:GetColumnText(1))
                    if !target then return end
                    if target == LocalPlayer() then return end
                    if LocalPlayer():GetPT().owner ~= LocalPlayer() then return end

                    if (IsValid(menu)) then
                        menu:Remove()
                    end

                    local menu = DermaMenu()
                        menu:AddOption("Исключить", function()
                            netstream.Start("ixPTRequest.Kick", tostring(target:SteamID()))
                            lst:RemoveLine(index)
                        end):SetImage("icon16/cancel.png")
                    menu:Open()
                end
            end

            self.header:SetText("Список ПГ #"..id)
            self.header:SizeToContents()
            surface.PlaySound("ui/buttonclick.wav")
        end
    end
end

function PANEL:CreatePT()
    self.create = self.navbar:Add("DButton")
    self.create:SetText("Создать ПГ")
    self.create:Dock(TOP)
    self.create:DockMargin(0, 0, 5, 5)
    self.create:SetTall( SScaleMin(35/2) )
    self.create.Paint = function(this, width, height)
        surface.SetDrawColor(Color(155, 255, 155))
        surface.DrawOutlinedRect(0, 0, width, height, 1)
        if this:IsHovered() then
            draw.RoundedBox(0, 0, 0, width, height, Color(100, 200, 100))
        end
    end
    self.create.DoClick = function(this)
        net.Start("ixPTRequest.Create")
        net.SendToServer()
        surface.PlaySound("ui/buttonclick.wav")
        self:Remove()
        timer.Simple(0.1, recreate)
    end
end

vgui.Register("ixPTMenu", PANEL, "Panel")
