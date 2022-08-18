
local PLUGIN = PLUGIN
local cpoutfit = cpoutfit
cpoutfit.armband = {}
cpoutfit.armband.bg = {}
cpoutfit.armband.icon = {}
cpoutfit.armband.text = {}

function cpoutfit.AddArmbandBG(stringMaterialPath, stringText)
	if type(stringMaterialPath) == "string" then
		table.insert(cpoutfit.armband.bg, stringMaterialPath)

		if stringText then
			cpoutfit.texts[stringMaterialPath] = stringText
		end
	end
end

function cpoutfit.AddArmbandIcon(stringMaterialPath, stringText)
	if type(stringMaterialPath) == "string" then
		table.insert(cpoutfit.armband.icon, stringMaterialPath)

		if stringText then
			cpoutfit.texts[stringMaterialPath] = stringText
		end
	end
end

function cpoutfit.AddArmbandText(stringMaterialPath, stringText)
	if type(stringMaterialPath) == "string" then
		table.insert(cpoutfit.armband.text, stringMaterialPath)

		if stringText then
			cpoutfit.texts[stringMaterialPath] = stringText
		end
	end
end

function cpoutfit.ArmbandBGID(stringMaterialPath)
	if type(stringMaterialPath) == "string" then
		for k, v in pairs(cpoutfit.armband.bg) do
			if v == stringMaterialPath then
				return k
			end
		end
	end
end

function cpoutfit.ArmbandIconID(stringMaterialPath)
	if type(stringMaterialPath ) == "string" then
		for k, v in pairs(cpoutfit.armband.icon) do
			if v == stringMaterialPath then
				return k
			end
		end
	end
end

function cpoutfit.ArmbandTextID(stringMaterialPath)
	if type(stringMaterialPath) == "string" then
		for k, v in pairs(cpoutfit.armband.text) do
			if v == stringMaterialPath then
				return k
			end
		end
	end
end

function cpoutfit.ArmbandBGMaterial(numID)
	if type(numID) == "number" then
		for k, v in pairs( cpoutfit.armband.bg) do
			if k == numID then
				return v
			end
		end
	end
end

function cpoutfit.ArmbandIconMaterial(numID)
	if type(numID) == "number" then
		for k, v in pairs(cpoutfit.armband.icon) do
			if k == numID then
				return v
			end
		end
	end
end

function cpoutfit.ArmbandTextMaterial(numID)
	if type(numID) == "number" then
		for k, v in pairs(cpoutfit.armband.text) do
			if k == numID then
				return v
			end
		end
	end
end

function cpoutfit.ArmbandInitEntity(entObject)
	if !entObject.armband_rt then
		entObject.armband_rt = GetRenderTarget("_rt_armband_" .. tostring(entObject:EntIndex() - game.MaxPlayers()), 512, 128)
	end

	if !entObject.armband_mat then
		entObject.armband_mat = CreateMaterial("_mat_armband_" .. tostring(entObject:EntIndex() - game.MaxPlayers()), "VertexLitGeneric", {
			["$model"] = "1",
			["$phong"] = "1",
			["$phongboost"] = ".5",
			["$phongexponent"] = "4.45",
			["$halflambert"] = "0",
			["$phongfresnelranges"] = "[1 1 30]",
			["$ambientocclusion"] = "1",
			["$diffuseexp"] = "1.5",
			["$detail"] = "models/metropolice/c08/noise_detail_01",
			["$detailscale"] = "5",
			["$rimlight"] = "0",
			["$rimlightexponent"] = "10",
			["$rimlightboost"] = ".45"
		})
	end
end

function cpoutfit.ArmbandOnEntityCreated(entObject)
	if entObject:IsPlayer() or entObject:IsNPC() or cpoutfit.IsSupported(entObject:GetModel()) then
		cpoutfit.ArmbandInitEntity(entObject)
	end
end

function cpoutfit.ArmbandThink()
	for k, v in pairs(ents.GetAll()) do
		if cpoutfit.IsSupported(v:GetModel()) then
			if !v.armband_mat or !v.armband_rt then
				cpoutfit.ArmbandInitEntity(v)
			end
		end
		if !v.armband_mat then continue end
		if !v.armband_rt then continue end
		if !v.armband_old_model then
			v.armband_old_model = v:GetModel()
		else
			if v.armband_old_model != v:GetModel() then
				v:SetSubMaterial()
				v.armband_old_model = v:GetModel()
			end
		end
		if !cpoutfit.IsSupported(v:GetModel()) then continue end

		local materialID = cpoutfit.GetMaterialIDModel("armband", v:GetModel())
		if materialID then
			if v:GetSubMaterial(materialID) != "!" .. v.armband_mat:GetName() then
				v:SetSubMaterial(materialID, "!" .. v.armband_mat:GetName())
			end
		end
	end
end

function cpoutfit.ArmbandDraw()
	for k, v in ipairs(ents.GetAll()) do
		if !cpoutfit.IsSupported(v:GetModel()) then continue end
		if !v.armband_rt then continue end
		if !v.armband_mat then continue end

		local bg_color, backgroundID, icon_color, iconID, text_color, textID = v:GetArmbandCode()
		local material_bg = cpoutfit.ArmbandBGMaterial(backgroundID)
		local material_icon = cpoutfit.ArmbandIconMaterial(iconID)
		local material_text = cpoutfit.ArmbandTextMaterial(textID)

		render.PushRenderTarget(v.armband_rt)
			render.Clear(255, 255, 255, 255)
			cam.Start2D()
				if material_bg then
					surface.SetDrawColor(bg_color)
					surface.SetMaterial(ix.util.GetMaterial(material_bg))
					surface.DrawTexturedRect(0, 0, 512, 128)
				end
				if material_icon then
					surface.SetDrawColor(icon_color)
					surface.SetMaterial(ix.util.GetMaterial(material_icon))
					surface.DrawTexturedRect(0, 0, 512, 128)
				end
				if material_text then
					surface.SetDrawColor(text_color)
					surface.SetMaterial(ix.util.GetMaterial(material_text))
					surface.DrawTexturedRect(0, 0, 512, 128)
				end
			cam.End2D()
		render.PopRenderTarget()
		v.armband_mat:SetTexture("$basetexture", v.armband_rt)
	end
end

hook.Add("OnEntityCreated", "CivilProtection.Outfit.Hook", cpoutfit.ArmbandOnEntityCreated)
hook.Add("Think", "CivilProtection.Outfit.Hook", cpoutfit.ArmbandThink)
hook.Add("HUDPaint", "CivilProtection.Outfit.Hook", cpoutfit.ArmbandDraw)

cpoutfit.AddArmbandBG("models/metropolice/bg_sign_black", "Black")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_city17", "City-17")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_cmb", "Concept")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_cmd", "'CmD'")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_darkred", "Dark Red")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_ghost","'GHOST'")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_medic", "Medic")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_nocolor", "Gray")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_red", "Red")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_sec", "'SeC'")
cpoutfit.AddArmbandBG("models/metropolice/bg_sign_white", "White")
cpoutfit.AddArmbandIcon("models/metropolice/c17_icon", "City-17")
cpoutfit.AddArmbandText("models/metropolice/c17_sec", "c17:SeC")
cpoutfit.AddArmbandText("models/metropolice/c17_cmd", "c17:CmD")
cpoutfit.AddArmbandText("models/metropolice/c17_hti", "c17:HtI")
cpoutfit.AddArmbandText("models/metropolice/c17_gu", "c17:GU")
cpoutfit.AddArmbandText("models/metropolice/c17_cpt", "c17:CpT")
cpoutfit.AddArmbandText("models/metropolice/c17_dsp", "c17:DsP")
cpoutfit.AddArmbandText("models/metropolice/c17_dvl", "c17:DvL")
cpoutfit.AddArmbandText("models/metropolice/c17_spf", "c17:SpF")
cpoutfit.AddArmbandText("models/metropolice/c17_epu", "c17:EpU")
cpoutfit.AddArmbandText("models/metropolice/c17_jul", "c17:JU-L")
cpoutfit.AddArmbandText("models/metropolice/c17_ju", "c17:JU")
cpoutfit.AddArmbandText("models/metropolice/c17_i5", "c17:i5")
cpoutfit.AddArmbandText("models/metropolice/c17_i4", "c17:i4")
cpoutfit.AddArmbandText("models/metropolice/c17_i3", "c17:i3")
cpoutfit.AddArmbandText("models/metropolice/c17_i2", "c17:i2")
cpoutfit.AddArmbandText("models/metropolice/c17_i1", "c17:i1")
cpoutfit.AddArmbandText("models/metropolice/c17_ofc", "c17:OfC")
cpoutfit.AddArmbandText("models/metropolice/c17_rct", "c17:RCT")