

ITEM.name = 'Extended Outfit'
ITEM.description = 'A generic piece of clothing.'
ITEM.model = Model('models/props_c17/BriefCase001a.mdl')
ITEM.category = 'Outfits'

if CLIENT then
	function ITEM:PaintOver(item, w, h)
		if item:GetData('equip', false) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
		end
	end

	function ITEM:PopulateTooltip(tooltip)
		if self:GetData('equip') then
			local name = tooltip:GetRow('name')
			name:SetBackgroundColor(derma.GetColor('Success', tooltip))
		end

		if self.maxArmor then
			local panel = tooltip:AddRowAfter('name', 'armor')
			panel:SetBackgroundColor(derma.GetColor('Warning', tooltip))
			panel:SetText('Armor: ' .. (self:GetData('equip', false) && LocalPlayer():Armor() || self:GetData('armor', self.maxArmor)))
			panel:SizeToContents()
		end
	end
end

function ITEM:RemoveOutfit(client)
	self:SetData('equip', false)
	if self.maxArmor then
		self:SetData('armor', math.Clamp(client:Armor(), 0, self.maxArmor))
		client:SetArmor(0)
	end

	for k in pairs(self.bodyGroups) do
		local index = client:FindBodygroupByName(k)
		local char = client:GetCharacter()
		local groups = char:GetData('groups', {})

		if index > -1 then
			groups[index] = 0
			char:SetData('groups', groups)
			client:SetBodygroup(index, 0)
		end
	end

	client:EmitSound('npc/footsteps/softshoe_generic6.wav')
end

ITEM:Hook('drop', function(item)
	if item:GetData('equip', false) then
		item:RemoveOutfit(item:GetOwner())
	end
end)

ITEM.functions.Repair = {
	name = 'Repair',
	tip = 'repairTip',
	icon = 'icon16/wrench.png',
	OnRun = function(item)
		item:Repair(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		return (item.maxArmor != nil && item:GetData('equip') == false && !IsValid(item.entity) && IsValid(client) && client:GetCharacter():GetInventory():HasItem('tool_repair') && item:GetData('armor') < item.maxArmor)
	end
}

ITEM.functions.EquipUn = {
	name = 'Un-equip',
	tip = 'equipTip',
	icon = 'icon16/cross.png',
	OnRun = function(item)
		if (item.player) then
			item:RemoveOutfit(item.player)

			if item.OnUnEquip then
				item:OnUnEquip()
			end
		else
			item:SetData('equip', false)

			if item.OnUnEquip then
				item:OnUnEquip()
			end
		end
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) && IsValid(client) && item:GetData('equip') == true &&
			hook.Run('CanPlayerUnequipItem', client, item) != false && item:CanUnequipOutfit()
	end
}

ITEM.functions.Equip = {
	name = 'Equip',
	tip = 'equipTip',
	icon = 'icon16/tick.png',
	OnRun = function(item, creationClient)
		local client = item.player || creationClient
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()
		local groups = char:GetData('groups', {})

		if (item.maxArmor) then
			client:SetArmor(item:GetData('armor', item.maxArmor))
		end

		-- Checks if any [Torso] is already equipped.
		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (v.outfitCategory == item.outfitCategory && itemTable:GetData('equip')) then
					client:NotifyLocalized(item.equippedNotify || 'outfitAlreadyEquipped')
					return false
				end
			end
		end

		item:SetData('equip', true)

		if (item.bodyGroups) then
			for k, value in pairs(item.bodyGroups) do
				local index = client:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
					char:SetData('groups', groups)
					client:SetBodygroup(index, value)

					if item.OnEquip then
						item:OnEquip(client)
					end
				end
			end
		end

		client:EmitSound('npc/footsteps/softshoe_generic6.wav')
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		if item.factionList && !table.HasValue(item.factionList, client:GetCharacter():GetFaction()) then
			client:NotifyLocalized('You can\'t equip this outfit!')
			return false
		end

		return !IsValid(item.entity) && IsValid(client) && item:GetData('equip') != true &&
			hook.Run('CanPlayerEquipItem', client, item) != false && item:CanEquipOutfit()
	end
}

function ITEM:Repair(client, amount)
	amount = amount || self.maxArmor
	local repairItem = client:GetCharacter():GetInventory():HasItem('tool_repair')

	if (repairItem) then
		repairItem:Remove()
		self:SetData('armor', math.Clamp(self:GetData('armor') + amount, 0, self.maxArmor))
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory && self:GetData('equip')) then
		return false
	end

	return true
end

function ITEM:OnInstanced()
	if (self.maxArmor) then
		self:SetData('armor', self.maxArmor)
	end
end

function ITEM:OnRemoved()
	if (self.invID != 0 && self:GetData('equip')) then
		self.player = self:GetOwner()
		self:RemoveOutfit(self.player)

		if self.OnUnEquip then
			self:OnUnEquip()
		end

		self.player = nil
	end
end

function ITEM:OnLoadout()
	if (self.maxArmor && self:GetData('equip')) then
		self.player:SetArmor(self:GetData('armor', self.maxArmor))
	end
end

function ITEM:OnSave()
	if (self.maxArmor && self:GetData('equip')) then
		self:SetData('armor', math.Clamp(self.player:Armor(), 0, self.maxArmor))
	end
end

function ITEM:CanEquipOutfit()
	if (self.maxArmor) then
		local outfits = self.player:GetCharacter():GetInventory():GetItemsByBase('base_newoutfit', true)
		for _, v in next, outfits do
			if (v:GetData('equip') && v.maxArmor) then
				return false
			end
		end
	end

	return true
end

function ITEM:CanUnequipOutfit()
	return true
end