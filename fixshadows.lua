
PLUGIN.name = "Fix Shadows"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

if (SERVER) then
    function PLUGIN:InitPostEntity()
        for _, v in ipairs( ents.FindByClass("prop_door_rotating") ) do
            if IsValid(v) and v:IsDoor() then
                v:DrawShadow(false)
            end
        end
    end
end

if (CLIENT) then
    timer.Create('FixShadows', 5, 0, function()
        for _, player in ipairs( player.GetAll() ) do
            player:DrawShadow(false)
        end

        for _, v in ipairs( ents.FindByClass("prop_door_rotating") ) do
            if IsValid(v) and v:IsDoor() then
                v:DrawShadow(false)
            end
        end
    end)
end