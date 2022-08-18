
local Schema = Schema

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "dispatch", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Dispatch", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.alias = "R"
	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		if !character then return end
		local radios = character:GetInventory():GetItemsByUniqueID("handheld_radio", true)
		local item

		for k, v in ipairs(radios) do
			if (v:GetData("enabled", false)) then
				item = v
				break
			end
		end

		if (item) then
			if (!client:IsRestricted()) then
				ix.chat.Send(client, "radio", message)
				ix.chat.Send(client, "radio_eavesdrop", message)
			else
				return "@notNow"
			end
		elseif (#radios > 0) then
			return "@radioNotOn"
		else
			return "@radioRequired"
		end
	end

	ix.command.Add("Radio", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.number

	function COMMAND:OnRun(client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("handheld_radio")

		if (itemTable) then
			if (string.find(frequency, "^%d%d%d%.%d$")) then
				character:SetData("frequency", frequency)
				itemTable:SetData("frequency", frequency)

				client:Notify(string.format("Вы установили частоту %s.", frequency))
			end
		end
	end

	ix.command.Add("SetFreq", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		if (inventory:HasItem("request_device") or client:IsCombine() or client:Team() == FACTION_ADMIN) then
			if (!client:IsRestricted()) then
				Schema:AddCombineDisplayMessage("@cRequest")

				ix.chat.Send(client, "request", message)
				ix.chat.Send(client, "request_eavesdrop", message)
			else
				return "@notNow"
			end
		else
			return "@needRequestDevice"
		end
	end

	ix.command.Add("Request", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "broadcast", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Broadcast", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:IsRestricted()) then
			if (!client:IsRestricted()) then
				Schema:SearchPlayer(client, target)
			else
				return "@notNow"
			end
		end
	end

	ix.command.Add("CharSearch", COMMAND)
end

do
	ix.command.Add("BecomeClass", {
		description = "@cmdBecomeClass",
		arguments = ix.type.text,
		OnCheckAccess = function(self, client)
			return false
		end,
		OnRun = function(self, client, class)
			return "@notNow"
		end
	})
end