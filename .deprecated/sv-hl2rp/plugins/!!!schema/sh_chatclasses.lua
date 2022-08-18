
local Schema = Schema

do
	local CLASS = {}
	CLASS.color = Color(150, 100, 100)
	CLASS.format = "Центр сообщает \"%s\""

	function CLASS:CanSay(speaker, text)
		if (!speaker:IsDispatch()) then
			speaker:NotifyLocalized("notAllowed")

			return false
		end
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, text))
	end

	ix.chat.Register("dispatch", CLASS)
end

do
	local CLASS = {}
	CLASS.color = Color(99, 166, 228)
	CLASS.format = "[%s] %s говорит в рацию \"%s\""

	function CLASS:CanHear(speaker, listener)
		local character = listener:GetCharacter()
		local inventory = character:GetInventory()
		local bHasRadio = false

		for k, v in pairs(inventory:GetItemsByUniqueID("handheld_radio", true)) do
			if (v:GetData("enabled", false) and speaker:GetCharacter():GetData("frequency") == character:GetData("frequency")) then
				bHasRadio = true
				break
			end
		end

		return bHasRadio
	end

	function CLASS:OnChatAdd(speaker, text)
		text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
		local frequency = speaker:GetCharacter():GetData("frequency")
		chat.AddText(self.color, string.format(self.format, frequency, speaker:Name(), text))
	end

	ix.chat.Register("radio", CLASS)
end

do
	local CLASS = {}
	CLASS.color = Color(255, 255, 175)
	CLASS.format = "%s говорит в рацию \"%s\""

	function CLASS:GetColor(speaker, text)
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return Color(175, 255, 175)
		end

		return self.color
	end

	function CLASS:CanHear(speaker, listener)
		if (ix.chat.classes.radio:CanHear(speaker, listener)) then
			return false
		end

		local chatRange = ix.config.Get("chatRange", 280)

		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
	end

	function CLASS:OnChatAdd(speaker, text)
		text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("radio_eavesdrop", CLASS)
end

do
	local CLASS = {}
	CLASS.color = Color(175, 125, 100)
	CLASS.format = "%s запрашивает \"%s\""

	function CLASS:CanHear(speaker, listener)
		return listener:IsCombine() or speaker:Team() == FACTION_ADMIN or LocalPlayer() == speaker
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("request", CLASS)
end

do
	local CLASS = {}
	CLASS.color = Color(175, 125, 100)
	CLASS.format = "%s запрашивает \"%s\""

	function CLASS:CanHear(speaker, listener)
		if (ix.chat.classes.request:CanHear(speaker, listener)) then
			return false
		end

		local chatRange = ix.config.Get("chatRange", 280)

		return (speaker:Team() == FACTION_CITIZEN and listener:Team() == FACTION_CITIZEN)
		and (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("request_eavesdrop", CLASS)
end

do
	local CLASS = {}
	CLASS.color = Color(150, 125, 175)
	CLASS.format = "%s транслирует \"%s\""

	function CLASS:CanSay(speaker, text)
		if (speaker:Team() != FACTION_ADMIN) then
			speaker:NotifyLocalized("notAllowed")

			return false
		end
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("broadcast", CLASS)
end
