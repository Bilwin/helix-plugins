
PLUGIN.name = "Languages"
PLUGIN.author = "Bilwin"
PLUGIN.version = 1.0
PLUGIN.schema = "Any"
PLUGIN.license = [[
    This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.
    In jurisdictions that recognize copyright laws, the author or authors
    of this software dedicate any and all copyright interest in the
    software to the public domain. We make this dedication for the benefit
    of the public at large and to the detriment of our heirs and
    successors. We intend this dedication to be an overt act of
    relinquishment in perpetuity of all present and future rights to this
    software under copyright law.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
    For more information, please refer to <http://unlicense.org/>
]]

ix.char.RegisterVar("additionalLanguages", {
	field = "additionalLanguages",
	fieldType = ix.type.string,
	bNetworked = true,
	bNoDisplay = true
})

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

ix.util.Include("sh_languages.lua")
ix.util.Include("sh_meta.lua")