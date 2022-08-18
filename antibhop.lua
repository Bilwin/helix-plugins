PLUGIN.name     = 'Anti-Bhop'
PLUGIN.author   = 'Bilwin'

function PLUGIN:OnPlayerHitGround(client)
    local vel = client:GetVelocity()
    client:SetVelocity( Vector( - ( vel.x * 0.45 ), - ( vel.y * 0.45 ), 0) )
end