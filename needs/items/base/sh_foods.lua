
ITEM.name = "Foods"
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.description = "..."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"

ITEM.useSound = "items/medshot4.wav"
ITEM.RestoreSaturation = 0
ITEM.RestoreSatiety = 0
ITEM.returnItems = {}

function ITEM:OnInstanced(invID, x, y, item)
	if item then
		item:SetData("remaining", item.RemainingDefault)
	end
end

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter( "name", "remaining" )
		panel:SetBackgroundColor( Color(75, 50, 50) )
		panel:SetText( "Remaining: " .. self:GetData("remaining", 4) )
		panel:SetFont("ixFontNoClamp")
		panel:SizeToContents()
	end
end

ITEM.functions.Consume = {
	name = "Consume",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function( item )
		local client = item.player
		local char = client:GetCharacter()

		if istable( item.useSound ) then
			ix.util.EmitQueuedSounds( client, item.useSound, 0, 0.1, 70, 100)
		else
			client:EmitSound( item.useSound, 70 )
		end

		if istable( item.returnItems ) then
			for _, v in ipairs( item.returnItems ) do
				char:GetInventory():Add( v )
			end
		else
			char:GetInventory():Add( item.returnItems )
		end

		if (item.RestoreSaturation) then
			char:RestoreSaturation( item.RestoreSaturation/item:GetData("remaining", 4) )
        end

        if (item.RestoreSatiety) then
			char:RestoreSatiety( item.RestoreSatiety/item:GetData("remaining", 4) )
        end

		item:SetData("remaining", item:GetData("remaining", 4) - 1)

		if item:GetData("remaining", 4) <= 0 then
			return true
		end

		return false
	end,
	OnCanRun = function(item)
		local factionTable = ix.faction.indices[item.player:Team()] or {}
		return (factionTable.includeNeeds or false)
	end
}