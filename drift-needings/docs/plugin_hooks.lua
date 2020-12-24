
-- @Hook: EnablePlayerHunger
-- @Realm: Server
-- @Description: Does hunger and thirst enable the player?
-- @Arguments: Player player
-- @Return: false if the player does not need to turn on hunger

function PLUGIN:EnablePlayerHunger(player)
end

-- @Hook: CanPlayerThirst
-- @Realm: Server
-- @Description: Can a player get thirsty?
-- @Arguments: Player player
-- @Return: false if the player cannot get thirsty

function PLUGIN:CanPlayerThirst(player)
end

-- @Hook: CanPlayerHunger
-- @Realm: Server
-- @Description: Can the player starve?
-- @Arguments: Player player
-- @Return: false if the player cannot starve

function PLUGIN:CanPlayerHunger(player)
end
