PLUGIN.name     = 'Collide disabler'
PLUGIN.author   = 'Bilwin'

function PLUGIN:ShouldCollide(a, b)
    if a:GetClass() == 'ix_item' && b:GetClass() == 'ix_item' then
        return false
    end
end

if SERVER then
    function PLUGIN:OnItemSpawned(ent)
        ent:SetCustomCollisionCheck(true)
    end
end