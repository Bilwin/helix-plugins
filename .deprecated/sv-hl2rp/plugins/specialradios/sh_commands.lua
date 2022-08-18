
local PLUGIN = PLUGIN

do
	local CLASS = {}
	CLASS.color = Color(99, 166, 228)
	CLASS.format = "[%s] %s: \"%s\""

	function CLASS:CanHear(speaker, listener)
        local character = listener:GetCharacter()
        local specialChannel = speaker:GetCharacter():GetSpecialChannel()
        if specialChannel == SCHANNEL_NONE then return false end
        local bStatus = false

        if (character:HasAccessToChannel(specialChannel) and (character:GetSpecialChannel() == specialChannel)) then
            bStatus = true
        end

		return bStatus
	end

	function CLASS:OnChatAdd(speaker, text)
		text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
        local channel = speaker:GetSpecialChannel() ~= SCHANNEL_NONE and (speaker:GetSpecialChannel()):upper() or 'UNKNOWN'
		chat.AddText(self.color, string.format(self.format, channel, speaker:Name(), text))
	end

	ix.chat.Register("specialradio", CLASS)
end

do
    ix.command.Add("SetChannel", {
        description = "Установить канал.",
        alias = "SC",
        arguments = {ix.type.string},
        OnRun = function(self, client, channel)
            local character = client:GetCharacter()
            if !character then return end

            if (ix.specialRadios[channel]) then
                if !istable(ix.specialRadios.factionsData[character:GetFaction()]) then return "You do not have access to this channel" end
                if table.HasValue(ix.specialRadios.factionsData[character:GetFaction()], channel) then
                    character:SetSpecialChannel(channel)
                    client:Notify("Ваш канал был изменен на: "..channel)
                else
                    return "У вас нет доступа к данному каналу!"
                end
            else
                return "Требуемый канал не найден!"
            end
        end,
        bNoIndicator = true
    })
end

do
    ix.command.Add("SpecialRadio", {
        alias = "SR",
        description = "Написать в рацию Альянса",
        arguments = {ix.type.text},
        OnCheckAccess = function(self, client)
			return client:GetCharacter() and client:GetCharacter():GetSpecialChannel() ~= SCHANNEL_NONE
		end,
        OnRun = function(self, client, text)
            if (!client:IsRestricted()) then
                if !ix.config.Get("enableSpecialRadios", true) then return "@notNow" end
                ix.chat.Send(client, "specialradio", text)
            else
                return "@notNow"
            end
        end,
        bNoIndicator = true
    })
end
