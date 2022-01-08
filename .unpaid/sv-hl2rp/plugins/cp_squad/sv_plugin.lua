
local PLUGIN = PLUGIN
local Schema = Schema

function PLUGIN:PlayerLoadedCharacter(client, character)
    if character:IsCombine() then
        character:CalculateUniformSkin(true)
    end
end

function PLUGIN:OnCPSet(character)
    if character:IsCombine() then
        character:CalculateUniformSkin(true)
    end
end

function PLUGIN:OnCPSquadDemoted(character, oldSquad)
    Schema:AddCombineDisplayMessage(Format("%s покинул подразделение %s", character:GetName(), oldSquad:upper()), Color(255, 255, 255))
end

function PLUGIN:OnCPSquadInstanced(character, _, newSquad)
    Schema:AddCombineDisplayMessage(Format("%s вступил в подразделение %s", character:GetName(), newSquad:upper()), Color(255, 255, 255))
end

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_cp_squad_manager")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("cpSquads", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("cpSquads") or {}) do
		local squads = ents.Create("ix_cp_squad_manager")

		squads:SetPos(v[1])
		squads:SetAngles(v[2])
		squads:Spawn()
	end
end

util.AddNetworkString("ixAcceptSquad")
net.Receive("ixAcceptSquad", function(len, client)
    local id = net.ReadString()
    local ent = net.ReadEntity() if !ent then return end
    if ent:GetClass() != "ix_cp_squad_manager" || !IsValid(ent) then return end
    if client:GetPos():DistToSqr(ent:GetPos()) > 5000 then return end
    if !client:IsCombine() then return end
    if !client:GetCharacter() then return end
    if table.HasValue(PLUGIN.blacklisted_ranks, client:GetCharacter():GetCPRank().uniqueID) then return end
    if !ix.squads.stored[id] then return end
    if ix.squads.stored[id].isPrivate then return end
    if (ix.squads.stored[id].xp or 0) > client:GetCharacter():GetCPPoint() then return end
    if ix.squads.IsLimited(id) then client:Notify("Максимальное количество сотрудников в выбранном подразделении!") return end
    if ix.ranks.stored[client:GetCharacter():GetCPRank().uniqueID].is_limited && ix.ranks.IsLimitied(client:GetCharacter():GetCPRank().uniqueID, id) then
        client:Notify("Вы не можете перейти в другое подразделение будучи офицером (лимит)!")
        return
    end

    client:GetCharacter():SetSquad(id)
    local name = 'C'..ix.config.Get("cpCityNumber", 17)
    local prime = client:GetCharacter():GetData("cmbPrimeID", Schema:ZeroNumber(math.random(1, 99999), 5))
    name = name..'.MPF.'..string.upper(ix.squads.stored[id].uniqueID)..'.'..client:GetCharacter():GetCPRank().name..' #'..prime
    client:GetCharacter():SetName(name:upper())

    client:Notify("Вы присоединились к подразделению "..string.upper(ix.squads.stored[id].uniqueID))
    hook.Run("CharacterJoinedSquad", client, id)
end)