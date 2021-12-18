
local table_insert, string_replace = table.insert, string.Replace
rnlib.steamuser = rnlib.steamuser || {}
function rnlib.steamuser.GetGroupMembers(groupname, callback)
    local data = {}
    HTTP({
        url = 'http://steamcommunity.com/groups/'..groupname..'/memberslistxml/?xml=1',
        method = 'get',
        headers = {},
        success = function(code, body, header)
            if !body then rnlib.p('Unknown rnlib.steamuser:GetGroupMembers body! Code %s', code) end
            body = body:Split '\n'

            for _, value in ipairs(body) do
                if value:find '<steamID64>' then
                    table_insert(data, string_replace(value:match'%d+<', '<', ''))
                end
            end

            callback(data)
        end,
        failed = function(err)
            rnlib.p('HTTP Request Failed, rnlib.steamuser:GetGroupMembers -> %s', err)
        end
    })
end

function rnlib.steamuser.IsVACBanned(steamid64, callback)
    local status = false
    HTTP({
        url = 'https://steamcommunity.com/profiles/'..steamid64..'/?xml=1',
        method = 'get',
        headers = {},
        success = function(code, body, header)
            if !body then rnlib.p('Unknown rnlib.steamuser:IsVACBanned body! Code %s', code) end
            body = body:Split '\n'

            for _, value in ipairs(body) do
                if value:find '<vacBanned>1' then
                    status = true
                    break
                end
            end

            callback(status)
        end,
        failed = function(err)
            rnlib.p('HTTP Request Failed, rnlib.steamuser:IsVACBanned -> %s', err)
        end
    })
end

function rnlib.steamuser:GetProfileKey(steamid64, key, callback)
    HTTP({
        url = 'https://steamcommunity.com/profiles/'..steamid64..'/?xml=1',
        method = 'get',
        headers = {},
        success = function(code, body, header)
            if !body then rnlib.p('Unknown rnlib.steamuser:GetProfileKey body! Code %s', code) end
            body = body:Split '\n'
            local data

            for _, v in ipairs(body) do
                if v:find(key) then
                    data = v
                    break
                end
            end

            callback(data)
        end,
        failed = function(err)
            rnlib.p('HTTP Request Failed, rnlib.steamuser:GetProfileKey -> %s', err)
        end
    })
end