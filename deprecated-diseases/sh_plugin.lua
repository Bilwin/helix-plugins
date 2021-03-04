
PLUGIN.name = "Diseases"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adding diseases"
PLUGIN.schema = "Any"
PLUGIN.license = [[
    Copyright 2021 Maxim Sukharev (Bilwin) All Rights Reserved
    This plugin is protected under by MPL-2.0 license
    Full copy of license is here: https://www.mozilla.org/en-US/MPL/2.0/
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
