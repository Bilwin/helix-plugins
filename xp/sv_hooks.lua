
local PLUGIN = PLUGIN
local _tonumber = tonumber
local _math_Clamp = math.Clamp
local min, max = 0, 5000
local CHAR = ix.meta.character

ix.log.AddType("xpSystemAdd", function(client, amount)
    return string.format("%s was added %s XP.", client:Name(), amount)
end)

ix.log.AddType("xpSystemSet", function(client, amount)
    return string.format("%s was set %s XP.", client:Name(), amount)
end)

ix.log.AddType("xpSystemAbort", function(client)
    return string.format("%s was abort all XP.", client:Name())
end)

function CHAR:AddXP(xp)
    local ffCalculated = _math_Clamp(self:GetXP() + xp, min, max)
    self:SetXP(ffCalculated)
    ix.log.Add(self:GetPlayer(), "xpSystemAdd", _math_Clamp(xp, min, max))
    ix.util.NotifyLocalized("xpGainTime", self:GetPlayer(), _math_Clamp(xp, min, max))
end

function CHAR:SetXP(client, xp)
    local ffCalculated = _math_Clamp(xp, min, max)
    self:SetXP(ffCalculated)
    ix.log.Add(self:GetPlayer(), "xpSystemSet", _math_Clamp(xp, min, max))
    ix.util.NotifyLocalized("xpSet", self:GetPlayer(), _math_Clamp(xp, min, max))
end

function CHAR:XPAbort()
    char:SetXP(0)
    ix.log.Add(client, "xpSystemAbort")
    ix.util.NotifyLocalized("xpAborted", client)
end

function CHAR:XPWhitelisted(faction, class)
    if !faction then return false end
    if !class then return false end

    if !table.IsEmpty(PLUGIN.whitelists) then
        for k, v in ipairs(PLUGIN.whitelists) do -- redo
            if k == faction then
                for i, l in SortedPairs(v) do
                    if i == class then
                        if char:GetXP() >= l then 
                            return true
                        end
                    end
                end
            end
        end
    else
        ErrorNoHalt('XP whitelists has no values!')
    end

    return false
end

local delay = 60 * 10 -- Every 10 minutes
function PLUGIN:PostPlayerLoadout(client)
    if !ix.config.Get("XPGainEnabled", false) then return end
    if ix.config.Get("maxXPGain", 0) == 0 then return end

    local uniqueID = 'xpGain.'..client:AccountID()
    if timer.Exists(uniqueID) then timer.Remove(uniqueID) end

    if client:GetCharacter() then
        timer.Create(uniqueID, delay, 0, function()
            if !IsValid(client) then timer.Remove(uniqueID) end
            client:GetCharacter():AddXP(ix.config.Get("maxXPGain", 0))
        end)
    end
end

function PLUGIN:PlayerDisconnected(pl)
    local uniqueID = 'xpGain.'..client:AccountID()
    if timer.Exists(uniqueID) then timer.Remove(uniqueID) end
end
