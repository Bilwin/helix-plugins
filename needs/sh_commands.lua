
do
    ix.command.Add("CharSetSatiety", {
        description = "Sets the satiety of a player.",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, pl, target, amount)
            local bStatus = ix.config.Get( "needsEnabled", true ) or true

            if bStatus then
                ix.Hunger:SetCharSatiety( target, tonumber(amount) )
            end
        end
    })
    
    ix.command.Add("CharSetSaturation", {
        description = "Sets the saturation of a player.",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, pl, target, amount)
            local bStatus = ix.config.Get( "needsEnabled", true ) or true

            if bStatus then
                ix.Hunger:SetCharSaturation( target, tonumber(amount) )
            end
        end
    })
end