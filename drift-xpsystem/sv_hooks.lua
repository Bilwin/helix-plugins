local plugin = PLUGIN

ix.log.AddType("xpSystemAdd", function(pl, amount)
    return string.format("%s was added %s XP.", pl:Name(), amount)
end)

ix.log.AddType("xpSystemSet", function(pl, amount)
    return string.format("%s was set %s XP.", pl:Name(), amount)
end)

ix.log.AddType("xpSystemAbort", function(pl)
    return string.format("%s was abort all XP.", pl:Name())
end)

local _tonumber = tonumber
local min, max = 0, 5000
function ix.XPSystem:AddXP(pl, xp)
    if IsValid(pl) and pl:IsPlayer() then
        if not xp then xp = 0 end
        local char = pl:GetCharacter() or false

        if char then
            if char:GetData("ix:XP", false) then
                char:SetData("ix:XP", math.Clamp(_tonumber(char:GetData("ix:XP", 0)) + _tonumber(xp), min, max))
            else
                char:SetData("ix:XP", math.Clamp(_tonumber(xp), min, max))
            end
            ix.log.Add(pl, "xpSystemAdd", math.Clamp(_tonumber(xp), min, max))
            
            ix.util.NotifyLocalized("xpGainTime", pl, math.Clamp(_tonumber(xp), min, max))
        end
    end
end

function ix.XPSystem:SetXP(pl, xp)
    if IsValid(pl) and pl:IsPlayer() then
        if not xp then xp = 0 end
        local char = pl:GetCharacter() or false

        if char then
            if char:GetData("ix:XP", false) then
                char:SetData("ix:XP", math.Clamp(_tonumber(xp), min, max))
            else
                char:SetData("ix:XP", math.Clamp(_tonumber(xp), min, max))
            end

            ix.log.Add(pl, "xpSystemSet", math.Clamp(_tonumber(xp), min, max))

            ix.util.NotifyLocalized("xpSet", pl, math.Clamp(_tonumber(xp), min, max))
        end
    end
end

function ix.XPSystem:XPAbort(pl)
    if IsValid(pl) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            if char:GetData("ix:XP", false) then
                char:SetData("ix:XP", 0)
            else
                char:SetData("ix:XP", 0)
            end

            ix.log.Add(pl, "xpSystemAbort")

            ix.util.NotifyLocalized("xpAborted", pl)
        end
    end
end

local _wl = ix.XPSystem.whitelists or {}
function ix.XPSystem:IsWhitelisted(pl, faction, class)
    if IsValid(pl) and pl:IsPlayer() then
        if not faction then return false end
        if not class then return false end
        local char = pl:GetCharacter()

        for k, v in ipairs(_wl) do
            if k == faction then
                for i, l in SortedPairs(v) do
                    if i == class then
                        if char:GetData("ix:XP", false) then
                            if char:GetData("ix:XP", 0) >= l then 
                                return true
                            else
                                return false
                            end
                        else
                            ix.XPSystem:AddXP(pl, 0)
                            return false
                        end
                    end
                end
            end
        end

        return false
    end
end

local xpgain = ix.config.Get("maxXPGain", 0)

local delay = 60 * 10 -- Every 10 minutes
function plugin:PostPlayerLoadout(pl)
    if not ix.config.Get("XPGainEnabled", false) then return end
    if xpgain == 0 then return end

    if pl:_TimerExists("XPGain::"..pl:SteamID64()) then
        pl:_RemoveTimer("XPGain::"..pl:SteamID64())
    end

    if pl:GetCharacter() then
        pl:_SetTimer("XPGain::"..pl:SteamID64(), delay, 0, function()
            ix.XPSystem:AddXP(pl, xpgain)
        end)
    end
end

function plugin:PlayerDisconnected(pl)
    if pl:_TimerExists("XPGain::"..pl:SteamID64()) then
        pl:_RemoveTimer("XPGain::"..pl:SteamID64())
    end
end
