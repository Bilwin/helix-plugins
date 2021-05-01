
local PLUGIN = PLUGIN
ITEM.name = "Bandage"
ITEM.model = Model("models/props_wasteland/prison_toiletchunk01l.mdl")
ITEM.description = "Small roll of gauze cloth."
ITEM.category = "Medical"
ITEM.price = 18

ITEM.functions.Apply = {
	name = "Heal yourself",
	icon = "icon16/heart.png",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player
		PLUGIN:SetBleeding(client, false)
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
			PLUGIN:SetBleeding(target, false)
			return true
		end

		return false
	end
}