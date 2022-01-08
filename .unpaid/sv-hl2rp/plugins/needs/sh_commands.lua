
local Format = Format

do
    ix.command.Add("CharSetHunger", {
        description = "Установить голод персонажу",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, client, target, value)
            if !value then value = 0 end
            target:SetHunger(value)
            client:Notify(Format('Вы успешно установили голод для %s на %s', target:GetName(), value))
        end,
        bNoIndicator = true
    })
end

do
    ix.command.Add("CharSetThirst", {
        description = "Установить жажду персонажу",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, client, target, value)
            if !value then value = 0 end
            target:SetThirst(value)
            client:Notify(Format('Вы успешно установили жажду для %s на %s', target:GetName(), value))
        end,
        bNoIndicator = true
    })
end

do
    ix.command.Add("CharSetNeeds", {
        description = "Установить голод и жажду игроку",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, client, target, value)
            if !value then value = 0 end
            target:SetThirst(value)
            target:SetHunger(value)
            client:Notify(Format('Вы успешно установили потребности для %s на %s', target:GetName(), value))
        end,
        bNoIndicator = true
    })
end