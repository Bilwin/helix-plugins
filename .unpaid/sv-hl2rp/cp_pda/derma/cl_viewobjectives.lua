
hook.Add("LoadFonts", "ixCombineViewObjectives", function()
	surface.CreateFont("ixCombineViewObjectives", {
		font = "Courier New",
		size = 16,
		antialias = true,
		weight = 400
	})
end)

DEFINE_BASECLASS("EditablePanel")

local PANEL = {}

local animationTime = 1
AccessorFunc(PANEL, "bCommitOnClose", "CommitOnClose", FORCE_BOOL)

function PANEL:Init()
	if IsValid(ix.gui.objectivesMenu) then
        ix.gui.objectivesMenu:Remove()
    end
	ix.gui.objectivesMenu = self
	self:SetCommitOnClose(true)
	self.nameLabel = vgui.Create("DLabel", self)
	self.nameLabel:SetFont("BudgetLabel")
	self.nameLabel:SizeToContents()
	self.nameLabel:Dock(TOP)

	self.dateLabel = vgui.Create("DLabel", self)
	self.dateLabel:SetFont("BudgetLabel")
	self.dateLabel:SizeToContents()
	self.dateLabel:Dock(TOP)

	self.textEntry = vgui.Create("DTextEntry", self)
	self.textEntry:SetMultiline(true)
	self.textEntry:Dock(FILL)
	self.textEntry:SetFont("ixCombineViewObjectives")
end

function PANEL:Populate(data, bDontShow)
	data = data or {}

	self.oldText = data.text or ""

	local date = data.lastEditDate and ix.date.Construct(data.lastEditDate):format("%Y/%m/%d - %H:%M:%S") or L("unknown")

	self.nameLabel:SetText(string.format("%s: %s", "РЕДАКТИРОВАЛ", data.lastEditPlayer or L("unknown")):upper())
	self.dateLabel:SetText(string.format("%s: %s", "ДАТА ПОСЛЕДНЕГО РЕДАКТИРОВАНИЯ", date):upper())
	self.textEntry:SetText(data.text or "")

	if (!hook.Run("CanPlayerEditObjectives", LocalPlayer())) then
		self.textEntry:SetEnabled(false)
	end

	self:SetMouseInputEnabled(true)
	self:SetKeyBoardInputEnabled(true)
end

function PANEL:CommitChanges()
	local text = string.Trim(self.textEntry:GetValue():sub(1, 2000))

	-- only update if there's something different so we can preserve the last editor if nothing changed
	if (self.oldText != text) then
		netstream.Start("ViewObjectivesUpdate", text)

		local date = ix.date.Get()
		local data = {
			text = text:sub(1, 1000),
			lastEditPlayer = LocalPlayer():GetCharacter():GetName(),
			lastEditDate = ix.date.GetSerialized(date)
		}

		PDAObjectives = data

		Schema:AddCombineDisplayMessage("@cViewObjectivesUpdate")
	end
end

vgui.Register("ixViewObjectives", PANEL, "EditablePanel")
