
local PLUGIN = PLUGIN

function PLUGIN:DoPlayerDeath(client, attacker, damageinfo)
	local character = client:GetCharacter() if !character then return end
	for _, v in next, character:GetInventory():GetItems() do
		if v:GetData('equip', false) && ((isfunction(v.bKeepOnDeath) && v:KeepOnDeath(client) || v.bKeepOnDeath) == true) then return end

		if v.base == 'base_newoutfit' && v:GetData('equip', false) == true then
			v.player = client
			v.functions.EquipUn.OnRun(v)
			v.player = nil
		end
	end
end

function PLUGIN:PostPlayerDeath(client)
	local character = client:GetCharacter() if !character then return end
	local inventory = character:GetInventory() if !inventory then return end
	local groups = {}

	for _, v in next, inventory:GetItems() do
		if v:GetData('equip', false) && ((isfunction(v.bKeepOnDeath) && v:bKeepOnDeath(client) || v.bKeepOnDeath) == true) then return end

		if v.base == "base_newoutfit" && v:GetData("equip") == true then
			if v.bodyGroups then
				if v.bodyGroups[1] then
					local bodygroupID = client:FindBodygroupByName(v.bodyGroups[1])
					client:SetBodygroup(bodygroupID, 0)
					if bodygroupID then
						groups[bodygroupID] = 0
					end
				end
			end
		end
	end

	character:SetData('groups', groups)
end