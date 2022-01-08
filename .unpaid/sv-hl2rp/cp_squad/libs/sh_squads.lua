
local PLUGIN = PLUGIN
ix.squads = ix.squads or {}
ix.squads.stored = ix.squads.stored or {}

function ix.squads.Create(uniqueID, data)
    data.name = data.name or "Undefined"
    data.description = data.description or "Undefined"
    data.onInstanced = data.onInstanced
    data.onDemoted = data.onDemoted
    data.weapons = data.weapons or {}
    data.xp = data.xp or 0
    data.uniform = data.uniform
    data.isPrivate = data.isPrivate or false
    data.uniqueID = uniqueID
    ix.squads.stored[uniqueID] = data
end

function ix.squads.LoadFromDir(dir)
    for _, v in ipairs( file.Find(dir.."/*.lua", "LUA") ) do
		local niceName = v:sub(4, -5)

		SQUAD = {}
			ix.util.Include(dir.."/"..v)

			SQUAD.name = SQUAD.name or "Undefined"
            SQUAD.description = SQUAD.description or "Undefined"
            SQUAD.onInstanced = SQUAD.onInstanced
            SQUAD.onDemoted = SQUAD.onDemoted
            SQUAD.weapons = SQUAD.weapons or {}
            SQUAD.xp = SQUAD.xp or 0
            SQUAD.uniform = SQUAD.uniform
            SQUAD.isPrivate = SQUAD.isPrivate or false
			SQUAD.uniqueID = SQUAD.uniqueID or niceName
            SQUAD.max = SQUAD.max

            ix.squads.stored[SQUAD.uniqueID] = SQUAD
        SQUAD = nil
	end
end

function ix.squads.IsLimited(squad)
    if ix.squads.stored[squad] && ix.squads.stored[squad].max then
        local players = player.GetAll()
        local max = ix.squads.stored[squad].max
        local count = 0

        for i = 1, #players do
            local cl = players[i]
            if !cl:GetCharacter() then continue end
            if !cl:IsCombine() then continue end
            if cl:GetCharacter():GetSquad() == squad then
                count = count + 1
            end
        end

        if count >= max then
            return true
        end
    end

    return false
end

function PLUGIN:InitializedPlugins()
    ix.squads.LoadFromDir(self.folder..'/squads')
end