PLUGIN.name = 'Shadows Overhaul'

if SERVER then
    function PLUGIN:InitPostEntity()
        for _, v in ipairs( ents.FindByClass('prop_door_rotating') ) do
            if IsValid(v) and v:IsDoor() then
                v:DrawShadow(false) -- we need this?
            end
        end
    end
end

if CLIENT then
    timer.Create('FixShadows', 10, 0, function() -- same
        for _, player in ipairs( player.GetAll() ) do
            player:DrawShadow(false)
        end

        for _, v in ipairs( ents.FindByClass('prop_door_rotating') ) do
            if IsValid(v) && v:IsDoor() then
                v:DrawShadow(false)
            end
        end
    end)
end