
do
    local COMMAND = {}
    COMMAND.description = "Sets the satiety of a player"
    COMMAND.arguments = {ix.type.player, ix.type.number}
    COMMAND.argumentNames = {"Player", "Amount"}
    COMMAND.adminOnly = true

    function COMMAND:OnRun(self, pl, target, amount)
        local bStatus = ix.config.Get( "needsEnabled", true ) or true

        if bStatus then
            ix.Hunger:SetSatiety( target, tonumber(amount) )
        end
    end

    ix.command.Add("CharSetSatiety", COMMAND)
end

do
    local COMMAND = {}
    COMMAND.description = "Sets the saturation of a player"
    COMMAND.arguments = {ix.type.player, ix.type.number}
    COMMAND.argumentNames = {"Player", "Amount"}
    COMMAND.adminOnly = true

    function COMMAND:OnRun(self, pl, target, amount)
        local bStatus = ix.config.Get( "needsEnabled", true ) or true

        if bStatus then
            ix.Hunger:SetSaturation( target, tonumber(amount) )
        end
    end

    ix.command.Add("CharSetSaturation", COMMAND)
end