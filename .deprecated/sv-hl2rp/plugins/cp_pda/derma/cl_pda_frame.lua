
local PANEL = {}

surface.CreateFont("ixPDAButton", {
	font = "Open Sans",
	extended = true,
	size = SScaleMin(19/2),
	weight = 500,
	antialias = true,
	shadow = true
})

local pda_frame = Material("svhl2rp/combinepda.png")
function PANEL:Paint(w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(pda_frame)
    surface.DrawTexturedRect(0, 0, w, h)

	surface.SetFont("ixPDAButton")
	surface.SetTextColor(255, 255, 255, 200)
	surface.SetTextPos(SScaleMin(240), VScale(11.5))
	surface.DrawText(ix.date.Construct(ix.date.GetSerialized(ix.date.Get())):format("%Y/%m/%d - %H:%M:%S"))
end

vgui.Register("PDAFrame", PANEL, "Panel")
