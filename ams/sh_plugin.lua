
local PLUGIN = PLUGIN
PLUGIN.name = "Advanced Medical System"
PLUGIN.description = "Introduction of heavy medicine and new features"
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

ix.AMS = ix.AMS or {}
ix.util.Include("sv_meta.lua")
ix.util.Include("sv_plugin.lua")
ix.util.IncludeDir(PLUGIN.folder..'/diseases', true)
ix.util.IncludeDir(PLUGIN.folder..'/wounds', true)

-- Limbs
ix.util.Include("sh_limbs.lua")
ix.util.Include("sv_limbs.lua")
ix.util.Include("sv_limbsmeta.lua")

do
    ix.char.RegisterVar("diseases", {
		field = "diseases",
		fieldType = ix.type.string,
        default = '',
		bNoDisplay = true
	})

    ix.char.RegisterVar("wounds", {
		field = "wounds",
		fieldType = ix.type.string,
        default = '',
		bNoDisplay = true
	})
end
