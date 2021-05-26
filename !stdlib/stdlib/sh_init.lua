---      _      _ _ _ _
--   ___| |_ __| | (_) |__
--  / __| __/ _` | | | '_ \
--  \__ \ || (_| | | | |_) |
--  |___/\__\__,_|_|_|_.__/
--
-- Flux Standard Library
-- (Garry's Mod Extensions)
--
-- "...so that you don't have to"
-- Lua comes without batteries included. We include the batteries.
--
-- (C) TeslaCloud Studios
-- Released under the MIT license.

if IX_RELOADED then return end

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile 'sh_pon.lua'
    AddCSLuaFile 'cl_utils.lua'
    AddCSLuaFile 'sh_aliases.lua'
    AddCSLuaFile 'sh_class.lua'
    AddCSLuaFile 'sh_color.lua'
    AddCSLuaFile 'sh_file.lua'
    AddCSLuaFile 'sh_helpers.lua'
    AddCSLuaFile 'sh_math.lua'
    AddCSLuaFile 'sh_module.lua'
    AddCSLuaFile 'sh_player.lua'
    AddCSLuaFile 'sh_string.lua'
    AddCSLuaFile 'sh_table.lua'
    AddCSLuaFile 'sh_unit.lua'
    AddCSLuaFile 'sh_utils.lua'
    AddCSLuaFile 'sh_wrappers.lua'
    AddCSLuaFile 'sh_date.lua'
    AddCSLuaFile 'sh_datetime.lua'
    AddCSLuaFile 'sh_time.lua'
end

include 'sh_pon.lua'
include 'sh_aliases.lua'

include 'sh_helpers.lua'
include 'sh_string.lua'
include 'sh_table.lua'
include 'sh_math.lua'
include 'sh_utils.lua'
include 'sh_color.lua'
include 'sh_class.lua'
include 'sh_module.lua'
include 'sh_unit.lua'
include 'sh_player.lua'
include 'sh_file.lua'
include 'sh_wrappers.lua'
include 'sh_date.lua'
include 'sh_datetime.lua'
include 'sh_time.lua'

if CLIENT then
include 'cl_utils.lua'
end

_player, _team, _sound = player, team, sound