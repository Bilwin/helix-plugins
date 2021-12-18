
local PLUGIN = PLUGIN
PLUGIN.name = "Detailed Descriptions"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds the ability for players to create detailed descriptions, which can be examined."
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

function PLUGIN:InitializedChatClasses()
	ix.command.Add("SelfExamine", {
		description = "Examines your description.",
		OnRun = function(self, client)
			local textEntryData = PLUGIN:GetDetailedDescription(client)['text'] or 'No detailed description found.'
			local textEntryDataURL = PLUGIN:GetDetailedDescription(client)['textEntryURL'] or 'No detailed description found.'

			netstream.Start(client, "ixOpenDetailedDescriptions", client, textEntryData, textEntryDataURL)
		end
	})

	ix.command.Add("CharDetDesc", {
		description = "Sets your description",
		OnRun = function(self, client)
			netstream.Start(client, "ixSetDetailedDescriptions")
		end
	})
end
