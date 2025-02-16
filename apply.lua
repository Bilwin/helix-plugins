PLUGIN.name 	= '/Apply chat command'
PLUGIN.author 	= 'Bilwin'

local netName = ('%s - Recognize'):format(PLUGIN.name)
function PLUGIN:InitializedChatClasses()
	ix.command.Add('Apply', {
		description = 'Introduce yourself',
		OnRun = function(_, client)
			local char = client:GetCharacter()
			if not char then return end
			local cid = char:GetInventory():HasItem('cid')
	
			if cid then
				ix.chat.Send(client, 'ic', cid:GetData('name', 'N/A') .. ', #' .. cid:GetData('id', 'N/A'))
			else
				ix.chat.Send(client, 'ic', char:GetName())
			end

			net.Start(netName, true)
			net.Send(client)
		end
	})
end

if CLIENT then
	net.Receive(netName, function()
		net.Start('ixRecognize', true)
			net.WriteUInt(2, 2)
		net.SendToServer()
	end)
end