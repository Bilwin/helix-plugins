
PLUGIN.name = "Diseases"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adding diseases"
PLUGIN.schema = "Any"
PLUGIN.version = 'deprecated'
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
    Sorry for not making a disease system running on meta tables.
    I think I will do it soon.

    If you want to add your own disease,
    please add the file to the `diseases` folder and name it without the prefix sh_, sv_, cl_ and others.
    And also add the disease (Filename) to the `ix.Diseases.Registered` table.
    After import, please restart the server to initialize.

    This plugin supports Lua Refresh, so you don't have to worry that this particular plugin is causing errors.
    Client-side diseases functions look bad because they couldn't get the function as a string value.
    Also, if you want your disease to work on the client side, add the field `functionsIsClientside = true`.

    Diseases can be stackable like that
    `cough;blindness` in GetCharacter():GetDisease()
    And can be removable by stack like
    `ix.Diseases:DisinfectPlayer(pl, "cough")
    And GetDisease() be like that
    `blindness`
]]

local ix = ix or {}
ix.Diseases = ix.Diseases or {}

ix.util.Include("sv_hooks.lua", "server")
ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("sh_lang.lua", "shared")
