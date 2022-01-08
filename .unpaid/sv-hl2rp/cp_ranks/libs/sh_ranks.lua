
local PLUGIN = PLUGIN
ix.ranks = ix.ranks or {}
ix.ranks.stored = ix.ranks.stored or {}

function ix.ranks.Create(uniqueID, data)
    data.name = data.name or "Undefined"
    data.description = data.description or "Undefined"
    data.callback = data.callback
    data.onDemote = data.onDemote
    data.weapons = data.weapons or {}
    data.xp = data.xp or 0
    data.IsConnectGroup = data.IsConnectGroup or false
    data.IsCanTake = data.IsCanTake or false
    data.CanTransfer = data.CanTransfer or true
    data.IsCMD = data.IsCMD or false
    data.IsCanCreateGroup = data.IsCanCreateGroup or false
    data.armband_code = data.armband_code or "(255,255,255)_3_(255,0,0,255)_0_(255,255,255,255)_0"
    data.bodygroups = data.bodygroups
    data.lp_restricted = data.lp_restricted or false
    data.lp_limit_per_day = data.lp_limit_per_day or 0
    data.uniqueID = uniqueID
    ix.ranks.stored[uniqueID] = data
end

function ix.ranks.LoadFromDir(dir)
    for _, v in ipairs( file.Find(dir.."/*.lua", "LUA") ) do
		local niceName = v:sub(4, -5)

		RANK = {}
			ix.util.Include(dir.."/"..v)

			RANK.name = RANK.name or "Undefined"
            RANK.description = RANK.description or "Undefined"
            RANK.callback = RANK.callback
            RANK.onDemote = RANK.onDemote
            RANK.weapons = RANK.weapons or {}
            RANK.xp = RANK.xp or 0
            RANK.IsConnectGroup = RANK.IsConnectGroup or false
            RANK.IsCanTake = RANK.IsCanTake or false
            RANK.CanTransfer = RANK.CanTransfer or true
            RANK.IsCMD = RANK.IsCMD or false
            RANK.IsCanCreateGroup = RANK.IsCanCreateGroup or false
            RANK.armband_code = RANK.armband_code or "(255,255,255)_3_(255,0,0,255)_0_(255,255,255,255)_0"
            RANK.bodygroups = RANK.bodygroups
            RANK.lp_restricted = RANK.lp_restricted or false
            RANK.lp_limit_per_day = RANK.lp_limit_per_day or 0
			RANK.uniqueID = RANK.uniqueID or niceName

            ix.ranks.stored[RANK.uniqueID] = RANK
		RANK = nil
	end
end

function ix.ranks.IsLimitied(rank, squad)
    if ix.ranks.stored[rank] && ix.ranks.stored[rank].is_limited then
        local players = player.GetAll()
        local is_limited = false

        for i = 1, #players do
            local cl = players[i]
            if !cl:IsCombine() then continue end
            if !cl:GetCharacter() then continue end
            if cl:GetCharacter():GetSquad() == squad && cl:GetCharacter():GetCPRank().uniqueID == rank then
                is_limited = true
                break
            end
        end

        return is_limited
    end

    return false
end

function PLUGIN:InitializedPlugins()
    ix.ranks.LoadFromDir(self.folder..'/ranks')
end