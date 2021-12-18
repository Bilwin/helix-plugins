
function ENTITY:GetMass()
    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
        return physObj:GetMass()
    else
        return 0
    end
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