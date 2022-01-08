
local PLUGIN = PLUGIN
PLUGIN.name = "Ранги, ОР для Гражданской Обороны"
PLUGIN.author = "Bilwin"
PLUGIN.blacklisted_ranks = {'rct', 'cdt'}

ix.util.Include("sh_config.lua")
ix.util.Include("sv_meta.lua")
ix.util.Include("sv_plugin.lua")

local meta = ix.meta.character
function meta:GetCPRank()
    return ix.ranks.stored[self:GetData("cmbRank", 1)]
end

function meta:GetCPPoint()
    return self:GetData("cmbSP", 0)
end

function PLUGIN:InitializedChatClasses()
	ix.command.Add("EditSP", {
		description = "Добавить очки ранга для сотрудника Г.О. или отнять.",
		arguments = {
			ix.type.character,
			ix.type.number,
		},
		OnCheckAccess = function(self, client)
			return client:IsCombine() and (client:GetCharacter():GetCPRank().IsCMD or false)
		end,
		OnRun = function(self, client, target, amount)
			if target:IsCombine() then
				if target:GetCPRank().IsCMD then return false, "Вы не можете изменить ОР для CmD!" end
				if target:GetFaction() == FACTION_ADMIN then return false, "Вы не можете изменить ОР для ГА!" end
				local stripped_amount = tostring(amount):find('-')
				local formatted_text
	
				if stripped_amount then
					amount = math.abs(amount)
					target:TakeCPPoint(amount)
	
					formatted_text = ix.util.FormatStringNamed("Вы успешно отняли {_amount} ОР для сотрудника {target}.", {
						_amount = amount,
						target = target:GetName()
					})
					client:Notify(formatted_text)
				else
					target:AddCPPoint(amount)
	
					formatted_text = ix.util.FormatStringNamed("Вы успешно выдали {_amount} ОР для сотрудника {target}.", {
						_amount = amount,
						target = target:GetName()
					})
					client:Notify(formatted_text)
				end
			else
				return false, "Ваша цель не состоит в Г.О."
			end
		end
	})
end

if CLIENT then
	function PLUGIN:CreateCharacterInfo(panel)
		if LocalPlayer():IsCombine() then
			panel.rank = panel:Add("ixListRow")
			panel.rank:SetList(panel.list)
			panel.rank:Dock(TOP)
			panel.rank:DockMargin(0, 0, 0, 8)
		end
	end

	function PLUGIN:UpdateCharacterInfo(panel)
		if LocalPlayer():IsCombine() then
			panel.rank:SetLabelText("Ранг")
			panel.rank:SetText(LocalPlayer():GetCharacter():GetCPRank().name)
			panel.rank:SizeToContents()
		end
	end
end