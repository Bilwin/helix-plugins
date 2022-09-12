
-- TODO: Screen scaling
local PLUGIN = PLUGIN
function PLUGIN:LoadFonts(font, genericFont)
    surface.CreateFont('ixRadio', {
        font        = font,
        extended    = true,
        size        = 30,
        weight      = 100,
        shadow      = true,
        antialias   = true
    })
end

net.Receive('ixRadio', function(_)
    local radio = net.ReadEntity()

    local frame = vgui.Create('DFrame')
    frame:SetSize( ScrW()*.25, ScrH()*.45 )
    frame:Center()
    frame:SetTitle( "" )
    frame:SetDraggable( false )
    frame:ShowCloseButton( true )
    frame:MakePopup()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.4, 0)
    frame.Paint = function( self, w, h )
        ix.util.DrawBlur(self, 4)
        surface.SetDrawColor(ix.config.Get('color').r, ix.config.Get('color').g, ix.config.Get('color').b, 155)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local scrollPanel = vgui.Create( "DScrollPanel", frame )
    scrollPanel:Dock( FILL )

    for key, value in pairs(PLUGIN.songs) do -- will be reworked soon
	local songpath = key
        key = vgui.Create('DButton', scrollPanel)
        key:SetSize(ScrW()*.225, ScrH()*.05)
        key:SetPos(ScrW()*.007, ScrH()*.04)
        key:SetFont('ixRadio')
        key:SetText(value)
        key:Dock(TOP)
        key.Color = Color(155, 155, 155, 25)
        key.DoClick = function()
            surface.PlaySound('helix/ui/press.wav')
            net.Start('ixRadio')
                net.WriteEntity(radio)
                net.WriteString(songpath)
            net.SendToServer()
        end
        key.OnCursorEntered = function()
            surface.PlaySound('helix/ui/rollover.wav')
        end
        key.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Color.a = Lerp(0.075, self.Color.a , 35)
            else
                self.Color.a = Lerp(0.075, self.Color.a , 25)
            end

            if self:IsDown() then
                self.Color.a = Lerp(0.075, self.Color.a , 75)
            end

            draw.RoundedBox(0, 0, 0, w, h, self.Color)
            surface.SetDrawColor(5, 5, 5, 155)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
    end
end)
