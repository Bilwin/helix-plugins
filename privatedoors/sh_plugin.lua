
local PLUGIN = PLUGIN
PLUGIN.name = "Private Doors"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Allows you to add a player as a door owner"
PLUGIN.version = 1.0
PLUGIN.schema = "Any"

ix.char.RegisterVar("ownedDoors", {
    field = "ownedDoors",
	default = {},
    bNoNetworking = true,
	bNoDisplay = true,
	OnSet = function(character, door, bool)
		local ownerDoors = character:GetOwnedDoors()
		local mapID = door:MapCreationID()

		if mapID then
			ownerDoors[mapID] = bool and true or nil
		end

		character.vars.ownedDoors = ownerDoors
	end,
	OnGet = function(character, door)
		local ownerDoors = character.vars.ownedDoors or {}

		if IsValid(door) then
			return ownerDoors[door:MapCreationID()] and door or false
		else
			return ownerDoors
		end
	end
})

if CLIENT then
    netstream.Hook("HeavyChatNotify", function(data, color, icon)
        if !color then color = color_white end
        if !icon then
            for _, message in ipairs(data) do
                chat.AddText(color, message)
            end
        else
            local icon = ix.util.GetMaterial(icon)
            for _, message in ipairs(data) do
                chat.AddText(icon, color, message)
            end
        end
    end)
end

ix.util.Include("sv_plugin.lua")