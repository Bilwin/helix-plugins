
PLUGIN.name = "Primary Needs"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 'Need to rework'

ix.char.RegisterVar("saturation", {
    field = "saturation",
    fieldType = ix.type.number,
    isLocal = true,
    bNoDisplay = true,
    default = 60
})

ix.char.RegisterVar("satiety", {
    field = "satiety",
    fieldType = ix.type.number,
    isLocal = true,
    bNoDisplay = true,
    default = 60
})

ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_meta.lua")
ix.util.Include("sh_config.lua")
ix.util.Include("sh_commands.lua")

if CLIENT then
    ix.bar.Add( function()
		return math.max( LocalPlayer():GetLocalVar("saturation") / 100, 0 )
	end, Color( 68, 106, 205 ), nil, "saturation", "hudSaturation" )

	ix.bar.Add( function()
		return math.max( LocalPlayer():GetLocalVar("satiety") / 100, 0 )
	end, Color( 203, 151, 0 ), nil, "satiety", "hudSatiety" )
end