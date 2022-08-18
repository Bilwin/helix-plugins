PLUGIN.name     = 'Equipped Items Drop'
PLUGIN.author   = 'Bilwin'

if SERVER then
    function PLUGIN:PostPlayerDeath(client)
        local character = client:GetCharacter() if !character then return end
        local items = character:GetInventory():GetItems() if !items || table.IsEmpty(items) then return end
        for _, v in next, items do
            if v:GetData('equip', false) && v.bDropOnDeath == true then
                v:SetData('equip', false)
                ix.item.Spawn(v.uniqueID, client:GetPos() + Vector(0, 0, 2), function()
                    v:Remove()
                end, Angle(), v.data)
            end
        end
    end
end