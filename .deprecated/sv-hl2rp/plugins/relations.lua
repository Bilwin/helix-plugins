
local PLUGIN = PLUGIN
PLUGIN.name = "NPC Relations"
PLUGIN.author = "Gr4ss"
PLUGIN.description = "Allows easy setting of NPC relations."

if (SERVER) then
	function PLUGIN:OnEntityCreated(entity)
		if (entity:IsNPC()) then
			for _, client in ipairs(player.GetAll()) do
				local charplayer = client:GetCharacter()

				if (charplayer) then
					local faction = ix.faction.indices[charplayer:GetFaction()]

					if (faction and faction.npcRelations) then
						entity:AddEntityRelationship(client, faction.npcRelations[entity:GetClass()] or D_HT, 0)
					end
				end
			end
		end
	end

	function PLUGIN:PlayerSpawn(client)
		local charplayer = client:GetCharacter()

		if (charplayer) then
			local faction = ix.faction.indices[charplayer:GetFaction()]
			local relations = faction.npcRelations

			if (relations) then
				for _, entity in ipairs(ents.GetAll()) do
					if (entity:IsNPC() and relations[entity:GetClass()]) then
						entity:AddEntityRelationship(client, relations[entity:GetClass()], 0)
					end
				end
			else
				for _, entity in ipairs(ents.GetAll()) do
					if (entity:IsNPC()) then
						entity:AddEntityRelationship(client, D_HT, 0)
					end
				end
			end
		end
	end
end
