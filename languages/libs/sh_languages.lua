
ix.RPLanguages = ix.RPLanguages or { stored = {} }

local LANGUAGE_TABLE = {__index = LANGUAGE_TABLE}
LANGUAGE_TABLE.name = "Language Base"
LANGUAGE_TABLE.uniqueID = "language_base"
LANGUAGE_TABLE.category = "Human"
LANGUAGE_TABLE.color = Color(255, 255, 150)
LANGUAGE_TABLE.format = "%s says \"%s\""
LANGUAGE_TABLE.chatIcon = "icon16/flag_blue.png"
LANGUAGE_TABLE.phrases = {}

function LANGUAGE_TABLE:__tostring()
	return "LANGUAGE["..self.uniqueID.."]"
end

function LANGUAGE_TABLE:Register()
	return ix.RPLanguages:Register(self)
end

function LANGUAGE_TABLE:Override(varName, value)
	self[varName] = value
end

function ix.RPLanguages:GetAll()
    return self.stored || false
end

function ix.RPLanguages:New(language)
	local object = {}
		setmetatable(object, LANGUAGE_TABLE)
		LANGUAGE_TABLE.__index = LANGUAGE_TABLE
	return object
end

function ix.RPLanguages:Register(language)
	language.uniqueID = string.lower(string.gsub(language.uniqueID or string.gsub(language.name, "%s", "_"), "['%.]", ""))
	self.stored[language.uniqueID] = language
end

function ix.RPLanguages:FindByID(identifier)
	if (identifier and identifier != 0 and type(identifier) != "boolean") then
		if (self.stored[identifier]) then
			return self.stored[identifier]
		end

		local lowerName = string.lower(identifier)
		local language = nil

		for _, v in pairs(self.stored) do
			local languageName = v.name

			if (string.find(string.lower(languageName), lowerName)
			and (!language or string.len(languageName) < string.len(language.name))) then
				language = v
			end
		end

		return language
	end
end