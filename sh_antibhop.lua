
PLUGIN.name = "Anti-Bhop"
PLUGIN.author = "Bilwin"
PLUGIN.description = "..."
PLUGIN.schema = "Any"

function PLUGIN:OnPlayerHitGround( pl )
    local vel = pl:GetVelocity()
    pl:SetVelocity( Vector( - ( vel.x * 0.75 ), - ( vel.y * 0.75 ), 0) )
end