
local whitelisted_codes = {['ЖК']=true, ['КК']=true}
netstream.Hook("ToggleCityCode", function(client, code)
    if whitelisted_codes[code] then
        --
    end
end)