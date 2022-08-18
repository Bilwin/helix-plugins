
local PLUGIN = PLUGIN
PLUGIN.name = "Item collide fixer"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Stop killing server through item collisions bounds"
PLUGIN.BlockedCollideEntities = {}
PLUGIN.BlockedCollideEntities['ix_item'] = true
PLUGIN.BlockedCollideEntities['ix_money'] = true
PLUGIN.BlockedCollideEntities['ix_shipment'] = true

function PLUGIN:OnItemSpawned(ent)
    ent:SetCustomCollisionCheck(true)
end

function PLUGIN:OnMoneySpawned(ent)
    ent:SetCustomCollisionCheck(true)
end

function PLUGIN:OnShipmentSpawned(ent)
    ent:SetCustomCollisionCheck(true)
end

function PLUGIN:ShouldCollide(ent1, ent2)
    if self.BlockedCollideEntities[ent1:GetClass()] && self.BlockedCollideEntities[ent2:GetClass()] then return false end
end