
PLUGIN.name = "Languages"
PLUGIN.author = "Bilwin"
PLUGIN.version = 1.01
PLUGIN.schema = "Any"

ix.util.Include("sh_languages.lua")
ix.util.Include("sh_meta.lua")

ix.char.RegisterVar("additionalLanguages", {
	field = "additionalLanguages",
	fieldType = ix.type.string,
	bNetworked = true,
	bNoDisplay = true
})

function PLUGIN:InitializedChatClasses()
	ix.command.Add("CharAddLanguage", {
		description = "Let the specified player speak the specified language",
		adminOnly = true,
		arguments = {ix.type.character, ix.type.string},
		OnRun = function(self, client, character, language)
			if character and IsValid(character:GetPlayer()) then
				if ix.languages:GetAll()[language] then
					character:AddLanguage(language)
					client:Notify('Character '..character:GetName()..' ('..character:GetPlayer():SteamID()..') successfully issued knowledge of the language: '..ix.languages:GetAll()[language].name)
				else
					client:Notify('The specified language was not found.')
				end
			else
				client:Notify('There is no such player')
			end
		end
	})

	ix.command.Add("CharRemoveLanguage", {
		description = "Take away from the specified character the ability to speak the specified language",
		adminOnly = true,
		arguments = {ix.type.character, ix.type.string},
		OnRun = function(self, client, character, language)
			if character and IsValid(character:GetPlayer()) then
				if ix.languages:GetAll()[language] then
					character:RemoveLanguage(language)
					client:Notify('You have successfully removed the ability to speak in '..ix.languages:GetAll()[language].name..' language to the character '..character:GetName()..' ('..character:GetPlayer():SteamID()..')')
				else
					client:Notify('The specified language was not found.')
				end
			else
				client:Notify('There is no such player')
			end
		end
	})
end
