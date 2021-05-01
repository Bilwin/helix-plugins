
local PLUGIN = PLUGIN
ITEM.name = "Splint"
ITEM.model = Model("models/props_c17/furnituredrawer001a_shard01.mdl")
ITEM.description = "A splint is a rigid or flexible device that maintains in position a displaced or movable part, also used to keep in place and protect an injured part to support healing and to prevent further damage."
ITEM.category = "Medical"
ITEM.price = 25

ITEM.functions.Apply = {
	name = "Heal yourself",
	icon = "icon16/heart.png",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		PLUGIN:SetFracture(client, false)
	end
}

ITEM.functions.ApplyTarget = {
	name = "Heal the person opposite",
	icon = "icon16/heart_add.png",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local pl = itemTable.player
		local data = {}
			data.start = pl:GetShootPos()
			data.endpos = data.start + pl:GetAimVector() * 96
			data.filter = pl
		local target = util.TraceLine(data).Entity

		if target:IsValid() and target:IsPlayer() then
			PLUGIN:SetFracture(target, false)
			return true
		end

		return false
	end
}