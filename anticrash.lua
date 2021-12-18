
local PLUGIN = PLUGIN
PLUGIN.name = 'Anti-Crash using items'
PLUGIN.author = 'Bilwin'

function PLUGIN:ShouldCollide(f, t)
    if f:GetClass() == 'ix_item' && t:GetClass() == 'ix_item' then
        return false
    end
end