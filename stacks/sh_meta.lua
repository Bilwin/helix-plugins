
local INVENTORY = ix.meta.inventory

function INVENTORY:GetStackCount(uniqueID)
	local originalList = ix.item.list[uniqueID]
	local bIsStacking = originalList.base == 'base_stackable'
	if (originalList and bIsStacking) then
		local stackedCount = 0
		for _, v in ipairs(self:GetItemsByUniqueID(uniqueID)) do
			local realCount = v['data'].stacks or 1
			stackedCount = stackedCount + realCount
		end
		return tonumber(stackedCount)
	else
		return 0
	end
end

-- Rewrite original helix INVENTORY:GetItemCount function
function INVENTORY:GetItemCount(uniqueID, onlyMain)
	local originalList = ix.item.list[uniqueID]
	local bIsStacking = originalList.base == 'base_stackable'
	local i = 0

	if (bIsStacking) then
		i = self:GetStackCount(uniqueID)
	else
		for _, v in pairs( self:GetItems(onlyMain) ) do
			if (v.uniqueID == uniqueID) then
				i = i + 1
			end
		end
	end

	return i
end