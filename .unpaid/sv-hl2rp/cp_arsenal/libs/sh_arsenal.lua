
ix.cpArsenal = ix.cpArsenal || {}
ix.cpArsenal.list = ix.cpArsenal.list || {}

function ix.cpArsenal:RegisterCraft(uniqueID, data)
    if !data || !uniqueID then
        ErrorNoHalt("ix.cpArsenal:RegisterCraft invalid data or uniqueID")
    end

    data.cost = data.cost || 0
    data.cooldown = data.cooldown || 0
    data.items = data.items || {}
    data.tokens = data.tokens || 0
    data.rank = data.rank

    ix.cpArsenal.list[uniqueID] = data
end

function ix.cpArsenal:Get(uniqueID)
    if !uniqueID then return end
    if ix.cpArsenal.list[uniqueID] then
        return ix.cpArsenal.list[uniqueID]
    end
end