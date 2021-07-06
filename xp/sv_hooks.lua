
local PLUGIN = PLUGIN
local _tonumber = tonumber
local _math_Clamp = math.Clamp
local min, max = 0, 5000

ix.log.AddType("xpSystemAdd", function(client, amount)
    return string.format("%s was added %s XP.", client:Name(), amount)
end)

ix.log.AddType("xpSystemSet", function(client, amount)
    return string.format("%s was set %s XP.", client:Name(), amount)
end)

ix.log.AddType("xpSystemAbort", function(client)
    return string.format("%s was abort all XP.", client:Name())
end)

function ix.XPSystem.AddXP(client, xp)
    if IsValid(client) and client:IsPlayer() then
        if !xp then xp = 0 end
        local char = client:GetCharacter()

        if char then
            local ffCalculated = _math_Clamp(char:GetXP() + xp, min, max)
            char:SetXP(ffCalculated)
            ix.log.Add(client, "xpSystemAdd", _math_Clamp(xp, min, max))
            ix.util.NotifyLocalized("xpGainTime", client, _math_Clamp(xp, min, max))
        end
    end
end

function ix.XPSystem.SetXP(client, xp)
    if IsValid(client) and client:IsPlayer() then
        if !xp then xp = 0 end
        local char = pl:GetCharacter()

        if char then
            local ffCalculated = _math_Clamp(xp, min, max)
            char:SetXP(ffCalculated)
            ix.log.Add(client, "xpSystemSet", _math_Clamp(xp, min, max))
            ix.util.NotifyLocalized("xpSet", client, _math_Clamp(xp, min, max))
        end
    end
end

function ix.XPSystem.XPAbort(client)
    if IsValid(client) and client:IsPlayer() then
        local char = client:GetCharacter()

        if char then
            char:SetXP(0)
            ix.log.Add(client, "xpSystemAbort")
            ix.util.NotifyLocalized("xpAborted", client)
        end
    end
end

local _wl = ix.XPSystem.whitelists
function ix.XPSystem.IsWhitelisted(client, faction, class)
    if IsValid(client) and client:IsPlayer() then
        if !faction then return false end
        if !class then return false end
        local char = pl:GetCharacter()

        if !table.IsEmpty(_wl) then
            for k, v in ipairs(_wl) do
                if k == faction then
                    for i, l in SortedPairs(v) do
                        if i == class then
                            if char:GetXP() >= l then 
                                return true
                            end

                            break
                        end
                    end
                end
            end
        else
            ErrorNoHalt('ix.XPSystem.whitelists has no values!')
        end

        return false
    end
end

local delay = 60 * 10 -- Every 10 minutes
function PLUGIN:PostPlayerLoadout(client)
    if !ix.config.Get("XPGainEnabled", false) then return end
    if ix.config.Get("maxXPGain", 0) == 0 then return end

    local uniqueID = 'xpGain.'..client:AccountID()
    if timer.Exists(uniqueID) then
        timer.Remove(uniqueID)
    end

    if client:GetCharacter() then
        timer.Create(uniqueID, delay, 0, function()
            if !IsValid(client) then timer.Remove(uniqueID) end
            ix.XPSystem.AddXP(client, ix.config.Get("maxXPGain", 0))
        end)
    end
end

function PLUGIN:PlayerDisconnected(pl)
    local uniqueID = 'xpGain.'..client:AccountID()
    if timer.Exists(uniqueID) then
        timer.Remove(uniqueID)
    end
end
