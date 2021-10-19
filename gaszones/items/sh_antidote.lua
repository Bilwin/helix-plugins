
ITEM.name = "Antidote"
ITEM.description = "Helps to cure any disease and poisoning"
ITEM.model = Model("models/props_lab/jar01b.mdl")
ITEM.category = "Medicines"

ITEM.functions.Use = {
    name = "Use",
    tip = "use",
	OnRun = function(itemTable)
        local client = itemTable.player
        local character = client:GetCharacter()

        if (character) then
            local toxicity = character:GetToxicity()
            if (toxicity > 85) then
                client:Notify("It won't help you")
                return false
            end

            if timer.Exists('GasAntidote.'..client:AccountID()) then
                ix.util.NotifyLocalized('notNow', client)
                return false
            end

            timer.Create('GasAntidote.'..client:AccountID(), 5, 5, function()
                if !IsValid(client) then return end
                if !character then return end
                character:SubtractToxicity(5)
                if toxicity <= 0 then timer.Remove('GasAntidote.'..client:AccountID()) end
            end)

            client:EmitSound("items/smallmedkit1.wav")
        else
            return false
        end

        return true
	end
}
