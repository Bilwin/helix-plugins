
local PLUGIN = PLUGIN

PLUGIN.hungerSounds = {
    [1] = 'npc/barnacle/barnacle_digesting1.wav',
    [2] = 'npc/barnacle/barnacle_digesting2.wav'
}

function PLUGIN:CharacterVarChanged(character, key, oldVar, value)
	if key == 'thirst' then
		if value <= 10 then end
	elseif key == 'hunger' then
		if value <= 10 then end
	end
end

function PLUGIN:CreateNeedsTimer(client, character, uniqueID)
	if timer.Exists(uniqueID) then timer.Remove(uniqueID) end
	timer.Create(uniqueID, ix.config.Get("needsTickTime", 300), 0, function()
		if !IsValid(client) then
			return
		end

		if hook.Run("ShouldCalculatePlayerNeeds", client, character) == false then
			return
		end

		local scale = 1
		local count = math.max(character:GetInventory():GetFilledSlotCount(), 0) / 30
		local vcsqr = client:GetVelocity():LengthSqr()
		local walkSpeed = ix.config.Get("walkSpeed")

		if (!(client:GetMoveType() == MOVETYPE_NOCLIP) and client:KeyDown(IN_SPEED) and (vcsqr >= (walkSpeed * walkSpeed))) then
			scale = scale + count
		elseif (vcsqr > 0) then
			scale = scale + count * 0.3
		else
			scale = scale + count * 0.1
		end

		if (client:Health() < 90) then
			scale = scale + 0.2
		end

		local tickTime = ix.config.Get("needsTickTime", 300)

		local hunger = math.ceil(math.Clamp(character:GetHunger() + 60 * scale * tickTime / (3600 * ix.config.Get("hungerHours", 6)), 0, 100))
		local thirst = math.ceil(math.Clamp(character:GetThirst() + 60 * scale * tickTime / (3600 * ix.config.Get("thirstHours", 4)), 0, 100))

		character:SetHunger(hunger)
		character:SetThirst(thirst)

        if hunger >= 90 then
            client:EmitSound( self.hungerSounds[math.random(#self.hungerSounds)] )
        end

		if ix.config.Get("decreaseCharacterHealthOnFullNeeds", false) then
			if (hunger >= 100) then
				client:SetHealth(client:Health() - 5)

				if client:Health() <= 0 then
					client:Kill()
				end
			end

			if (thirst >= 100) then
				client:SetHealth(client:Health() - 3)

				if client:Health() <= 0 then
					client:Kill()
				end
			end
		end
	end)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
	local uniqueID = "ixPrimaryNeeds." .. client:AccountID()
	if hook.Run("ShouldCalculatePlayerNeeds", client, character) == false then return end
	self:CreateNeedsTimer(client, character, uniqueID)
	self:CharacterVarChanged(character, 'hunger', character:GetHunger(), character:GetHunger())
	self:CharacterVarChanged(character, 'thirst', character:GetThirst(), character:GetThirst())
end

function PLUGIN:ShouldCalculatePlayerNeeds(client, character)
	local faction = ix.faction.indices[character:GetFaction()]

	if faction.excludeNeeds then
		return false
	end

	if (client:GetMoveType() == MOVETYPE_NOCLIP) then
		return false
	end
end

function PLUGIN:DoPlayerDeath(client)
    local character = client:GetCharacter()
    if ( IsValid(client) and character ) then
        local defaultHunger = ix.char.vars["hunger"].default or 30
        local defaultThirst = ix.char.vars["thirst"].default or 30
        character:SetHunger(defaultHunger)
        character:SetThirst(defaultThirst)
    end
end

function PLUGIN:PlayerDisconnected(client)
    local uniqueID = client:AccountID()
    if timer.Exists('ixPrimaryNeeds.'..uniqueID) then
        timer.Remove('ixPrimaryNeeds.'..uniqueID)
    end
end