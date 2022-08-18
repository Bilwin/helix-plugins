
PLUGIN.name = "Special Radios"
PLUGIN.description = "Allows Combine Units to communicate not through a radio"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "HL2 RP"

ix.specialRadios = ix.specialRadios || {factionsData = {}}
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")

SCHANNEL_NONE = "none"

function PLAYER:GetSpecialChannel()
    local character = self:GetCharacter()
    if (character) then
        return character:GetSpecialChannel()
    else
        return SCHANNEL_NONE
    end
end

ix.char.RegisterVar("specialChannel", {
    field = "specialChannel",
    fieldType = ix.type.string,
    default = SCHANNEL_NONE,
    bNoDisplay = true
})

ix.config.Add("enableSpecialRadios", true, "Whether or no we need to enable special radio channels", nil, {
    category = PLUGIN.name
})

if (CLIENT) then
    function PLUGIN:LoadFonts()
        surface.CreateFont("DebugFixedRadio", {
			font = "Open Sans",
			extended = true,
			size = SScale(8),
			weight = 550,
			antialias = true
		})
    end

    local LocalPlayer = LocalPlayer
    local IsValid = IsValid
    local draw = draw
    local factionIndices = ix.faction.indices
    function PLUGIN:HUDPaint()
        if (!IsValid(LocalPlayer())) then
            return
        end

        local character = LocalPlayer():GetCharacter()
        if (character) then
            local radioChannels = {}

            if istable(factionIndices[character:GetFaction()].radioChannels) and #factionIndices[character:GetFaction()].radioChannels > 1 then
                for _, v in ipairs(factionIndices[character:GetFaction()].radioChannels) do
                    radioChannels[#radioChannels + 1] = v
                end

                local channelsText = "Каналы: " .. ((#radioChannels > 0) and table.concat(radioChannels, ", ") or "нет")

                local currChannel = character:GetSpecialChannel()
                local currentText = "Текущий канал: " .. (currChannel and currChannel or SCHANNEL_NONE)

                draw.SimpleTextOutlined(currentText, "DebugFixedRadio",
                    ScrW()-5, ScrH()*.5, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, Color(0, 0, 0))

                draw.SimpleTextOutlined(channelsText, "DebugFixedRadio",
                    ScrW()-5, ScrH()*.52, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, Color(0, 0, 0))
            end
        end
    end
end

function PLUGIN:InitializedPlugins()
    if (SERVER) then
        self:InitFactions()
    end
end