--source: https://github.com/cresterienvogel/gmod-misc/blob/master/ent_timer.lua

local ent = FindMetaTable("Entity")

function ent:_SetSimpleTimer(delay, func)
	timer.Simple(delay, function()
		if IsValid(self) then
			func()
		end
	end)
end

function ent:_SetTimer(identifier, delay, repetitions, func)
	timer.Create(self:EntIndex() .. "[" .. identifier .. "]", delay, repetitions, function()
		if IsValid(self) then
			func()
		end
	end)
end

function ent:_RemoveTimer(identifier)
	timer.Remove(self:EntIndex() .. "[" .. identifier .. "]")
end

function ent:_TimerExists(identifier)
	local _identifier = self:EntIndex() .. "[" .. identifier .. "]"
	return timer.Exists(_identifier), _identifier
end