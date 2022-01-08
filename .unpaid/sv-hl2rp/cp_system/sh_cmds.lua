
local PLUGIN = PLUGIN

function PLUGIN:InitializedChatClasses()
    ix.command.Add("ToggleRecruitment", {
        description = "Переключить набор в силы Гражданской Обороны.",
        OnCheckAccess = function(self, client)
            return client:IsCombine() and client:GetCharacter() and client:GetCharacter():GetCPRank().name == "OFC"
        end,
        OnRun = function(self, client)
            if GetNetVar("recruitmentCooldown", 0) > CurTime() then client:Notify(Format("Подождите перед тем как переключить набор! (%i с.)", GetNetVar("recruitmentCooldown", 0) - CurTime())) return end
            SetNetVar("recruitmentCooldown", CurTime() + 30)

            local boolean = !GetNetVar("recruitmentToggled", false)
            SetNetVar("recruitmentToggled", boolean)
            local prefix = boolean == true and "открыт!" or "закрыт!"
            client:Notify("Набор в Гражданскую оборону "..prefix)
        end
    })
end