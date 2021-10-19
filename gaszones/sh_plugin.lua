
local PLUGIN = PLUGIN
PLUGIN.name = "Toxic Gas Zones"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds toxic gas/poison zones"
PLUGIN.schema = "Any"

ix.util.Include('sh_meta.lua')
ix.util.Include('sh_commands.lua')
ix.util.Include('sv_plugin.lua')

do
    ix.char.RegisterVar("toxicity", {
		field = "toxicity",
		fieldType = ix.type.number,
        default = 0,
        isLocal = true,
		bNoDisplay = true
	})

    ix.config.Add("gasTickTime", 5, "The time in seconds it takes to check the player timer.", function(_, newValue)
        if (SERVER) then
            for _, client in ipairs( player.GetAll() ) do
                local uniqueID = client:AccountID()
                timer.Adjust('GasTick.'..uniqueID, newValue)
            end
        end
    end, {
        data = {min = 1, max = 60},
        category = PLUGIN.name
    })

    ix.config.Add("gasKillDelay", 5, "Timer that will choke the player", function(_, newValue)
        if (SERVER) then
            for _, client in ipairs( player.GetAll() ) do
                local uniqueID = client:AccountID()
                timer.Adjust('GasKillCD.'..uniqueID, newValue)
            end
        end
    end, {
        data = {min = 1, max = 60},
        category = PLUGIN.name
    })

    function PLUGIN:SetupAreaProperties()
        ix.area.AddType("gas")
    end

    if (CLIENT) then
        ix.bar.Add(function()
            local character = LocalPlayer():GetCharacter()
            local value = 0

            if (character) then
                value = character:GetToxicity()
            end

            return math.Round(value * 0.01, 2), PLUGIN:GetToxicityText(value)
        end, Color(173, 59, 30), 90, "gas")

        function PLUGIN:GetToxicityText(toxicity)
            if (toxicity <= 30) then
                return "Satisfied"
            elseif (toxicity <= 50) then
                return "Slightly Poisoned"
            elseif (toxicity <= 65) then
                return "Poisoned"
            elseif (toxicity <= 80) then
                return "Very Poisoned"
            elseif (toxicity <= 100) then
                return "Dying of toxicity"
            end

            return L("unknown")
        end

        function PLUGIN:RenderScreenspaceEffects()
            local client = LocalPlayer()

            if (!IsValid(client) or client:GetMoveType() == MOVETYPE_NOCLIP) then
                return
            end

            local character = client:GetCharacter()

            if (!character) then
                return
            end

            local blurAmount = 0
            local toxicity = math.max(character:GetToxicity() - 30, 0)

            if (toxicity > 0) then
                blurAmount = 1 - (toxicity * 0.25 / 10)
            end

            if (blurAmount > 0) then
                DrawMotionBlur(blurAmount, 0.5, 0.03)
            end
        end
    end
end