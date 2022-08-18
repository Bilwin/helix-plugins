PLUGIN.name = 'Simfphys Useless Things'
PLUGIN.author = 'Bilwin'

-- stop sparkling
function PLUGIN:simfphysPhysicsCollide()
    return true
end