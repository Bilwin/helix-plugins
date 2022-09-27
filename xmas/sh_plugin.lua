PLUGIN.name         = 'Xmas'
PLUGIN.author       = 'Bilwin'

-- for better experience
-- https://steamcommunity.com/sharedfiles/filedetails/?id=1596556401
-- https://github.com/Bilwin/helix-plugins/blob/main/.deprecated/fog.lua

if CLIENT then
    PLUGIN.BreathTextures = {
        Material("particle/smokesprites_0001"),
        Material("particle/smokesprites_0002"),
        Material("particle/smokesprites_0003")
    }

    local function breath(client, size)
        if not client:Alive() then return end
        if client:WaterLevel() >= 3 then return end
        if size <= 0 then return end

        if not emit then
            emit = ParticleEmitter(LocalPlayer():GetPos(),false)
        else
            emit:SetPos(LocalPlayer():GetPos())
        end

        local mpos
        if GetViewEntity() ~= client then
            local att = client:LookupAttachment('mouth')
            if att <= 0 then return end
            mpos = client:GetAttachment(att)
        else
            local ang,pos = EyeAngles(), client:EyePos()
            mpos = {Pos = pos + ang:Forward() * 3 - ang:Up() * 2, Ang = ang}
        end

        if not mpos || not mpos.Pos then return end

        local p = emit:Add(PLUGIN.BreathTextures[math.random(#PLUGIN.BreathTextures)], mpos.Pos)
        p:SetStartSize(1)
        p:SetEndSize(size)
        p:SetStartAlpha(math.random(25,35))
        p:SetEndAlpha(0)
        p:SetLifeTime(0)
        p:SetGravity(Vector(0,0,4))
        p:SetDieTime(1)
        p:SetLighting(false)
        p:SetRoll(math.random(360))
        p:SetRollDelta(math.Rand(-0.5,0.5))
        p:SetVelocity(mpos.Ang:Forward() * 2 + client:GetVelocity() / 5)
    end

    function PLUGIN:PostPlayerDraw(client)
        if (client._sf_breath || 0) > SysTime() then return end

        local len = client:GetVelocity():Length()
        local t = math.Clamp(1 - (len / 100),0.2,1)

        client._sf_breath = math.Rand(t,t * 2) + SysTime()
        breath(client, 5 + (len / 100))
    end

    local nextSnow = 0
    function PLUGIN:Think()
        if nextSnow > CurTime() then return end

        local tr = util.TraceLine({
            start = LocalPlayer():EyePos(),
            endpos = LocalPlayer():EyePos() + Vector(0, 0, 10000),
            filter = function(ent)
                if ent:IsPlayer() then return false end
                return true
            end
        })
        LocalPlayer()._sf_insnow = true

        if tr.HitSky then
            LocalPlayer()._sf_insnow = true
            local snow = EffectData()
            snow:SetMagnitude(15)
            snow:SetScale(3)
            snow:SetRadius(LocalPlayer():GetPos().z + 400)
            util.Effect('xmas_snow', snow)
        else
            LocalPlayer()._sf_insnow = false
        end

        nextSnow = CurTime() + 0.15
    end

end

