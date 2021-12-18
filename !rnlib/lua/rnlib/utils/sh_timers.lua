
local timer_Simple = timer.Simple
local timer_Create = timer.Create
local timer_Remove = timer.Remove
local timer_Exists = timer.Exists

function ENTITY:_SetSimpleTimer(delay, func)
	timer_Simple(delay, function()
		if IsValid(self) then
			func()
		end
	end)
end

function ENTITY:_SetTimer(identifier, delay, repetitions, func)
	local index = self:EntIndex()
	timer_Create(index .. "[" .. identifier .. "]", delay, repetitions, function()
		if IsValid(self) then
			func()
		else
			timer_Remove(index .. "[" .. identifier .. "]")	
		end
	end)
end

function ENTITY:_RemoveTimer(identifier)
	timer_Remove(self:EntIndex() .. "[" .. identifier .. "]")
end

function ENTITY:_TimerExists(identifier)
	local _identifier = self:EntIndex() .. "[" .. identifier .. "]"
	return timer_Exists(_identifier), _identifier
end
