
local PLUGIN = PLUGIN
PLUGIN.name = 'Simfphys Base Support'
PLUGIN.author = 'Bilwin'

-- stop sparkling
function PLUGIN:simfphysPhysicsCollide() return true end
hook.Remove('HUDPaint', 'simfphys_HUD') -- you can comment this