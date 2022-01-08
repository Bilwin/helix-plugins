
local PLUGIN = PLUGIN
PLUGIN.name = "Специальные двери для сил Альянса"
PLUGIN.description = "Запрещаем открывать кадетам важные пункты"
PLUGIN.author = "Bilwin"

function PLUGIN:InitializedChatClasses()
    ix.command.Add("MadePrivateDoor", {
        description = "Поставить защиту для двери.",
        arguments = {ix.type.string},
        superAdminOnly = true,
        OnRun = function(self, client, rank)
            local targetDoor = client:GetEyeTrace().Entity
            if !IsValid(targetDoor) || !targetDoor:IsDoor() || targetDoor:GetClass() != "func_door" then client:Notify("Вы смотрите не на валидную дверь!") return end
            if string.Trim(rank) != '' then
                local exploded = string.Explode(';', rank)
                for _, v in ipairs(exploded) do
                    print( ix.ranks.stored[v] )
                end
            end
        end
    })
end
