
local _math_clamp = math.Clamp
local _math_ceil = math.ceil
ITEM.name = "Еда"
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Еда"

ITEM.useSound = "items/medshot4.wav"
ITEM.thirst = 0
ITEM.hunger = 0
ITEM.items = {}

function ITEM:OnInstanced(invID, x, y, item)
	if item then
		item:SetData("remaining", item.RemainingDefault)
	end
end

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter( "name", "remaining" )
		panel:SetText( "Осталось: " .. self:GetData("remaining", 4) )
		panel:SizeToContents()
	end
end

ITEM.functions.Consume = {
	name = "Употребить",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function( item )
		local client = item.player
		local character = client:GetCharacter()

		if istable( item.useSound ) then
			ix.util.EmitQueuedSounds( client, item.useSound, 0, 0.1, 70, 100)
		else
			client:EmitSound( item.useSound, 70 )
		end

		if (item.thirst) then
			local separated_thirst = tostring(item.thirst)
			local thirst_multiplier = hook.Run("ThirstGainMultiplier", client, character, item) or 1
			if separated_thirst:find('-') then
				local clean_thirst = tonumber(string.Replace(separated_thirst, '-', ''))
				character:SetThirst( _math_clamp(_math_ceil(character:GetThirst() + (clean_thirst*thirst_multiplier)), 0, 100) )
			else
				character:SetThirst( _math_clamp(_math_ceil(character:GetThirst() - (item.thirst*thirst_multiplier)), 0, 100) )
			end
        end

        if (item.hunger) then
			local separated_hunger = tostring(item.hunger)
			local hunger_multiplier = hook.Run("HungerGainMultiplier", client, character, item) or 1
			if separated_hunger:find('-') then
				local clean_hunger = tonumber(string.Replace(separated_hunger, '-', ''))
				character:SetHunger( _math_clamp(_math_ceil(character:GetHunger() + (clean_hunger*hunger_multiplier)), 0, 100) )
			else
				character:SetHunger( _math_clamp(_math_ceil(character:GetHunger() - (item.hunger*hunger_multiplier)), 0, 100) )
			end
        end

		if (item.OnAte) then
			item.OnAte(client, character)
		end

		hook.Run("OnCharacterAteFood", client, character, item)

		item:SetData("remaining", item:GetData("remaining", 4) - 1)

		if item:GetData("remaining", 4) <= 0 then
			if istable( item.items ) then
				for _, v in ipairs( item.items ) do
					character:GetInventory():Add( v )
				end
			else
				character:GetInventory():Add( item.items )
			end
			return true
		end

		return false
	end,
	OnCanRun = function(item)
		local factionTable = ix.faction.indices[item.player:Team()] or {}
		return (!factionTable.excludeNeeds or false)
	end
}