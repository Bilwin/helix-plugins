
local PLUGIN = PLUGIN
local Schema = Schema

util.AddNetworkString("ixAcceptRank")
net.Receive("ixAcceptRank", function(len, client)
    local id = net.ReadString()
    local ent = net.ReadEntity() if !ent then return end
    if ent:GetClass() != "ix_cp_rank_manager" || !IsValid(ent) then return end
    if client:GetPos():DistToSqr(ent:GetPos()) > 5000 then return end
    if !client:IsCombine() then return end
    if !client:GetCharacter() then return end
    if !ix.ranks.stored[id] then return end
    if !ix.ranks.stored[id].CanTransfer then return end
    if table.HasValue(PLUGIN.blacklisted_ranks, ix.ranks.stored[id].uniqueID) and client:GetCharacter():GetSquad() ~= "gu" then return end
    if (ix.ranks.stored[id].xp or 0) > client:GetCharacter():GetCPPoint() then return end
    if ix.ranks.stored[id].is_limited && ix.ranks.IsLimitied(id, client:GetCharacter():GetSquad()) then
        client:Notify("У данного ранга превышен лимит!")
        return
    end

    client:GetCharacter():InitializeCP(id, client:GetCharacter():GetData("cmbSquad", "gu"), true)
    client:Notify("Вы заступили на службу в качестве "..ix.ranks.stored[id].name)
end)

function PLUGIN:PlayerLoadedCharacter(client, character)
    if character:IsCombine() then
        local current_rank = character:GetData("cmbRank")
        local current_squad = character:GetData("cmbSquad")
        if !current_rank then current_rank = 'rct' end
        if !current_squad then current_squad = 'gu' end
        if current_rank == 'ofc' then current_rank = '01' end
        character:InitializeCP(current_rank, current_squad)
    end
end

function PLUGIN:OnCPSet(character)
    Schema:AddCombineDisplayMessage(Format("%s заступил на службу в качестве %s", character:GetName(), ix.ranks.stored[character:GetData("cmbRank", "gu")].name), color_white)
    character:SetSpecialChannel("cmb")
end

function PLUGIN:OnCPDemoted(character)
    Schema:AddCombineDisplayMessage(Format("%s снялся с службы", character:GetName()), Color(255, 0, 0))
    character:SetSpecialChannel(SCHANNEL_NONE)
end

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_cp_rank_manager")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("cpRanks", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("cpRanks") or {}) do
		local ranks = ents.Create("ix_cp_rank_manager")

		ranks:SetPos(v[1])
		ranks:SetAngles(v[2])
		ranks:Spawn()
	end
end