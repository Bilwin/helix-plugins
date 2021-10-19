
local PLUGIN = PLUGIN

do
    ix.command.Add("CharSetToxicity", {
        description = "Set the toxicity value to the player",
        adminOnly = true,
        arguments = {
            ix.type.character,
            bit.bor(ix.type.number, ix.type.optional)
        },
        OnRun = function(self, client, target, value)
            if !value then value = 0 end
            target:SetToxicity(value)
            client:Notify(Format('You set %s toxicity to %s', target:GetName(), value))
        end,
        bNoIndicator = true
    })
end