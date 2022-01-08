
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
    self.scroller:SetSize(self.frame:GetWide(), self.frame:GetTall()/18)
    self.scroller:SetPos(SScaleMin(45/2), SScaleMin(42/2))

    self.backtomenu = self.scroller:Add("DButton")
    self.backtomenu:SetSize(self.frame:GetWide()/8)
    self.backtomenu:SetPos(SScaleMin(45/2), SScaleMin(42/2))
    self.backtomenu:SetText('НАЗАД')
    self.backtomenu:SetFont("ixPDAButton")
    self.backtomenu.DoClick = function()
        surface.PlaySound("ui/buttonclick.wav")
        if IsValid(ix.gui.pdamainmenu) then
            ix.gui.pdamainmenu:Remove(true)
        end
        vgui.Create("PDAMainMenu")
    end
    self.scroller:AddPanel(self.backtomenu)

    if hook.Run("CanPlayerEditObjectives", LocalPlayer()) then
        self.savechanges = self.scroller:Add("DButton")
        self.savechanges:SetSize(self.frame:GetWide()/8)
        self.savechanges:SetPos(SScaleMin(45/2), SScaleMin(42/2))
        self.savechanges:SetText('СОХРАНИТЬ')
        self.savechanges:SetFont("ixPDAButton")
        self.savechanges.DoClick = function()
            if IsValid(ix.gui.objectivesMenu) then
                ix.gui.objectivesMenu:CommitChanges()
                surface.PlaySound "ui/buttonclickrelease.wav"
                ix.gui.objectivesMenu:Remove()
                if IsValid(self.delta) then
                    ix.gui.objectivesMenu = self.delta:Add("ixViewObjectives")
                    ix.gui.objectivesMenu:Dock(FILL)
                    ix.gui.objectivesMenu:Populate(PDAObjectives)
                end
            end
        end
        self.scroller:AddPanel(self.savechanges)
    end

    self.delta = self.frame:Add("Panel")
    self.delta:SetSize(self.frame:GetWide()*.875, self.frame:GetTall()*.78)
    self.delta:SetPos(SScaleMin(45/2), SScaleMin(69/2))

    self.objectives = self.delta:Add("ixViewObjectives")
    self.objectives:Dock(FILL)
    self.objectives:Populate(PDAObjectives)
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

vgui.Register("PDAAgenda", PANEL, "EditablePanel")
