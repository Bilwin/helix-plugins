PLUGIN.name     = 'Collide disabler'
PLUGIN.author   = 'Bilwin'

function PLUGIN:ShouldCollide(a, b)
    if a:GetClass() == 'ix_item' && b:GetClass() == 'ix_item' then
        return false
    end
end