
PLUGIN.name = "Special Radios"
PLUGIN.description = "Allows Combine Units to communicate not through a radio"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "HL2 RP"

ix.specialRadios = ix.specialRadios or {factionsData = {}}
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")

SCHANNEL_NONE = "none"

do
    local META = FindMetaTable("Player")
    function META:GetSpecialChannel()
        local character = self:GetCharacter()
        if (character) then
            return character:GetSpecialChannel()
        else
            return SCHANNEL_NONE
        end
    end
end

ix.char.RegisterVar("specialChannel", {
    field = "specialChannel",
    fieldType = ix.type.number,
    default = SCHANNEL_NONE,
    bNoDisplay = true
})

ix.config.Add("enableSpecialRadios", true, "Whether or no we need to enable special radio channels", nil, {
    category = PLUGIN.name
})

if (CLIENT) then
    --[[function PLUGIN:LoadFonts()
        surface.CreateFont("DebugFixedRadio", {
			font = "BudgetLabel",
			extended = true,
			size = SScale(5),
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

            if istable(factionIndices[character:GetFaction()].radioChannels) then
                for _, v in ipairs(factionIndices[character:GetFaction()].radioChannels) do
                    radioChannels[#radioChannels + 1] = v
                end

                local channelsText = "Special Channels: " .. ((#radioChannels > 0) and table.concat(radioChannels, ", ") or "нет")

                local currChannel = character:GetSpecialChannel()
                local currentText = "Current Special Channel: " .. (currChannel and currChannel or SCHANNEL_NONE)

                draw.SimpleTextOutlined(currentText, "DebugFixedRadio",
                    ScrW()-5, ScrH()*.5, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, Color(0, 0, 0))

                draw.SimpleTextOutlined(channelsText, "DebugFixedRadio",
                    ScrW()-5, ScrH()*.514, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, Color(0, 0, 0))
            end
        end
    end]]
end

function PLUGIN:InitializedPlugins()
    if (SERVER) then
        self:InitFactions()
    end
end