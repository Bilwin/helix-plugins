
PLUGIN.name = "Special Radios"
PLUGIN.description = "Allows Combine Units to communicate not through a radio"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "HL2 RP"
SCHANNEL_NONE = "none"

ix.specialRadios = ix.specialRadios or {factionsData = {}}

ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")

local PLAYER = FindMetaTable("Player")
function PLAYER:GetSpecialChannel()
    return self:GetCharacter():GetSpecialChannel() or SCHANNEL_NONE
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

function PLUGIN:InitializedPlugins()
    if SERVER then
        for index, data in ipairs(ix.faction.indices) do
            if data.radioChannels and istable(data.radioChannels) then
                ix.specialRadios:RegisterFaction(index, data.radioChannels)
            end
        end

        ix.specialRadios:RegisterChannel("cmb")
        ix.specialRadios:RegisterChannel("tac3")
        ix.specialRadios:RegisterChannel("tac5")
        ix.specialRadios:RegisterChannel("ota")
    end
end
