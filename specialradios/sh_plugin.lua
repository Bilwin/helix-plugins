
PLUGIN.name = "Special Radios"
PLUGIN.description = "Allows Combine Units to communicate not through a radio"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "HL2 RP"
SCHANNEL_NONE = "none"

ix.specialRadios = ix.specialRadios or {factionsData = {}}

ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")

function FindMetaTable("Player"):GetSpecialChannel()
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
        self:InitFactions()
        ix.specialRadios:RegisterChannel("cmb")
        ix.specialRadios:RegisterChannel("tac3")
        ix.specialRadios:RegisterChannel("tac5")
        ix.specialRadios:RegisterChannel("ota")
    end
end