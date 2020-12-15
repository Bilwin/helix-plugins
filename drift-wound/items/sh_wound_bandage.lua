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
		local pl = itemTable.player
		local char = pl:GetCharacter()

		if math.random(5) > 2 then
			ix.Wounds:RemoveBleeding(pl)
		end

		pl:SetHealth(math.min(pl:Health() + 5, 100))
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

		if IsValid(target) and target:IsPlayer() then
			if target:GetCharacter() then
				if math.random(5) > 2 then
					ix.Wounds:RemoveBleeding(target)
				end

				target:SetHealth(math.min(target:Health() + 50, 100))
				return true
			end
		end

		return false
	end
}