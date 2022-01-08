
local PANEL = {}

DEFINE_BASECLASS("EditablePanel")

function PANEL:Init()
    if IsValid(ix.gui.pdamainmenu) then
        ix.gui.pdamainmenu:Remove()
    end
    ix.gui.pdamainmenu = self

    self:SetSize(SScale(250), VScale(250))
    self:SetPos(5, (ScrH()*.5) - self:GetTall()/2)
    self:MakePopup()

    self.frame = self:Add("PDAFrame")
    self.frame:SetSize(self:GetWide(), self:GetTall())
    self.frame:SetPos(select(self:GetPos(), 1), select(self:GetPos(), 2))

    self.exit = self.frame:Add("DButton")
    self.exit:SetSize(self.frame:GetWide()/12, self.frame:GetTall()/16)
    self.exit:SetPos(SScaleMin(530/2), 0)
    self.exit:SetText('')
    self.exit.Paint = nil
    self.exit.DoClick = function()
        surface.PlaySound("buttons/lightswitch2.wav")
        self:Remove()
    end

    self.scroller = self.frame:Add("DHorizontalScroller")
    self.scroller:SetSize(self.frame:GetWide()/1.145, self.frame:GetTall()/18)
    self.scroller:SetPos(SScaleMin(45/2), SScaleMin(42/2))

    self.links = self.scroller:Add("DButton")
    self.links:SetSize(self.frame:GetWide()/7.5)
    self.links:SetPos(SScaleMin(45/2), SScaleMin(42/2))
    self.links:SetText('ССЫЛКИ')
    self.links:SetFont("ixPDAButton")
    self.links.DoClick = function()
        surface.PlaySound("ui/buttonclick.wav")
        self.linksmenu = DermaMenu()
            self.linksmenu:AddOption( "СПИСОК КОНТРАБАНДЫ И НАКАЗАНИЯ", function() gui.OpenURL('https://steamcommunity.com/groups/HalfLifeRP2/discussions/3/2242174386389137025/') end )
            self.linksmenu:AddOption( "ДИРЕКТОРИИ", function() gui.OpenURL('https://steamcommunity.com/groups/HalfLifeRP2/discussions/3/2242174386389052139/') end )
            self.linksmenu:AddOption( "ТЕН-КОДЫ", function() gui.OpenURL('https://steamcommunity.com/groups/HalfLifeRP2/discussions/3/2242174386389052459/') end )
        self.linksmenu:Open()
    end
    self.scroller:AddPanel(self.links)

    self.agenda = self.scroller:Add("DButton")
    self.agenda:SetSize(self.frame:GetWide()/8)
    self.agenda:SetPos(SScaleMin(45/2), SScaleMin(42/2))
    self.agenda:SetText('АГЕНДА')
    self.agenda:SetFont("ixPDAButton")
    self.agenda.DoClick = function()
        surface.PlaySound("ui/buttonclick.wav")
        if IsValid(ix.gui.pdamainmenu) then
            ix.gui.pdamainmenu:Remove(true)
        end
        vgui.Create("PDAAgenda")
    end
    self.scroller:AddPanel(self.agenda)

    self.patrolgroups = self.scroller:Add("DButton")
    self.patrolgroups:SetSize(self.frame:GetWide()/8)
    self.patrolgroups:SetPos(SScaleMin(45/2), SScaleMin(42/2))
    self.patrolgroups:SetText('МЕНЮ ПГ')
    self.patrolgroups:SetFont("ixPDAButton")
    self.patrolgroups.DoClick = function()
        surface.PlaySound("ui/buttonclick.wav")
        if IsValid(ix.gui.pdamainmenu) then
            ix.gui.pdamainmenu:Remove(true)
        end
        vgui.Create("PDAPatrolGroups")
    end
    self.scroller:AddPanel(self.patrolgroups)

    self.database = self.scroller:Add("DButton")
    self.database:SetSize(self.frame:GetWide()/6)
    self.database:SetPos(SScaleMin(45/2), SScaleMin(42/2))
    self.database:SetText('БАЗА ДАННЫХ')
    self.database:SetFont("ixPDAButton")
    self.database.DoClick = function()
        surface.PlaySound("ui/buttonclick.wav")
        if IsValid(ix.gui.pdamainmenu) then
            ix.gui.pdamainmenu:Remove(true)
        end
        vgui.Create("PDADatabase")
    end
    self.scroller:AddPanel(self.database)

    self.delta = self.frame:Add("Panel")
    self.delta:SetSize(self.frame:GetWide()*.875, self.frame:GetTall()*.78)
    self.delta:SetPos(SScaleMin(45/2), SScaleMin(69/2))
end

function PANEL:OnKeyCodePressed(button)
    if button == KEY_F1 then
        self:Remove()
    end
end

function PANEL:Remove(a)
    if !a then
        CloseDermaMenus()
        self:SetMouseInputEnabled(false)
        self:SetKeyboardInputEnabled(false)
        gui.EnableScreenClicker(false)
        self:MoveTo(-ScrW(), ScrH() / 2 - self:GetTall() / 2, 0.5, 0, -1, function()
            BaseClass.Remove(self)
        end)
    else
        BaseClass.Remove(self)
    end
end

vgui.Register("PDAMainMenu", PANEL, "Panel")
