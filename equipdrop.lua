PLUGIN.name     = 'Equipped Items Drop'
PLUGIN.author   = 'Bilwin'

if SERVER then
    function PLUGIN:PostPlayerDeath(client)
        local char = client:GetCharacter()
        if not char then return end

        local items = char:GetInventory():GetItems()
        if not items then return end

        for _, v in pairs(items) do
            if hook.Run('ShouldItemBeingDropped', client, char, v) == false then continue end

            if v:GetData('equip') then
                v:SetData('equip', false)
            end

            ix.item.Spawn(v.uniqueID, client:GetPos() + Vector(0, 0, 2), function()
                v:Remove()
            end, Angle(), v.data)
        end
    end

    function PLUGIN:ShouldItemBeingDropped(client, character, item)
    end
end