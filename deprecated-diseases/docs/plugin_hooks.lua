
-- @Hook: CanPlayerGetDisease
-- @Realm: Server
-- @Description: Can a player get sick with the resulting disease?
-- @Arguments: Player player, String disease
-- @Return: true if player can't get disease, false if player can get disease

function PLUGIN:CanPlayerGetDisease(player, disease)
end

-- @Hook: CanPlayerDisinfect
-- @Realm: Server
-- @Description: Can a player cure disease?
-- @Arguments: Player player, String disease
-- @Return: true if player can't cure disease, false if player can cure disease

function PLUGIN:CanPlayerDisinfect(player, disease)
end

-- @Hook: PlayerInfected
-- @Realm: Server
-- @Description: Calling when player get disease
-- @Arguments: Player player, String disease
-- @Return: nothing

function PLUGIN:PlayerInfected(player, disease)
end

-- @Hook: PlayerDisinfected
-- @Realm: Server
-- @Description: Calling when player cure disease
-- @Arguments: Player player, String disease
-- @Return: nothing

function PLUGIN:PlayerDisinfected(player, disease)
end
