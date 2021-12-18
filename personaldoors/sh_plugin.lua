
local PLUGIN = PLUGIN
PLUGIN.name = "Personal Doors"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Allows you to add a player as a door owner"
PLUGIN.version = 1.01
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

if SERVER then
	function PLUGIN:CanPlayerAccessDoor(client, door, access)
		local character = client:GetCharacter()
		return character:GetOwnedDoors(door)
	end	
end

function PLUGIN:InitializedChatClasses()
    ix.command.Add("DoorAddOwner", {
        description = "Set the owner for the door you are looking at",
        privilege = "DoorOwnership",
        adminOnly = true,
        arguments = {ix.type.character},
        OnRun = function(self, client, target)
            if (target) then
                local targetDoor = client:GetEyeTrace().Entity
                if (IsValid(targetDoor) and targetDoor:IsDoor()) then
                    target:SetOwnedDoors(targetDoor, true)
                    local text = target:GetName().." now has keys to this door."
                    client:NotifyLocalized(text)
                else
                    client:NotifyLocalized("You are not looking at a valid door!")
                end
            end
        end
    })

    ix.command.Add("DoorRemoveOwner", {
        description = "Remove a specific owner for the door you are looking at",
        privilege = "DoorOwnership",
        adminOnly = true,
        arguments = {ix.type.character},
        OnRun = function(self, client, target)
            if (target) then
                local targetDoor = client:GetEyeTrace().Entity
                if (IsValid(targetDoor) and targetDoor:IsDoor()) then
                    if target:GetOwnedDoors(targetDoor) then
                        target:SetOwnedDoors(targetDoor, false)
                        local text = target:GetName().." no longer has keys to this door."
                        client:NotifyLocalized(text)
                        return
                    end
                end
                local text = target:GetName().." does not have keys to this door."
                client:NotifyLocalized(text)
            else
                client:NotifyLocalized("You are not looking at a valid door")
            end
        end
    })

    ix.command.Add("DoorPrintOwners", {
        description = "Print trace door owners",
        privilege = "DoorOwnership",
        adminOnly = true,
        OnRun = function(self, client)
            local targetDoor = client:GetEyeTrace().Entity
            if (IsValid(targetDoor) and targetDoor:IsDoor()) then
                local msg
                local owners = {}

                for _, client in pairs(player.GetAll()) do
                    local character = client:GetCharacter()
                    if character then
                        if character:GetOwnedDoors(targetDoor) then
                            table.insert(owners, Format("%s (%s)", character:GetName(), client:SteamID()))
                        end
                    end
                end

                if !table.IsEmpty(owners) then
                    msg = table.Copy(owners)
                else
                    msg = {'No one owns this door'}
                end

                netstream.Start(client, 'HeavyChatNotify', msg, color_white, 'icon16/key.png')
            end
        end
    })
end