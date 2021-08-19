
local PLUGIN = PLUGIN
PLUGIN.name = "XP System"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds XP whitelisted system"
PLUGIN.schema = "any"
PLUGIN.version = 1.0.1
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
PLUGIN.readme = [[
    This plugin adds the XP system to the server, if it is enabled.
    If used correctly, you can make it so that you need to have some XP to select a class.
    The table ix.XPSystem.whitelists contains fractions and classes for it, and XP need (Classes are necessary!)
]]

do
    ix.char.RegisterVar("XP", {
        field = "XP",
        fieldType = ix.type.number,
        isLocal = true,
        bNoDisplay = true,
        default = 0
    })
end

ix.XPSystem = {}
ix.XPSystem.whitelists = {
    --[FACTION_CITIZEN] = {
    --    [CLASS_CITIZEN] = 0,
    --    [CLASS_CWU]     = 5
    --},
    --[FACTION_MPF] = {
    --    [CLASS_MPR]     = 50,
    --    [CLASS_MPU]     = 75,
    --    [CLASS_EMP]     = 100
    --},
    --[FACTION_OTA] = {
    --    [CLASS_OWS]     = 200,
    --    [CLASS_EOW]     = 300
    --},
    --[FACTION_ADMIN] = {
    --    [CLASS_ADMIN]   = 600
    --}
}

ix.util.Include("sh_config.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_language.lua")