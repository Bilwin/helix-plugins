
local PLUGIN = PLUGIN
local endsWith = string.EndsWith
local tostring = tostring

if !file.Exists('helix/detailedescription', 'DATA') then
	file.CreateDir('helix/detailedescription')
end

netstream.Hook("ixEditDetailedDescriptions", function(client, text, textEntryURL)
	local character = client:GetCharacter()
	if (character) then
		if (utf8.len(text) > 3000) or (utf8.len(textEntryURL) > 50) then return end

		local characterData = {
			['text'] = text or 'No detailed description found.',
			['textEntryURL'] = textEntryURL or 'No detailed description found.'
		}

		PLUGIN:CreateDetailedDescription(client, characterData)
	end
end)

netstream.Hook('RequestDetailedDescription', function(client)
	if IsValid(client) and client:GetCharacter() then
		local data = PLUGIN:GetDetailedDescription(client)
		netstream.Start(client, 'ReturnDetailedDescription', data)
	end
end)

function PLUGIN:OnPlayerOptionSelected(client, callingClient, option)
	if (option == "Examine") then
		local text = self:GetDetailedDescription(client)['text'] or 'No detailed description found.'
		local textURL = self:GetDetailedDescription(client)['textEntryURL'] or 'No detailed description found.'
		netstream.Start(callingClient, "ixOpenDetailedDescriptions", client, text, textURL)
	end
end

function PLUGIN:CreateDetailedDescription(client, data)
	if (file.Exists('helix/detailedescription/'..client:GetCharacter():GetID()..'.json', 'DATA')) then
		file.Delete('helix/detailedescription/'..client:GetCharacter():GetID()..'.json')
		local compressed = util.TableToJSON(data)
		file.Write('helix/detailedescription/'..client:GetCharacter():GetID()..'.json', compressed)
	else
		local compressed = util.TableToJSON(data)
		file.Write('helix/detailedescription/'..client:GetCharacter():GetID()..'.json', compressed)
	end
end

function PLUGIN:GetDetailedDescription(client)
	if (file.Exists('helix/detailedescription/'..client:GetCharacter():GetID()..'.json', 'DATA')) then
		local compressed = file.Read('helix/detailedescription/'..client:GetCharacter():GetID()..'.json', 'DATA')
		local uncompressed = util.JSONToTable(compressed)
		return uncompressed
	else
		return {
			['text'] = 'No detailed description found.',
			['textEntryURL'] = 'No detailed description found.'
		}
	end
end