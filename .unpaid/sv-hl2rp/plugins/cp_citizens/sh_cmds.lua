
local PLUGIN = PLUGIN

function PLUGIN:InitializedChatClasses()
    ix.command.Add("CPEditLP", {
        description = "Добавить или отнять очки лояльности персонажу.",
        arguments = {
            ix.type.character,
            ix.type.number,
            ix.type.string,
        },
        OnCheckAccess = function(self, client)
            return client:IsCombine() and !client:GetCharacter():GetCPRank().lp_restricted
        end,
        OnRun = function(self, client, target, amount, reason)
            if target:IsCombine() or target:GetFaction() == FACTION_ADMIN then
                return false, "Ваша цель является сотрудником Альянса"
            end

            local stripped = tostring(amount):find('-')
            local formatted_text

            if stripped then
                amount = math.abs(amount)
                target:TakeLoyalPoints(amount)

                formatted_text = ix.util.FormatStringNamed("Вы успешно отняли {amount} ОЛ для гражданина {target}.", {
                    amount = amount,
                    target = target:GetName()
                })
                client:Notify(formatted_text)

                formatted_text = ix.util.FormatStringNamed("{unit} отнял {amount} ОЛ у гражданина {target}. Причина: {reason}", {
                    unit = client:GetCharacter():GetName(),
                    amount = amount,
                    target = target:GetName(),
                    reason = reason
                })
                Schema:AddCombineDisplayMessage(formatted_text, Color(0, 100, 255))
            else
                target:AddLoyalPoints(amount)

                formatted_text = ix.util.FormatStringNamed("Вы успешно выдали {amount} ОЛ для гражданина {target}.", {
                    amount = amount,
                    target = target:GetName()
                })
                client:Notify(formatted_text)

                formatted_text = ix.util.FormatStringNamed("{unit} выдал {amount} ОЛ для гражданина {target}. Причина: {reason}", {
                    unit = client:GetCharacter():GetName(),
                    amount = amount,
                    target = target:GetName(),
                    reason = reason
                })
                Schema:AddCombineDisplayMessage(formatted_text, Color(0, 100, 255))
            end

            ix.log.Add(client, "loyalEvent", target:GetName(), loyal)
            hook.Run("OnCPChangedCitizenLP", client, target, amount, reason, stripped)
        end
    })

    ix.command.Add("CPInfo", {
        description = "Узнать информацию о гражданине.",
        arguments = {ix.type.character},
        OnCheckAccess = function(self, client)
            return client:IsCombine()
        end,
        OnRun = function(self, client, target)
            if target:IsCombine() or target:GetFaction() == FACTION_ADMIN then
                return false, "Ваша цель является сотрудником Альянса"
            end

            local msg = {}
            local name = "ЦЕЛЬ: "..target:GetName()
            local cid = "CID: "..target:GetData("cid", "UNKNOWN")
            local lp = "ОЛ: "..target:GetLoyalPoints()

            table.insert(msg, name)
            table.insert(msg, cid)
            table.insert(msg, lp)

            netstream.Start(client, "HeavyChatNotify", msg, color_white, 'icon16/information.png')
        end
    })
end