local plugin = PLUGIN
plugin.name = "Diseases"
plugin.author = "Bilwin"
plugin.description = "Adding diseases"
plugin.license = [[
    Copyright 2020 Maxim Sukharev (Bilwin)
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
]]
plugin.readme = [[
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

ix.char.RegisterVar("diseaseInfo", { 
    field = "diseaseInfo",
    fieldType = ix.type.string,
    default = ""
})

local ix = ix or {}
ix.Diseases = ix.Diseases or {}

ix.util.Include("sv_hooks.lua", "server")
ix.util.Include("sh_meta.lua", "shared")