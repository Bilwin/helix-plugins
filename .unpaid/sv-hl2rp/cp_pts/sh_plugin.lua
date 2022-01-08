
local PLUGIN = PLUGIN
PLUGIN.name = "Патрульные Группы"
PLUGIN.author = "Bilwin"
ix.patrolgroups = ix.patrolgroups or {}
ix.patrolgroups.stored = ix.patrolgroups.stored or {}
ix.util.Include("sv_plugin.lua")
ix.util.Include("sh_cmds.lua")

local meta = PLAYER
function meta:InPT()
    local bStatus = false

    for _, data in ipairs(ix.patrolgroups.stored) do
        if data.members and !table.IsEmpty(data.members) then
            for _, client in ipairs(data.members) do
                if client == self then
                    bStatus = true
                    break
                end
            end
        end
    end

    return bStatus
end

function meta:GetPT()
    local stored, _id

    for id, data in ipairs(ix.patrolgroups.stored) do
        if data.members and !table.IsEmpty(data.members) then
            for _, client in ipairs(data.members) do
                if client == self then
                    stored = ix.patrolgroups.stored[id]
                    _id = id
                    break
                end
            end
        end
    end

    return stored, _id
end

if CLIENT then
    net.Receive("ixPTSync", function(len)
        local normal_table = net.ReadCompressedTable()
        for _, data in ipairs(normal_table) do
            if data.members and !table.IsEmpty(data.members) then
                for clientID, client in ipairs(data.members) do
                    data.members[clientID] = ix.util.FindPlayer(client)
                end
            end

            if data.owner then
                data.owner = ix.util.FindPlayer(data.owner)
            end
        end

        ix.patrolgroups.stored = normal_table
    end)
end