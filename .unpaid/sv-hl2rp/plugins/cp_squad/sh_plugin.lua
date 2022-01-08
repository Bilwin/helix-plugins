
local PLUGIN = PLUGIN
PLUGIN.name = "Отряды для Гражданской Обороны"
PLUGIN.author = "Bilwin"
PLUGIN.blacklisted_ranks = {'rct', 'cdt'}

local CHAR = ix.meta.character
function CHAR:GetSquad()
    return self:GetData("cmbSquad", 'gu')
end

if CLIENT then
	function PLUGIN:CreateCharacterInfo(panel)
		if (LocalPlayer():IsCombine()) then
			panel.squad = panel:Add("ixListRow")
			panel.squad:SetList(panel.list)
			panel.squad:Dock(TOP)
			panel.squad:DockMargin(0, 0, 0, 8)
		end
	end

	function PLUGIN:UpdateCharacterInfo(panel)
		if (LocalPlayer():IsCombine()) then
			panel.squad:SetLabelText("Отряд")
			panel.squad:SetText(ix.squads.stored[LocalPlayer():GetCharacter():GetSquad()].name)
			panel.squad:SizeToContents()
		end
	end
end

ix.util.Include("sv_meta.lua")
ix.util.Include("sv_plugin.lua")