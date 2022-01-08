
function PLUGIN:CanPlayerUseCharacter(client, character)
    if client:IsRestricted() then return false end
end