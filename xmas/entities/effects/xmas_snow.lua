
local function fm_snowcollide(particle, hitpos, normal)
	particle:SetEndAlpha(200)
	particle:SetStartSize(1)
	particle:SetEndSize(1)
end

function EFFECT:Init(data)
	self.Magnitude = data:GetMagnitude()
	self.Lifetime = data:GetScale()
	self.Spawnheight = data:GetRadius()

	local emitter = ParticleEmitter(LocalPlayer():GetPos())

	for i=0, math.Round(self.Magnitude) do
		local a = math.random(9999)
		local b = math.random(1,180)
		local distance = 2048
		local x = math.sin(b)*math.sin(a)*distance
		local y = math.sin(b)*math.cos(a)*distance
		local z = math.cos(b)*distance
		local offset = Vector(x,y,self.Spawnheight)
		local spawnpos = LocalPlayer():GetPos() + offset
		local particle = emitter:Add("particle/snow", spawnpos)

		if (particle) then
			particle:SetVelocity(Vector(math.random(-400,400),math.random(-400,400),-300))
			particle:SetRoll(math.random(-360,360))
			particle:SetLifeTime(0)
			particle:SetDieTime(self.Lifetime + math.Rand(-1,1))
			particle:SetStartAlpha(5)
			particle:SetEndAlpha(254)
			particle:SetStartSize(1)
			particle:SetEndSize(1)
			particle:SetAirResistance(50)
			particle:SetGravity(Vector(0,0,math.random(-100,-50)))
			particle:SetCollide(true)
			particle:SetCollideCallback(fm_snowcollide)
			particle:SetBounce(.01)
			particle:SetColor(255,255,255,255)
		end

	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
