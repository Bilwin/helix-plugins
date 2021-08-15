
local PLUGIN = PLUGIN

function PLUGIN:CanPlayerAccessDoor(client, door, access)
	local character = client:GetCharacter()
	return character:GetOwnedDoors(door)
end
