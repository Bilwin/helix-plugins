PLUGIN.name     = 'Item\'s collide disabler'
PLUGIN.author   = 'Bilwin'

function PLUGIN:ShouldCollide(f, t)
    if f:GetClass() == 'ix_item' && t:GetClass() == 'ix_item' then
        return false
    end
end