PLUGIN.name         = 'Content Loader'
PLUGIN.description  = 'Automatically mount installed server content (host_workshop_collection)'
PLUGIN.author       = 'Bilwin'

if SERVER then
    function PLUGIN:Initialize()
        local ws = engine.GetAddons()
        for _, v in ipairs(ws) do
            resource.AddWorkshop(v.wsid)
        end
    end
end