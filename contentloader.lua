
PLUGIN.name = "Content Loader"
PLUGIN.description = "Very simple workshop collection loader"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"

if (SERVER) then
    local workshop_items = engine.GetAddons()

    for i = 1, #workshop_items do
        local addon_id = workshop_items[i].wsid

        resource.AddWorkshop(addon_id)
    end
end