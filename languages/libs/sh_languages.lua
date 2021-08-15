
ix.languages = ix.languages or {stored = {}}

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
	return ix.languages:Register(self)
end

function LANGUAGE_TABLE:Override(varName, value)
	self[varName] = value
end

function ix.languages:GetAll()
    return self.stored
end

function ix.languages:New(language)
	local object = {}
		setmetatable(object, LANGUAGE_TABLE)
		LANGUAGE_TABLE.__index = LANGUAGE_TABLE
	return object
end

function ix.languages:Register(language)
	language.uniqueID = string.lower(string.gsub(language.uniqueID or string.gsub(language.name, "%s", "_"), "['%.]", ""))
	self.stored[language.uniqueID] = language

	ix.command.Add(string.Replace(language.uniqueID, 'language_', ''), {
		arguments = ix.type.text,
		description = "Allows you to say something in " .. string.lower(language.name) .. " language",
		OnRun = function(this, client, message)
			if !client:GetCharacter() then return end
			if !message or string.Trim(message) == "" then return end
			if client:GetCharacter():CanSpeakLanguage(language.uniqueID) then
				ix.chat.Send(client, language.uniqueID, message)
				ix.chat.Send(client, language.uniqueID .. "_unknown", message)
			else
				client:Notify('You don\'t know such a language!')
			end
		end
	})

	ix.chat.Register(language.uniqueID, {
		format = language.format,
		icon = language.chatIcon,
		deadCanChat = false,
		indicator = "chatTalking",
		GetColor = function(self, speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			return ix.config.Get("chatColor")
		end,
		CanHear = function(self, speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange) and listener:GetCharacter():CanSpeakLanguage(tostring(language.uniqueID))
		end
	})

	ix.chat.Register(language.uniqueID .. "_unknown", {
		format = language.formatUnknown,
		icon = language.chatIcon,
		deadCanChat = false,
		indicator = "chatTalking",
		GetColor = function(self, speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			return ix.config.Get("chatColor")
		end,
		CanHear = function(self, speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange) and !listener:GetCharacter():CanSpeakLanguage(tostring(language.uniqueID))
		end,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			local color = self:GetColor(self, speaker, text)
			local icon = ix.util.GetMaterial(self.icon)
			local name = bAnonymous and L"someone" or
				hook.Run("GetCharacterName", speaker, "ic") or
				(IsValid(speaker) and speaker:Name() or "Console")
			chat.AddText(icon, color, string.format(self.format, name))
		end
	})

	-- Whispering
	ix.command.Add('whisper_' .. string.Replace(language.uniqueID, 'language_', ''), {
		arguments = ix.type.text,
		description = "Allows you to whisper something on " .. string.lower(language.name) .. " language",
		OnRun = function(this, client, message)
			if !client:GetCharacter() then return end
			if !message or string.Trim(message) == "" then return end
			if client:GetCharacter():CanSpeakLanguage(language.uniqueID) then
				ix.chat.Send(client, "whisper_" .. language.uniqueID, message)
				ix.chat.Send(client, "whisper_" .. language.uniqueID .. "_unknown", message)
			else
				client:Notify('You don\'t know such a language!')
			end
		end
	})

	ix.chat.Register("whisper_" .. language.uniqueID, {
		format = language.formatWhispering,
		icon = language.chatIcon,
		deadCanChat = false,
		indicator = "chatWhispering",
		GetColor = function(self, speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			return ix.config.Get("chatColor")
		end,
		CanHear = function(self, speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 0.25) and listener:GetCharacter():CanSpeakLanguage(tostring(language.uniqueID))
		end
	})

	ix.chat.Register("whisper_" .. language.uniqueID .. "_unknown", {
		format = language.formatWhisperingUnknown,
		icon = language.chatIcon,
		deadCanChat = false,
		indicator = "chatWhispering",
		GetColor = function(self, speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			return ix.config.Get("chatColor")
		end,
		CanHear = function(self, speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 0.25) and !listener:GetCharacter():CanSpeakLanguage(tostring(language.uniqueID))
		end,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			local color = self:GetColor(self, speaker, text)
			local icon = ix.util.GetMaterial(self.icon)
			local name = bAnonymous and L"someone" or
				hook.Run("GetCharacterName", speaker, "ic") or
				(IsValid(speaker) and speaker:Name() or "Console")
			chat.AddText(icon, color, string.format(self.format, name))
		end
	})

	-- Yelling
	ix.command.Add('yell_' .. string.Replace(language.uniqueID, 'language_', ''), {
		arguments = ix.type.text,
		description = "Lets you yell something at " .. string.lower(language.name) .. " language",
		OnRun = function(this, client, message)
			if !client:GetCharacter() then return end
			if !message or string.Trim(message) == "" then return end
			if client:GetCharacter():CanSpeakLanguage(language.uniqueID) then
				ix.chat.Send(client, "yell_" .. language.uniqueID, message)
				ix.chat.Send(client, "yell_" .. language.uniqueID .. "_unknown", message)
			else
				client:Notify('You don\'t know such a language!')
			end
		end
	})

	ix.chat.Register("yell_" .. language.uniqueID, {
		format = language.formatYelling,
		icon = language.chatIcon,
		deadCanChat = false,
		indicator = "chatYelling",
		GetColor = function(self, speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			return ix.config.Get("chatColor")
		end,
		CanHear = function(self, speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 2) and listener:GetCharacter():CanSpeakLanguage(tostring(language.uniqueID))
		end
	})

	ix.chat.Register("yell_" .. language.uniqueID .. "_unknown", {
		format = language.formatYellingUnknown,
		icon = language.chatIcon,
		deadCanChat = false,
		indicator = "chatYelling",
		GetColor = function(self, speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			return ix.config.Get("chatColor")
		end,
		CanHear = function(self, speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= ((chatRange * chatRange) * 2) and !listener:GetCharacter():CanSpeakLanguage(tostring(language.uniqueID))
		end,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			local color = self:GetColor(self, speaker, text)
			local icon = ix.util.GetMaterial(self.icon)
			local name = bAnonymous and L"someone" or
				hook.Run("GetCharacterName", speaker, "ic") or
				(IsValid(speaker) and speaker:Name() or "Console")
			chat.AddText(icon, color, string.format(self.format, name))
		end
	})

	if (CLIENT) then
		ix.command.list["yell_"..string.Replace(language.uniqueID, 'language_', '')].OnCheckAccess = function(self, client) return client:GetCharacter():CanSpeakLanguage(language.uniqueID) end
		ix.command.list["whisper_"..string.Replace(language.uniqueID, 'language_', '')].OnCheckAccess = function(self, client) return client:GetCharacter():CanSpeakLanguage(language.uniqueID) end
		ix.command.list[string.Replace(language.uniqueID, 'language_', '')].OnCheckAccess = function(self, client) return client:GetCharacter():CanSpeakLanguage(language.uniqueID) end

		CHAT_RECOGNIZED[language.uniqueID] = true
		CHAT_RECOGNIZED[language.uniqueID .. "_unknown"] = true
		CHAT_RECOGNIZED["yell_" .. language.uniqueID .. "_unknown"] = true
		CHAT_RECOGNIZED["yell_" .. language.uniqueID] = true
		CHAT_RECOGNIZED["whisper_" .. language.uniqueID] = true
		CHAT_RECOGNIZED["whisper_" .. language.uniqueID .. "_unknown"] = true
	end
end

function ix.languages:FindByID(identifier)
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