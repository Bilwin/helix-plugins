
local PLUGIN = PLUGIN
PLUGIN.name = "Primary Needs"
PLUGIN.description = "Adds thirst and hunger to the player"
PLUGIN.author = "Bilwin"

ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")

do
    ix.char.RegisterVar("hunger", {
        field = "hunger",
        fieldType = ix.type.number,
        default = 0,
        bNoDisplay = true
    })

    ix.char.RegisterVar("thirst", {
        field = "thirst",
        fieldType = ix.type.number,
        default = 0,
        bNoDisplay = true
    })
end

do
    ix.config.Add("needsTickTime", 300, "How many seconds between each player computation of the player", function(oldValue, newValue)
        if (SERVER) then
            for _, client in ipairs( player.GetAll() ) do
                local uniqueID = 'ixPrimaryNeeds.' .. client:AccountID()
                PLUGIN:CreateNeedsTimer(client, client:GetCharacter(), uniqueID)
            end
        end
    end, {
        data = {min = 1, max = 300},
        category = PLUGIN.name
    })

    ix.config.Add("decreaseCharacterHealthOnFullNeeds", true, "Whether to take away health from a player when hungry and thirsty", nil, {
        category = PLUGIN.name
    })

    ix.config.Add("hungerHours", 6, "How many hours will it take a player to reduce hunger to 60", nil, {
        data = {min = 1, max = 24},
        category = PLUGIN.name
    })

    ix.config.Add("thirstHours", 4, "How many hours will it take a player to reduce thirst to 60", nil, {
        data = {min = 1, max = 24},
        category = PLUGIN.name
    })
end

if (CLIENT) then
    ix.bar.Add(function()
        local character = LocalPlayer():GetCharacter()
        local value = 0

        if (character) then
            value = character:GetHunger()
        end

        return math.Round(value * 0.01, 2), PLUGIN:GetHungerText(value)
    end, Color(197, 145, 77), nil, "hunger")

    ix.bar.Add(function()
        local character = LocalPlayer():GetCharacter()
        local value = 0

        if (character) then
            value = character:GetThirst()
        end

        return math.Round(value * 0.01, 2), PLUGIN:GetThirstText(value)
    end, Color(30, 157, 173), nil, "thirst")

    function PLUGIN:GetHungerText(hunger)
        if (hunger <= 30) then
            return "Сыт"
        elseif (hunger <= 50) then
            return "Немного голоден"
        elseif (hunger <= 65) then
            return "Голоден"
        elseif (hunger <= 99) then
            return "Очень голоден"
        elseif (hunger <= 100) then
            return "Умирает от голода"
        end

        return L("unknown")
    end

    function PLUGIN:GetThirstText(thirst)
        if (thirst <= 30) then
            return "Насыщен"
        elseif (thirst <= 50) then
            return "Немного насыщен"
        elseif (thirst <= 65) then
            return "Жажда"
        elseif (thirst <= 99) then
            return "Обезвоженный"
        elseif (thirst <= 100) then
            return "Умирает от обезвоживания"
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
        local hunger = math.max(character:GetHunger() - 90, 0)
        local thirst = math.max(character:GetThirst() - 90, 0)

        if (hunger > 0) then
            blurAmount = 1 - (hunger * 0.25 / 10)
        end

        if (thirst > 0) then
            blurAmount = blurAmount + (1 - (thirst * 0.25 / 10))
        end

        if (blurAmount > 0) then
            DrawMotionBlur(blurAmount, 0.5, 0.03)
        end
    end
end
