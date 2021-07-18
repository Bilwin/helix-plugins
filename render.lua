
local PLUGIN = PLUGIN
PLUGIN.name = "Smart Render"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"

PLUGIN.BlackList = {'player','func_door','prop_door', 'func_lod', 'player', 'env_sprite', 'point_spotlight', 'prop_static'}
PLUGIN.Special = {'skybox', 'citadel'}

if (CLIENT) then
    local minDistance = 250^2
    local maxDistance = 15000^2

    PLUGIN.SmartRenderEntities = PLUGIN.SmartRenderEntities or {}

    local directionAngle
    local me
    local playerPosition
    local aimVector
    local shootPosition

    local SysTime = SysTime
    local timerSimple = timer.Simple
    local tableInsert = table.insert
    local tableRemove = table.remove
    local StartWith = string.StartWith
    local sFind = string.find

    CreateClientConVar('SmartRender', '1')
    local SmartRenderEnabled = cvars.Bool('SmartRender')
    CreateClientConVar('SmartRender_DistanceRender', '1')
    local DistanceRenderEnabled = cvars.Bool('SmartRender_DistanceRender')
    CreateClientConVar('SmartRender_ViewRender', '1')
    local ViewRenderEnabled = cvars.Bool('SmartRender_ViewRender')

    local function DisableEntityRender(ent, value)
        ent:SetNoDraw(value)
    end

    local function EntityVisible(entPos)
        local entVector = entPos - shootPosition
        local dot = aimVector:Dot(entVector) / entVector:Length()
        return dot < directionAngle
    end

    local function SmartRender(ent)
        if ( (not DistanceRenderEnabled and not ViewRenderEnabled ) or ent:IsVehicle() ) then return end

        -- Check entity distance
        local entPos = ent:GetPos()
        local Distance = playerPosition:DistToSqr(entPos)

        if ( Distance < minDistance ) then
            DisableEntityRender(ent, false)
        return end

        if ( DistanceRenderEnabled and Distance > maxDistance ) then
            DisableEntityRender(ent, true)
        return end

        if ( ViewRenderEnabled ) then
            -- Ingore entity view check
            if ( ent:IsWeapon() or ent:IsVehicle() ) then
                DisableEntityRender(ent, false)
            return end
        
            -- Check entity view
            DisableEntityRender(ent, EntityVisible(entPos))
        end
    end

    local function Think()
        -- Check smart render enabled
        if ( not SmartRenderEnabled ) then return end

        -- Getting player entity
        if ( not me or not IsValid(me) ) then
            me = LocalPlayer() 
        return end

        -- Calculating direction angle using player fov
        if ( not directionAngle ) then
            local fov = me:GetFOV()
            directionAngle = math.pi / (360 / ( fov / 2 ))
        end

        -- Check player in vehicle
        if ( me:InVehicle() ) then return end

        DistanceRenderEnabled = cvars.Bool('SmartRender_DistanceRender')
        ViewRenderEnabled = cvars.Bool('SmartRender_ViewRender')

        -- Get player data
        playerPosition = me:GetPos()
        aimVector = me:GetAimVector()
        shootPosition = me:GetShootPos()

        for k, ent in ipairs(PLUGIN.SmartRenderEntities) do
            if ( IsValid(ent) ) then
                -- Entity is valid
                SmartRender(ent)
            else
                -- Entity isn't valid
                tableRemove(PLUGIN.SmartRenderEntities, k) 
            end
        end
    end

    function PLUGIN:OnEntityCreated(ent)
        if ( not IsValid(ent) ) then return end

        local className = ent.GetClass and ent:GetClass()
        local classModel = ent.GetModel and ent:GetModel()
        if ( not classModel ) then return end
        if ( not className ) then return end

        -- Check entity class
        local shouldIgnore = false
        for _, models in ipairs(self.Special) do
            if (sFind(classModel, models)) then shouldIgnore = true; break end
        end
        for _, class in ipairs(self.BlackList) do
            if (StartWith(className, class)) then shouldIgnore = true; break end
        end
        if ( shouldIgnore ) then return end

        timer.Simple(0, function() -- fix unexpected problems with entity
            tableInsert(self.SmartRenderEntities, ent)
        end)
    end

    timer.Create('SmartRender.Think', 0.1, 0, Think)

    local function ShowEveryEntity()
        for k, ent in ipairs(PLUGIN.SmartRenderEntities) do
            if ( not IsValid(ent) ) then return end
            DisableEntityRender(ent, false)
        end
    end

    cvars.AddChangeCallback('SmartRender', function(name, old, new)
        SmartRenderEnabled = tobool(new)
        
        -- Rendering entities after disabling smart render
        if ( not SmartRenderEnabled ) then
            ShowEveryEntity()
        end
    end, 'test')
end