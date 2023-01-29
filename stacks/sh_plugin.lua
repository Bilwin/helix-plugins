PLUGIN.name         = 'Stackable Items'
PLUGIN.description  = 'Adds the ability to stack items into one'
PLUGIN.author       = 'Bilwin'

function ix.meta.inventory:GetItemCount(uniqueID, onlyMain)
    local i = 0
    local stacks

    for _, v in pairs(self:GetItems(onlyMain)) do
        if v.uniqueID == uniqueID then
            stacks = v.data.stacks

            if stacks && stacks >= 2 then
                i = i + stacks
            else
                i = i + 1
            end
        end
    end

    return i
end