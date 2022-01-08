
local PLUGIN = PLUGIN

do
    local CLASS = {}
    CLASS.color = Color(99, 166, 228)
    CLASS.format = "[ПГ #%s] %s: \"%s\""

    function CLASS:CanHear(speaker, listener)
        local ptData = listener:InPT() and listener:GetPT()
        if !ptData then return false end
        local ptData2 = speaker:InPT() and speaker:GetPT()
        if !ptData2 then return false end
        local bStatus = false

        if (ptData.owner == ptData2.owner and speaker:InPT() and listener:InPT()) then
            bStatus = true
        end

        return bStatus
    end

    function CLASS:OnChatAdd(speaker, text)
        text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
        local channel = speaker:InPT() and select(2, speaker:GetPT())
        chat.AddText(self.color, string.format(self.format, channel, speaker:Name(), text))
    end

    ix.chat.Register("pt_chat", CLASS)
end

do
    ix.command.Add("PTChat", {
        alias = "PT",
        description = "Написать в чат патрульной группы",
        arguments = {ix.type.text},
        OnCheckAccess = function(self, client)
			return client:InPT()
		end,
        OnRun = function(self, client, text)
            if (!client:IsRestricted()) then
                ix.chat.Send(client, "pt_chat", text)
            else
                return "@notNow"
            end
        end,
        bNoIndicator = true
    })
end