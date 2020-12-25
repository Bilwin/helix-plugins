
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
ITEM.returnItems = {}

ITEM.functions.Apply = {
	name = "Use",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function( item )
		local pl = item.player

		if istable( item.useSound ) then
			ix.util.EmitQueuedSounds( pl, item.useSound, 0, 0.1, 70, 100)
		else
			pl:EmitSound( item.useSound, 70 )
		end

		if istable( item.returnItems ) then
			for _, v in ipairs( item.returnItems ) do
				pl:GetCharacter():GetInventory():Add( v )
			end
		else
			pl:GetCharacter():GetInventory():Add( item.returnItems )
		end

		if item.RestoreSaturation then
            ix.Hunger:RestoreSaturation( pl, tonumber( item.RestoreSaturation ) )
        end

        if item.RestoreSatiety then
            ix.Hunger:RestoreSatiety( pl, tonumber( item.RestoreSatiety ) )
        end

		return true
	end,
}
