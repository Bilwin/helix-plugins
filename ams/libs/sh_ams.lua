
local ix = ix
ix.AMS = ix.AMS or {}

--[[
	Create diseases meta
	AMS 1/2 kernel.
--]]

ix.AMS.Diseases = {stored = {}}

local DISEASE_TABLE = {__index = DISEASE_TABLE}
DISEASE_TABLE.name = "Disease Base"
DISEASE_TABLE.uniqueID = "disease_base"
DISEASE_TABLE.immuneFactions = {}
DISEASE_TABLE.InitSuccess = false

function DISEASE_TABLE:__tostring()
	return "DISEASE["..self.uniqueID.."]"
end

function DISEASE_TABLE:Register()
	return ix.AMS.Diseases:Register(self)
end

function DISEASE_TABLE:Override(varName, value)
	self[varName] = value
end

function ix.AMS.Diseases:GetAll()
    return self.stored || false
end

function ix.AMS.Diseases:New(disease)
	local object = {}
		setmetatable(object, DISEASE_TABLE)
		DISEASE_TABLE.__index = DISEASE_TABLE
	return object
end

function ix.AMS.Diseases:Register(disease)
	disease.uniqueID = string.lower(string.gsub(disease.uniqueID or string.gsub(disease.name, "%s", "_"), "['%.]", ""))
	self.stored[disease.uniqueID] = disease

	if ( isfunction(disease.OnInit) and (!disease.InitSuccess or true) ) then
		disease.OnInit()
		disease.InitSuccess = true
	end
end

function ix.AMS.Diseases:FindByID(identifier)
	if (identifier and identifier != 0 and type(identifier) != "boolean") then
		if (self.stored[identifier]) then
			return self.stored[identifier]
		end

		local lowerName = string.lower(identifier)
		local disease = nil

		for _, v in pairs(self.stored) do
			local diseaseName = v.name

			if (string.find(string.lower(diseaseName), lowerName)
			and (!disease or string.len(diseaseName) < string.len(disease.name))) then
				disease = v
			end
		end

		return disease
	end
end

--[[
	Create wounds meta
	AMS 2/2 kernel.
--]]

ix.AMS.Wounds = {stored = {}}

local WOUNDS_TABLE = {__index = WOUNDS_TABLE}
WOUNDS_TABLE.name = "Wounds Base"
WOUNDS_TABLE.uniqueID = "wounds_base"
WOUNDS_TABLE.immuneFactions = {}
WOUNDS_TABLE.InitSuccess = false

function WOUNDS_TABLE:__tostring()
	return "WOUND["..self.uniqueID.."]"
end

function WOUNDS_TABLE:Register()
	return ix.AMS.Wounds:Register(self)
end

function WOUNDS_TABLE:Override(varName, value)
	self[varName] = value
end

function ix.AMS.Wounds:GetAll()
    return self.stored || false
end

function ix.AMS.Wounds:New(wound)
	local object = {}
		setmetatable(object, WOUNDS_TABLE)
		WOUNDS_TABLE.__index = WOUNDS_TABLE
	return object
end

function ix.AMS.Wounds:Register(wound)
	wound.uniqueID = string.lower(string.gsub(wound.uniqueID or string.gsub(wound.name, "%s", "_"), "['%.]", ""))
	self.stored[wound.uniqueID] = wound

	if ( isfunction(wound.OnInit) and (!wound.InitSuccess or true) ) then
		wound.OnInit()
		wound.InitSuccess = true
	end
end

function ix.AMS.Wounds:FindByID(identifier)
	if (identifier and identifier != 0 and type(identifier) != "boolean") then
		if (self.stored[identifier]) then
			return self.stored[identifier]
		end

		local lowerName = string.lower(identifier)
		local wound = nil

		for _, v in pairs(self.stored) do
			local woundName = v.name

			if (string.find(string.lower(woundName), lowerName)
			and (!wound or string.len(woundName) < string.len(wound.name))) then
				wound = v
			end
		end

		return wound
	end
end