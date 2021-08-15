
CAMI.RegisterPrivilege({
	Name = "Helix - Ability to set needs",
	MinAccess = "admin"
})

properties.Add("ixSetPrimaryNeeds.Nourishment", {
	MenuLabel = "#Set Nourishment",
	Order = 450,
	MenuIcon = "icon16/cake.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Ability to set needs", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Ability to set needs", nil)) then
			local entity = net.ReadEntity()
			client:RequestString("Set the nourishment to the player", "New Nourishment Level", function(text)
                local value = tonumber(text)
                if ( isnumber(value) and (value <= 100 and value >= 0) ) then
				    entity:GetCharacter():SetSatiety(value)
                    client:Notify( string.format('You set %s nourishment to %s', entity:Name(), value) )
                else
                    client:Notify('Invalid argument')
                end
			end, 0)
		end
	end
})

properties.Add("ixSetPrimaryNeeds.Hydration", {
	MenuLabel = "#Set Hydration",
	Order = 451,
	MenuIcon = "icon16/cup.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Ability to set needs", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Ability to set needs", nil)) then
			local entity = net.ReadEntity()
			client:RequestString("Set the hydration to the player", "New Hydration Level", function(text)
                local value = tonumber(text)
                if ( isnumber(value) and (value <= 100 and value >= 0) ) then
				    entity:GetCharacter():SetSaturation(value)
                    client:Notify( string.format('You set %s hydration to %s', entity:Name(), value) )
                else
                    client:Notify('Invalid argument')
                end
			end, 0)
		end
	end
})

do
    ix.command.Add("CharSetSatiety", {
        description = "Sets the satiety of a character.",
        privilege = "Primary Needs",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, client, target, amount)
            if !client:GetCharacter() then return end
            if target then
                if !amount then amount = 100 end
                local clamped = math.Round(math.Clamp(amount, 0, 100))
                target:SetSatiety(clamped)
            end
        end
    })

    ix.command.Add("CharSetSaturation", {
        description = "Sets the saturation of a character.",
        privilege = "Primary Needs",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, client, target, amount)
            if !client:GetCharacter() then return end
            if target then
                if !amount then amount = 100 end
                local clamped = math.Round(math.Clamp(amount, 0, 100))
                target:SetSaturation(clamped)
            end
        end
    })
end