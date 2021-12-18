--[[
    CircleAvatarImage
    ## Use it like simple AvatarImage but with ***:SetMaskSize(*** / 2) at the end where *** is a variable of CircleAvatarImage panel.
]]

local PANEL = {}

local cos, sin, rad = math.cos, math.sin, math.rad
AccessorFunc(PANEL, "m_masksize", "MaskSize", FORCE_NUMBER)

function PANEL:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)
    self:SetMaskSize(24)
end

function PANEL:PerformLayout()
    self.Avatar:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:SetPlayer(id)
    self.Avatar:SetPlayer(id, self:GetWide())
end

function PANEL:SetSteamID(steamid, size)
    self.Avatar:SetSteamID(steamid, size)
end

function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    local _m = self.m_masksize
    local circle, t = {}, 0 
    for i = 1, 360 do
        t = rad(i * 720) / 720

        circle[i] = {
            x = w / 2 + cos(t) * _m,
            y = h / 2 + sin(t) * _m
        }
    end

    draw.NoTexture()
    surface.SetDrawColor(color_white)
    surface.DrawPoly(circle)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)

    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("CircleAvatarImage", PANEL)