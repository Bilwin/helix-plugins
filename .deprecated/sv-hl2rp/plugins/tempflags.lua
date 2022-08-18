
local PLUGIN = PLUGIN
PLUGIN.name = "Temporary Flags"
PLUGIN.author = "wildflowericecoffee"
PLUGIN.description = "Gives a player flags that expire after time. Requires the 'Player Flags' plugin."

local plyFlagsPlugin = ix.plugin.Get("playerflags")
if !plyFlagsPlugin then return end

local constantTable = {
    s = 1,          -- seconds
    m = 60,         -- minutes
    h = 3600,       -- hours
    d = 86400,      -- days
    w = 604800,     -- weeks
    n = 2592000,    -- months
    y = 31536000    -- years
}

function PLUGIN:LengthToSeconds(length)
    local constant = length:sub(-1)
    local multiplier = length:sub(1, -2)

    return tonumber(multiplier) * tonumber(constantTable[constant])
end

if SERVER then
    function PLUGIN:CheckTempFlags(client)
        local tempFlags = client:GetData("tempFlags", "")
        local timestamp = client:GetData("tempFlagsExpire")

        if not timestamp then return end

        if os.time() > timestamp then
            plyFlagsPlugin:TakePlayerFlags(client, tempFlags)
            
            client:SetData("tempFlags", nil)
            client:SetData("tempFlagsExpire", nil)
            
            client:Notify(string.format(
                "Ваши '%s' флаги истекли: %s",
                tempFlags,
                os.date("%H:%M:%S - %d/%m/%Y", timestamp)
            ))
        end
    end

    function PLUGIN:PlayerLoadout(client)
        if not plyFlagsPlugin then return end

        self:CheckTempFlags(client)
    end
    
    function PLUGIN:SaveData()
        if not plyFlagsPlugin then return end

        for _, client in ipairs(player.GetAll()) do
            self:CheckTempFlags(client)
        end
    end
end

ix.command.Add("PlyGiveTempFlag", {
    description = "Gives a player temporary flags.",
    privilege = "Helix - Manage Player Flags",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.string,
        ix.type.string
    },
    syntax = "<player target> <string flags> <string length (number)(s/m/h/d/w/n/y)>",
    OnRun = function(self, client, target, flags, length)
        if not plyFlagsPlugin then 
            return "The 'Player Flags' plugin is not installed or disabled!"
        end

        local length = length:match("(%d+[smhdwny])")

        if not length then
            return "Invalid length!"
        end

        local timestamp = os.time() + PLUGIN:LengthToSeconds(length)
        local date = os.date("%H:%M:%S - %d/%m/%Y", timestamp)

        plyFlagsPlugin:GivePlayerFlags(target, flags)
        
        target:SetData("tempFlags", flags)
        target:SetData("tempFlagsExpire", timestamp)

        ix.util.Notify(string.format(
            "%s выдал '%s' флаги для %s до: %s",
            client:Name(),
            flags,
            target:Name(),
            date
        ))
    end
})