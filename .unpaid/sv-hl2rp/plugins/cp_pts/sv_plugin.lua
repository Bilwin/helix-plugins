
local PLUGIN = PLUGIN
local Schema = Schema
util.AddNetworkString("ixPTSync")
util.AddNetworkString("ixPTRequest.Create")
util.AddNetworkString("ixPTRequest.Join")
util.AddNetworkString("ixPTRequest.Leave")

net.Receive("ixPTRequest.Create", function(len, client)
    ix.patrolgroups.Create(client)
end)

net.Receive("ixPTRequest.Leave", function(len, client)
    ix.patrolgroups.Leave(client)
end)

net.Receive("ixPTRequest.Join", function(len, client)
    local id = net.ReadInt(12)
    ix.patrolgroups.Join(client, id)
end)

netstream.Hook("ixPTRequest.Kick", function(client, steamid)
    target = ix.util.FindPlayer(steamid)
    if !target then return end
    local pt_id = client.m_iPTid
    local is_owner = client.m_bIsPTOwner
    if !is_owner then return end
    local stored = ix.patrolgroups.stored[pt_id]
    if stored.owner ~= client then return end
    if target == client then return end
    local target_team = target.m_iPTid
    if target_team ~= pt_id then return end
    table.RemoveByValue(stored.members, target)
    target.m_bInPT = nil
    target.m_iPTid = nil
    target.m_bIsPTOwner = nil
    ix.patrolgroups.Sync()
    target:Notify('Вас выгнали с ПГ #' .. pt_id)
    client:Notify("Вы успешно выгнали юнита "..target:GetCharacter():GetName())
    Schema:AddCombineDisplayMessage(Format("%s был исключен с ПГ #%s", target:GetCharacter():GetName(), pt_id), Color(255, 0, 0))
end)

function ix.patrolgroups.Sync()
    local data = table.Copy(ix.patrolgroups.stored)

    if !table.IsEmpty(data) then
        for id, data in ipairs(data) do
            for clientID, client in ipairs(data.members) do
                data.members[clientID] = tostring(client:SteamID())
            end

            if data.owner and IsValid(data.owner) and data.owner:IsPlayer() then
                data.owner = tostring(data.owner:SteamID())
            end
        end
    end

    net.Start('ixPTSync')
        net.WriteCompressedTable(data)
    net.Broadcast()
end

function ix.patrolgroups.Create(client)
    if !client:IsCombine() then return false end
    if client.m_bInPT then return false end
    local pt_id

    if table.IsEmpty(ix.patrolgroups.stored) then
        pt_id = 1
    else
        pt_id = table.Count(ix.patrolgroups.stored) + 1
    end

    ix.patrolgroups.stored[pt_id] = {
        owner = client,
        members = {client}
    }

    client.m_bInPT = true
    client.m_iPTid = pt_id
    client.m_bIsPTOwner = true

    ix.patrolgroups.Sync()
    hook.Run('PostPTCreated', client, pt_id)
end

function ix.patrolgroups.Remove(id)
    if ix.patrolgroups.stored[id] then
        local members = ix.patrolgroups.stored[id].members

        if !table.IsEmpty(members) then
            for _, client in ipairs(members) do
                if IsValid(client) and client:GetCharacter() then
                    client.m_bInPT = nil
                    client.m_iPTid = nil
                    client.m_bIsPTOwner = nil
                    client:Notify('ПГ #'..id..' был расформирован')
                end
            end
        end

        ix.patrolgroups.stored[id] = nil
        ix.patrolgroups.Sync()
        hook.Run('PostPTRemoved', id)
    end
end

function ix.patrolgroups.Join(client, id)
    if !client:IsCombine() then return false end
    if client.m_bInPT then
        ix.patrolgroups.Leave(client)
    end

    local stored = ix.patrolgroups.stored[id]
    if stored then
        table.insert(stored.members, client)
        client.m_bInPT = true
        client.m_iPTid = id
        ix.patrolgroups.Sync()
        client:Notify("Вы вступили в ПГ #"..id)
        hook.Run("OnJoinedPT", client, id)
    end
end

function ix.patrolgroups.Leave(client)
    local current_team = client.m_iPTid
    local in_pt = client.m_bInPT
    local is_owner = client.m_bIsPTOwner

    if in_pt then
        local pt_table = ix.patrolgroups.stored[current_team]
        if pt_table then
            local pt_owner = pt_table.owner
            if pt_owner == client and is_owner then
                ix.patrolgroups.Remove(current_team)
            else
                table.RemoveByValue(pt_table.members, client)
                client.m_bInPT = nil
                client.m_iPTid = nil
                client.m_bIsPTOwner = nil
                client:Notify('Вы успешно покинули ПГ #' .. current_team)
                ix.patrolgroups.Sync()
                hook.Run("PostLeavePT", client, current_team)
            end
        end
    end
end

function PLUGIN:OnJoinedPT(client, id)
    Schema:AddCombineDisplayMessage(Format("%s присоединился к ПГ #%s", client:GetCharacter():GetName(), id), Color(255, 255, 255))
end

function PLUGIN:PostPTCreated(client, id)
    client:Notify("Вы создали ПГ #" .. id)
    Schema:AddCombineDisplayMessage(Format("Был создан ПГ #%s, создавший: %s", id, client:GetCharacter():GetName()), Color(255, 255, 255))
end

function PLUGIN:PostLeavePT(client, id)
    Schema:AddCombineDisplayMessage(Format("%s покинул ПГ #%s", client:GetCharacter():GetName(), id), Color(255, 255, 255))
end

function PLUGIN:PostPTRemoved(id)
    Schema:AddCombineDisplayMessage(Format("ПГ #%s был расформирован", id), Color(255, 255, 255))
end

function PLUGIN:PlayerLoadedCharacter(client, character, oldChar)
    ix.patrolgroups.Leave(client)
end

function PLUGIN:OnCPDemoted(character)
    local client = character:GetPlayer()
    ix.patrolgroups.Leave(client)
end

function PLUGIN:OnCharacterDisconnect(client, character)
    ix.patrolgroups.Leave(client)
end