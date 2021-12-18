
function ENTITY:GetMass()
    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
        return physObj:GetMass()
    else
        return 0
    end
end

function rnlib.OverrideEntStored(class_name, key, value)
    assert(class_name != nil, 'class_name should be entity class name!')
    local stored = scripted_ents.GetStored(class_name)['t']
    stored[key] = value
end

if SERVER then
    function ENTITY:SafeRemoveFaded(t)
        if !IsValid(self) then return end
        local d = t / 255
        self:SetRenderMode(RENDERMODE_TRANSCOLOR)
        self:_SetTimer('_FadeRemove', d, 260, function()
            local col = self:GetColor()
            col.a = math.Clamp(col.a - d, 0, 255)
            self:SetColor(col)
            if col.a == 0 then
                self:Remove()
                self:_RemoveTimer('_FadeRemove')
            end
        end)
    end
end