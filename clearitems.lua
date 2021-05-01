
local PLUGIN = PLUGIN
PLUGIN.name = "Garbage Cleaner"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Clean your map from garbage"
PLUGIN.schema = "Any"
PLUGIN.clearItems = {
    ["ix_item"] = true,
    ["ix_money"] = true,
    ["ix_shipment"] = true
}

ix.config.Add("garbageCleanerDelay", 600, "How long does it take to wait between clearing the map", function(_, new)
    if (SERVER) then
        PLUGIN:CreateTimer(new)
    end
end, {
	data = {min = 0, max = 15000},
	category = PLUGIN.name
})

if (SERVER) then
    function PLUGIN:CreateTimer(delay)
        if timer.Exists('itemCleaner') then
            timer.Remove('itemCleaner')
        end
        if !delay then delay = 60*10 end

        timer.Create('itemCleaner', delay, 0, function()
            for _, ent in ipairs( ents.GetAll() ) do
                if self.clearItems[ent:GetClass()] then
                    SafeRemoveEntity(ent)
                end
            end
        end)
    end

    function PLUGIN:InitPostEntity()
        self:CreateTimer()
    end
end