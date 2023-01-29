PLUGIN.name = 'Shadows Overhaul'

if SERVER then
    function PLUGIN:InitPostEntity()
        for _, v in ipairs( ents.FindByClass('prop_door_rotating') ) do
            if IsValid(v) && v:IsDoor() then
                v:DrawShadow(false) -- we need this?
            end
        end
    end
end

if CLIENT then
    timer.Create('FixShadows', 10, 0, function() -- same
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