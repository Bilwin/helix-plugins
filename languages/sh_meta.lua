
local PLUGIN = PLUGIN
local CHAR = ix.meta.character
local tostring = tostring

function CHAR:CanSpeakLanguage(language)
	local charLanguages = string.Split( tostring(self:GetAdditionalLanguages()), ';' )
    local bStatus = false

	if (charLanguages and !table.IsEmpty(charLanguages)) then
		if (table.HasValue(charLanguages, language)) then
            bStatus = true
		end
	end

	return bStatus
end

if (SERVER) then
    function CHAR:AddLanguage(language)
        local langTable = ix.languages:GetAll()[language]
        if (langTable) then
            if self:CanSpeakLanguage(language) then return end
            self:SetAdditionalLanguages( tostring( self:GetAdditionalLanguages() ) .. ';' .. tostring( language ) )
            hook.Run('CharacterLearnedLanguage', self, language, langTable)
        else
            return false, 'unknown table'
        end
    end

    function CHAR:RemoveLanguage(language)
        local langTable = ix.languages:GetAll()[language]
        if (langTable) then
            if self:GetAdditionalLanguages():find(tostring(language)) then
                local charLanguages = string.Split( tostring(self:GetAdditionalLanguages()), ';' )
                for _, charLanguage in pairs(charLanguages) do
                    if (charLanguage == language) then
                        table.RemoveByValue(charLanguages, language)
                    end
                end
                charLanguages = table.concat(charLanguages, ';')
                self:SetAdditionalLanguages( tostring(charLanguages) )
                hook.Run('CharacterUnLearnedLanguage', self, language, langTable)
            end
        else
            return false, 'unknown table'
        end
    end
end