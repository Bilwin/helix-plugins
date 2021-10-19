
PLUGIN.name = "Primary Needs"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 'Need to rework'
PLUGIN.license = [[
    This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.
    In jurisdictions that recognize copyright laws, the author or authors
    of this software dedicate any and all copyright interest in the
    software to the public domain. We make this dedication for the benefit
    of the public at large and to the detriment of our heirs and
    successors. We intend this dedication to be an overt act of
    relinquishment in perpetuity of all present and future rights to this
    software under copyright law.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
    For more information, please refer to <http://unlicense.org/>
]]

do
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
end

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