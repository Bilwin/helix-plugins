PLUGIN.name     = 'Disable door & player shadows'
PLUGIN.author   = 'Bilwin'

if SERVER then
    function PLUGIN:InitPostEntity()
        for _, v in ipairs( ents.FindByClass('prop_door_rotating') ) do
            v:DrawShadow(false)
        end
    end
end

if CLIENT then
    timer.Create(PLUGIN.name, 10, 0, function() -- same
        for _, client in ipairs(player.GetAll()) do
            client:DrawShadow(false)
        end
    end)

    function PLUGIN:InitPostEntity()
        for _, v in ipairs( ents.FindByClass('prop_door_rotating') ) do
            if not IsValid(v) then continue end
            v:DrawShadow(false)
        end
    end
end