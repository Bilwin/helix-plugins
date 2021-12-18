
PLUGIN.name = "Trashpiles"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

ix.config.Add("trashPileItemDropChance", 40, "Item drop chance", nil, {
    data = {min = 1, max = 100},
    category = PLUGIN.name
})

ix.config.Add("trashPileItemsStacks", 3, "How many items drop when trashpile looted (Random)", nil, {
    data = {min = 1, max = 15},
    category = PLUGIN.name
})

ix.config.Add("trashPileLootTime", 20, "Use time", nil, {
    data = {min = 1, max = 60},
    category = PLUGIN.name
})

ix.config.Add("trashPilesReload", 600, "Trashpiles reload (In seconds)", function(_, newValue)
    if (SERVER) then
        for _, ent in ipairs(ents.FindByClass('ix_trashpile')) do
            local uniqueID = 'trashpileReload.'..ent:EntIndex()
            if timer.Exists(uniqueID) and (ent:GetNetVar('looted', false) == true) then
                timer.Adjust(uniqueID, newValue)
            end
        end
    end
end, {
    data = {min = 1, max = 20000},
    category = PLUGIN.name
})

ix.util.Include('sv_hooks.lua')