
local PLUGIN = PLUGIN
PLUGIN.name = "Metropolice API"
PLUGIN.author = "Bilwin, SchwarzKruppzo"
PLUGIN.description = "Support for Customizable Metropolice outfit API"

ix.anim.SetModelClass("models/metropolice/c08.mdl", "metrocop")
ix.anim.SetModelClass("models/metropolice/c08_female.mdl", "metrocop")
ix.anim.SetModelClass("models/metropolice/c08_female_2.mdl", "citizen_female")
ix.anim.SetModelClass("models/metropolice/c08_female_3.mdl", "citizen_female")
ix.anim.SetModelClass("models/player/metropolice/c08.mdl", "player")
ix.anim.SetModelClass("models/player/metropolice/c08_female.mdl", "player")

cpoutfit = {}
cpoutfit.supported = {}
cpoutfit.mat = {}
cpoutfit.texts = {}

function cpoutfit.IsSupported(stringModel)
	return cpoutfit.supported[stringModel]
end

function cpoutfit.GetMaterialTable()
	return cpoutfit.mat
end

function cpoutfit.GetMaterialIDs(matUniqueID)
	return cpoutfit.mat[matUniqueID].matID
end

function cpoutfit.GetMaterialIDModel(matUniqueID, modelPath)
	return cpoutfit.mat[matUniqueID].matID and (cpoutfit.mat[matUniqueID].matID[modelPath]) or false
end

function cpoutfit.GetMaterialOverrides(matUniqueID)
	return cpoutfit.mat[matUniqueID].params
end

function cpoutfit.RemoveModel(stringModel)
	if cpoutfit.supported[stringModel] then
		cpoutfit.supported[stringModel] = nil
	end
end

function cpoutfit.RemoveMaterialPart(matUniqueID)
	if cpoutfit.mat[matUniqueID] then
		cpoutfit.mat[matUniqueID] = nil
	end
end

function cpoutfit.AddModel(stringModel)
	if !cpoutfit.supported[stringModel] then
		cpoutfit.supported[stringModel] = true
	end
end

function cpoutfit.AddMaterialPart(matUniqueID, matIDTable, paramsTable, text)
	if !cpoutfit.mat[matUniqueID] then
		cpoutfit.mat[matUniqueID] = {}
		cpoutfit.mat[matUniqueID].matID = {}
		cpoutfit.mat[matUniqueID].params = {}

		cpoutfit.SetMaterialPart(matUniqueID, matIDTable, paramsTable)
		if text then
			cpoutfit.texts[matUniqueID] = text
		end
	end
end

function cpoutfit.AddMaterialID(matUniqueID, stringModel, materialID)
	if cpoutfit.mat[matUniqueID] then
		if cpoutfit.IsSupported(stringModel ) then
			cpoutfit.mat[matUniqueID].matID[stringModel] = materialID
		end
	end
end

function cpoutfit.AddMaterialOverride(matUniqueID, materialToOverride, customID, text)
	if cpoutfit.mat[matUniqueID] then
		if !customID then
			table.insert( cpoutfit.mat[matUniqueID].params, materialToOverride )
		else
			cpoutfit.mat[matUniqueID].params[customID] = materialToOverride
		end
		if text then
			cpoutfit.texts[materialToOverride] = text
		end
	end
end

function cpoutfit.SetMaterialPart(matUniqueID, matIDTable, paramsTable)
	if cpoutfit.mat[matUniqueID] then
		if matIDTable then
			if type(matIDTable) == "table" then
				cpoutfit.mat[matUniqueID].matID = matIDTable
			end
		end
		if paramsTable then
			if type(paramsTable) == "table" then
				cpoutfit.mat[matUniqueID].params = paramsTable
			end
		end
	end
end

function cpoutfit.SetPlayerOutfit(entObject, ...)
	if !IsValid(entObject) then return end
	local model = entObject:GetModel()
	if !cpoutfit.IsSupported(model) then return end

	local args = {...}
	local temp = {}
	local temp_key

	if #args == 0 then
		entObject:SetSubMaterial()
		return
	end

	for k, v in pairs(args) do
		if type(v) == "string" then
			temp_key = v
		elseif type(v) == "number" then
			temp[temp_key] = v
			temp_key = nil
		end
	end

	for partname, id in pairs(temp) do
		local partTable = cpoutfit.GetMaterialTable()[partname]
		if partTable then
			local materialID = cpoutfit.GetMaterialIDModel(partname, model)
			local overrides = cpoutfit.GetMaterialOverrides(partname)

			if overrides[id] then
				entObject:SetSubMaterial(materialID, overrides[id])
			end
		end
	end
end

local _tonumber = tonumber
local _tostring = tostring
function cpoutfit.SetCPOutfit(entity, str)
	if !IsValid(entity) then return end
	if !cpoutfit.IsSupported(entity:GetModel()) then return end
	if #str <= 0 then return end

	local strTable = string.Explode( "_", str )
	local uID = _tonumber(strTable[1])
	local lID = _tonumber(strTable[2])
	local gasmaskID = _tonumber(strTable[3])
	local gasmaskShockID = _tonumber(strTable[4])
	local gasmaskGlow = _tonumber(strTable[5])

	cpoutfit.SetPlayerOutfit(entity, "uniform", uID )
	cpoutfit.SetPlayerOutfit(entity, "legs", lID )
	cpoutfit.SetPlayerOutfit(entity, "gasmask_style", gasmaskID )
	cpoutfit.SetPlayerOutfit(entity, "gasmaskshock_style", gasmaskShockID )
	cpoutfit.SetPlayerOutfit(entity, "visor_style", gasmaskGlow )
end

function cpoutfit.SetCPArmband(entity, str)
	if !IsValid(entity) then return end
	if !cpoutfit.IsSupported(entity:GetModel()) then return end
	if #str <= 0 then return end
	local codeTable = string.Explode("_", str)

	if codeTable then
		local bg_color = Color(255,255,255)
		local icon_color = Color(255,255,255)
		local text_color = Color(255,255,255)

		if codeTable[1] then
			local r, g, b = codeTable[1]:match("%((%d+),(%d+),(%d+)%)")
			bg_color = Color(_tonumber(r), _tonumber(g), _tonumber(b))
		end

		if codeTable[3] then
			local r, g, b, a = codeTable[3]:match("%((%d+),(%d+),(%d+),(%d+)%)")
			icon_color = Color(_tonumber(r), _tonumber(g), _tonumber(b), _tonumber(a))
		end

		if codeTable[5] then
			local r, g, b, a = codeTable[5]:match("%((%d+),(%d+),(%d+),(%d+)%)")
			text_color = Color(_tonumber(r), _tonumber(g), _tonumber(b), _tonumber(a))
		end

		local backgroundID = _tonumber(codeTable[2])
		local iconID = _tonumber(codeTable[4])
		local textID = _tonumber(codeTable[6])

		entity:SetArmbandCode( bg_color, backgroundID, icon_color, iconID, text_color, textID )
	end
end

function cpoutfit.SetCPVisors(entity, pvisor, svisor)
	if !IsValid(entity) then return end
	if !cpoutfit.IsSupported(entity:GetModel()) then return end

	if pvisor then
		local pvisor_table = string.Explode("_", pvisor)
		entity:SetPrimaryVisorColor( Vector( _tonumber(pvisor_table[1]), _tonumber(pvisor_table[2]), _tonumber(pvisor_table[3]) ) )
	end

	if svisor then
		local svisor_table = string.Explode("_", svisor)
		entity:SetSecondaryVisorColor( Vector( _tonumber(svisor_table[1]), _tonumber(svisor_table[2]), _tonumber(svisor_table[3]) ) )
	end
end

ix.util.Include("sh_defines.lua")
ix.util.Include("sh_meta.lua")
ix.util.Include("cl_armbands.lua")