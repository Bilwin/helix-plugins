
ITEM.name = "Foods"
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.description = "..."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Foods"
ITEM.useSound = "items/medshot4.wav"
ITEM.RestoreSaturation = 0
ITEM.RestoreSatiety = 0
ITEM.bDropOnDeath = true

ITEM.functions.Apply = {
	name = "Use",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function( item )
		item.player:EmitSound( item.useSound, 70 )

		if item.RestoreSaturation then
            ix.Hunger:RestoreSaturation( item.player, tonumber( item.RestoreSaturation ) )
        end

        if item.RestoreSatiety then
            ix.Hunger:RestoreSatiety( item.player, tonumber( item.RestoreSatiety ) )
        end

		return true
	end,
}
