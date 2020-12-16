ITEM.name = "Medicine"
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.description = "..."
ITEM.width = 1
ITEM.height = 1
ITEM.adminPills = false
ITEM.category = "Medicine"
ITEM.useSound = "items/medshot4.wav"
ITEM.healing = {}

ITEM.functions.Apply = {
	name = "Apply",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function(item)
		item.player:EmitSound(item.useSound, 70)

		if item.adminPills then
			ix.Diseases:RemoveAllDiseases(item.player)

			return true
		end

		ix.Diseases:DisinfectPlayer(item.player, item.healing)

		return true
	end,
}