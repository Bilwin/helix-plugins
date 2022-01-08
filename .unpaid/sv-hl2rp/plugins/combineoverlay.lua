
local PLUGIN = PLUGIN
PLUGIN.name = 'Combine Overlay'
PLUGIN.description = 'New Combine Overlay'
PLUGIN.author = 'Bilwin'
PLUGIN.schema = 'HL2 RP'
PLUGIN.cca_overlay = ix.util.GetMaterial 'effects/combine_binocoverlay'
PLUGIN.ota_overlay = ix.util.GetMaterial 'effects/combine_binocoverlay'

ix.lang.AddTable("english", {
	optShowCombineOverlay = "Show combine overlay",
    optCombineOverlayAlpha = "Combine overlay alpha"
})

ix.lang.AddTable("russian", {
	optShowCombineOverlay = "Отображать оверлей",
    optCombineOverlayAlpha = "Прозрачность оверлея"
})

ix.option.Add("showCombineOverlay", ix.type.bool, true, {
    category = PLUGIN.name,
    hidden = function()
		return !LocalPlayer():IsCombine()
	end
})

ix.option.Add("combineOverlayAlpha", ix.type.number, 0.5, {
    category = PLUGIN.name,
    min = 0.1,
    max = 1,
    decimals = 1,
    hidden = function()
		return !LocalPlayer():IsCombine()
	end
})

local overlay_alpha = 0.5
function PLUGIN:RenderScreenspaceEffects()
    if ix.option.Get('showCombineOverlay', false) then
        if LocalPlayer():IsCombine() then
            overlay_alpha = ix.option.Get('combineOverlayAlpha', 0.5)
            if LocalPlayer():Team() == FACTION_MPF then
                render.UpdateScreenEffectTexture()

                self.cca_overlay:SetFloat("$alpha", overlay_alpha)
                self.cca_overlay:SetInt("$ignorez", 1)

                render.SetMaterial(self.cca_overlay)
                render.DrawScreenQuad()
            elseif LocalPlayer():Team() == FACTION_OTA then
                render.UpdateScreenEffectTexture()

                self.ota_overlay:SetFloat("$alpha", overlay_alpha)
                self.ota_overlay:SetInt("$ignorez", 1)

                render.SetMaterial(self.ota_overlay)
                render.DrawScreenQuad()
            end
        end
    end
end